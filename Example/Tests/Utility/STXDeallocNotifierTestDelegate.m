//
//  STXDeallocNotifierTestDelegate.m
//  STXMessageProxy_Tests
//
//  Created by Yiming XIA on 2019/2/9.
//  Copyright © 2019 SteinX. All rights reserved.
//

#import "STXDeallocNotifierTestDelegate.h"

@interface STXDeallocNotifierTestDelegate ()
@property (nonatomic) NSMutableSet<NSUUID *> *identifierSet;
@end

@implementation STXDeallocNotifierTestDelegate

- (instancetype)init {
    if (self = [super init]) {
        self.identifierSet = [NSMutableSet set];
    }
    return self;
}

- (void)stx_objectDidDealloc:(NSUUID *)identifier {
    [self.identifierSet addObject:identifier];
}

- (NSSet<NSUUID *> *)deallocatedIdentifiers {
    return [self.identifierSet copy];
}

@end
