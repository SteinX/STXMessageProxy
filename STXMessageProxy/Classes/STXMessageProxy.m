//
//  STXMessageProxy.m
//  STXMessageProxy
//
//  Created by Yiming XIA on 2019/2/7.
//

#import "STXMessageProxy.h"
#import "NSObject+DeallocNotifiy.h"

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
    if ([self.class respondsToSelector:aSelector]) {
        return YES;
    }
    
    return [self.source respondsToSelector:aSelector];
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
    void *returnVal = NULL;
    if ([self.source respondsToSelector:targetSEL]) {
        [invocation invokeWithTarget:self.source];
        [invocation getReturnValue:&returnVal];
    }
    
    __auto_type subscriberEnumerator = self.broadcastSubscribers.objectEnumerator;
    id subscriber = subscriberEnumerator.nextObject;
    
    while (subscriber) {
        if ([subscriber respondsToSelector:targetSEL]) {
            [invocation invokeWithTarget:subscriber];
        }
        
        subscriber = [subscriberEnumerator nextObject];
    }
    
    if (returnVal) {
        [invocation setReturnValue:&returnVal];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    __auto_type signature = [[self.source class] methodSignatureForSelector:sel] ?: [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
    __auto_type runningMode = [self runningModeForSelector:sel];
    
    if (runningMode != STXMessageProxyRunningModeInterception) {
        return signature;
    }
    
    return [[self.interceptor class] methodSignatureForSelector:sel] ?: signature;
}

#pragma mark - STXDeallocNotifierDelegate
- (void)stx_objectDidDealloc:(NSUUID *)identifier {
    [self.broadcastSubscribers removeObjectForKey:identifier];
    NSLog(@"[DEALLOC]Subscriber count %zd", self.broadcastSubscribers.count);
}

#pragma mark - Private
- (STXMessageProxyRunningMode)runningModeForSelector:(SEL)selector {
    __auto_type mode = (STXMessageProxyRunningMode)[[self.runningModeMap objectForKey:NSStringFromSelector(selector)] unsignedIntegerValue];
    return mode;
}

@end
