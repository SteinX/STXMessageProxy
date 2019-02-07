//
//  NSObject+DeallocNotifiy.m
//  STXMessageProxy
//
//  Created by Yiming XIA on 2019/2/9.
//

#import "NSObject+DeallocNotifiy.h"

#import <objc/runtime.h>

@implementation STXDeallocNotifier

- (instancetype)init {
    if (self = [super init]) {
        _identifier = [NSUUID UUID];
    }
    return self;
}

- (void)dealloc {
    [self.delegate stx_objectDidDealloc:self.identifier];
}

@end

@implementation NSObject (DeallocNotifiy)

- (STXDeallocNotifier *)stx_deallocNotifier {
    STXDeallocNotifier *notifier = objc_getAssociatedObject(self, @selector(stx_deallocNotifier));
    if (!notifier) {
        notifier = [STXDeallocNotifier new];
        objc_setAssociatedObject(self, @selector(stx_deallocNotifier), notifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return notifier;
}

@end
