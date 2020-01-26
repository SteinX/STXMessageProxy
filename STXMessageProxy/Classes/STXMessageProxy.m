//
//  STXMessageProxy.m
//  STXMessageProxy
//
//  Created by Yiming XIA on 2019/2/7.
//

#import "STXMessageProxy.h"
#import "NSObject+DeallocNotifiy.h"

NS_INLINE BOOL CStringEquals(const char *str1, const char *str2) {
    return strcmp(str1, str2) == 0;
}

NS_INLINE BOOL isObjectType(const char *typeEncoding) {
    return CStringEquals(typeEncoding, "@") // object
    || CStringEquals(typeEncoding, "@?") // block
    || CStringEquals(typeEncoding, "#"); // metaclass
}

NS_INLINE BOOL isVoidReturn(const char *typeEncoding) {
    return CStringEquals(typeEncoding, "v");
}

NS_INLINE NSMethodSignature *methodSignature(id object, SEL sel) {
    __auto_type signature = [NSStringFromSelector(sel) hasPrefix:@"+"] ?
    [[object class] methodSignatureForSelector:sel] : [object methodSignatureForSelector:sel];
    
    return signature != nil ? signature : [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
}

@interface STXMessageProxy () <STXDeallocNotifierDelegate>

@property (nonatomic, weak) id<NSObject> source;

@property (nonatomic) NSMapTable *broadcastSubscribers;
@property (nonatomic) NSMapTable<NSString *, NSNumber *> *runningModeMap;

@end

@implementation STXMessageProxy

- (instancetype)initWithSource:(id<NSObject>)source {
    if (self) {
        _source = source;
        _broadcastSubscribers = [NSMapTable strongToWeakObjectsMapTable];
        _runningModeMap = [NSMapTable strongToStrongObjectsMapTable];
    }
    return self;
}

#pragma mark - Public
- (void)setProxyingSelector:(SEL)selector withRunningMode:(STXMessageProxyRunningMode)mode {
    [self.runningModeMap setObject:@(mode) forKey:NSStringFromSelector(selector)];
}

- (void)addBroadcastSubscriber:(id)subscriber {
    if ([subscriber isKindOfClass:NSObject.class]) {
        __auto_type notifier = [(NSObject *)subscriber stx_deallocNotifier];
        notifier.delegate = self;
        
        [self.broadcastSubscribers setObject:subscriber forKey:notifier.identifier];
    } else {
        [self.broadcastSubscribers setObject:subscriber forKey:[NSUUID UUID]];
    }
}

#pragma mark - Proxying
- (BOOL)respondsToSelector:(SEL)aSelector {
    __auto_type runningMode = [self runningModeForSelector:aSelector];
    __auto_type canSourceRespond = [self.source respondsToSelector:aSelector];
    
    if (runningMode != STXMessageProxyRunningModeInterception) {
        return canSourceRespond;
    }
    
    return [self.interceptor respondsToSelector:aSelector] ?: canSourceRespond;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    if ([super conformsToProtocol:aProtocol]) {
        return YES;
    }
    
    return [self.source conformsToProtocol:aProtocol];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    __auto_type runningMode = [self runningModeForSelector:invocation.selector];
    
    switch (runningMode) {
        case STXMessageProxyRunningModeInterception:
            [self interceptWithInvocation:invocation];
            break;
        case STXMessageProxyRunningModeBroadcasting:
            [self broadcastWithInvocation:invocation];
            break;
        default:
            break;
    }
}

- (void)interceptWithInvocation:(NSInvocation *)invocation {
    __auto_type targetSEL = invocation.selector;
    
    if ([self.interceptor respondsToSelector:targetSEL]) {
        [invocation invokeWithTarget:self.interceptor];
        return;
    }
    
    if ([self.source respondsToSelector:targetSEL]) {
        [invocation invokeWithTarget:self.source];
    }
}

- (void)broadcastWithInvocation:(NSInvocation *)invocation {
    __auto_type targetSEL = invocation.selector;
    
    // In broadcasting mode, return value of the invocation should be the one returned from the source,
    // and the source should be informed at first
    void *returnValBuffer = NULL;
    id returnObj = nil;
    
    if ([self.source respondsToSelector:targetSEL]) {
        [invocation invokeWithTarget:self.source];
        
        __auto_type retType = invocation.methodSignature.methodReturnType;
        
        if (!isVoidReturn(retType)) {
            if (isObjectType(retType)) {
                [invocation getReturnValue:&returnObj];
            } else {
                returnValBuffer = malloc(invocation.methodSignature.methodReturnLength);
                [invocation getReturnValue:returnValBuffer];
            }
        }
    }
    
    __auto_type subscriberEnumerator = self.broadcastSubscribers.objectEnumerator;
    id subscriber = subscriberEnumerator.nextObject;
    
    while (subscriber != nil) {
        if ([subscriber respondsToSelector:targetSEL]) {
            [invocation invokeWithTarget:subscriber];
        }
        
        subscriber = [subscriberEnumerator nextObject];
    }
    
    if (returnObj != nil) {
        [invocation setReturnValue:&returnObj];
    }
    else if (returnValBuffer != NULL) {
        [invocation setReturnValue:returnValBuffer];
        free(returnValBuffer);
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    __auto_type runningMode = [self runningModeForSelector:sel];
    
    switch (runningMode) {
        case STXMessageProxyRunningModeInterception:
            return methodSignature(self.interceptor, sel);
        case STXMessageProxyRunningModeBroadcasting:
        default:
            return methodSignature(self.source, sel);
    }
}

#pragma mark - STXDeallocNotifierDelegate
- (void)stx_objectDidDealloc:(NSUUID *)identifier {
    [self.broadcastSubscribers removeObjectForKey:identifier];
}

#pragma mark - Private
- (STXMessageProxyRunningMode)runningModeForSelector:(SEL)selector {
    __auto_type mode = (STXMessageProxyRunningMode)[[self.runningModeMap objectForKey:NSStringFromSelector(selector)] unsignedIntegerValue];
    return mode;
}

@end
