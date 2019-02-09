//
//  STXDeallocNotifierTests.m
//  STXMessageProxy_Tests
//
//  Created by Yiming XIA on 2019/2/9.
//  Copyright © 2019 SteinX. All rights reserved.
//

@import XCTest;

#import "STXDeallocNotifierTestDelegate.h"

@interface STXDeallocNotifierTests : XCTestCase
@property (nonatomic) STXDeallocNotifierTestDelegate *deallocNotifyDelegate;
@end

@implementation STXDeallocNotifierTests

- (void)setUp {
    [super setUp];
    
    self.deallocNotifyDelegate = [STXDeallocNotifierTestDelegate new];
}

- (void)testOnDeallocEventGetNotified {
    __auto_type objects = [NSMutableArray arrayWithCapacity:5];
    
    for (NSInteger i = 0; i < 5; i++) {
        __auto_type obj = [NSObject new];
        [objects addObject:obj];
        
        obj.stx_deallocNotifier.delegate = self.deallocNotifyDelegate;
    }
    
    [objects removeAllObjects];
    
    XCTAssert(self.deallocNotifyDelegate.deallocatedIdentifiers.count == 5, @"All deallocation events should be received by test delegate.");
}

@end
