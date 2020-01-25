//
//  STXMessageProxyTests.m
//  STXMessageProxy_Tests
//
//  Created by Yiming XIA on 2019/2/8.
//  Copyright © 2019 SteinX. All rights reserved.
//

@import XCTest;

#import "STXMessageProxy+TestOnly.h"

#import "STXProxyingTestMain.h"
#import "STXTestMainDelegateProxy.h"
#import "STXTestMainDelegateInterceptor.h"
#import "STXTestMainDelegateImpl.h"

@interface STXMessageProxyTests : XCTestCase
@property (nonatomic) STXTestMainDelegateProxy *proxy;

@property (nonatomic) STXProxyingTestMain *mainObj;
@property (nonatomic) STXTestMainDelegateImpl *orgImpl;
@property (nonatomic) STXTestMainDelegateInterceptor *interceptor;
@end

@implementation STXMessageProxyTests

- (void)setUp {
    [super setUp];
    
    if (!self.mainObj) {
        self.mainObj = [STXProxyingTestMain new];
    }
    
    if (!self.orgImpl) {
        self.orgImpl = [STXTestMainDelegateImpl new];
    }
    
    if (!self.interceptor) {
        self.interceptor = [STXTestMainDelegateInterceptor new];
    }
    
    self.proxy = [[STXTestMainDelegateProxy alloc] initWithSource:self.orgImpl];
    self.proxy.interceptor = self.interceptor;
    self.mainObj.delegate = self.proxy;
}

- (void)testOnInterceptingCallWithParameter {
    [self.proxy setProxyingSelector:@selector(call_delegationWithParam:)
                    withRunningMode:STXMessageProxyRunningModeInterception];
    
    [self.mainObj call_delegationWithParam:@(10)];
    
    XCTAssert(self.orgImpl.evaluationValue == 0, @"Evaluation value should not be changed for original delegate, since it's intercepted");
    XCTAssert(self.interceptor.evaluationValue == 10, @"Evaluation should be changed since it intercepted the call");
}

- (void)testOnInterceptingCallWithReturnValue {
    [self.proxy setProxyingSelector:@selector(call_delegationWithReturnValue)
                    withRunningMode:STXMessageProxyRunningModeInterception];
    
    __auto_type returnVal = [self.mainObj call_delegationWithReturnVal];
    
    XCTAssert(returnVal == 20, @"Return value is supposed to be 20, since it's intercepted");
}

- (void)testOnInterceptingCallWithBothCases {
    [self.proxy setProxyingSelector:@selector(call_delegationWithParam:)
                    withRunningMode:STXMessageProxyRunningModeInterception];
    [self.proxy setProxyingSelector:@selector(call_delegationWithReturnValue)
                    withRunningMode:STXMessageProxyRunningModeInterception];
    
    __auto_type returnVal = [self.mainObj call_delegationWithReturnVal];
    
    XCTAssert(returnVal == 20, @"Return value is supposed to be 20, since it's intercepted");
    
    [self.mainObj call_delegationWithParam:@(10)];
    
    XCTAssert(self.orgImpl.evaluationValue == 0, @"Evaluation value should not be changed for original delegate, since it's intercepted");
    XCTAssert(self.interceptor.evaluationValue == 10, @"Evaluation should be changed since it intercepted the call");
}

- (void)testOnBroardcastingCallWithParameterNoSubscriber {
    [self.proxy setProxyingSelector:@selector(call_delegationWithParam:)
                    withRunningMode:STXMessageProxyRunningModeBroadcasting];
    
    [self.mainObj call_delegationWithParam:@(10)];
    
    XCTAssert(self.orgImpl.evaluationValue == 12, @"Evaluation value is supposed to be changed, broadcasting will not intercept the invocation chain.");
    XCTAssert(self.interceptor.evaluationValue == 0, @"Evaluation value should not be changed for the interceptor, since it's in broadcasting");
}

- (void)testOnBroardcastingCallWithReturnValueNoSubscriber {
    [self.proxy setProxyingSelector:@selector(call_delegationWithReturnValue)
                    withRunningMode:STXMessageProxyRunningModeBroadcasting];
    
    __auto_type returnVal = [self.mainObj call_delegationWithReturnVal];
    
    XCTAssert(returnVal == 10, @"Return value is supposed to be 10, since no interception will happen in the broadcasting mode");
}

- (void)testOnBroardcastingCallWithParameterAndSubscribers {
    [self.proxy setProxyingSelector:@selector(call_delegationWithParam:)
                    withRunningMode:STXMessageProxyRunningModeBroadcasting];
    
    __auto_type subscriber1 = [STXTestMainDelegateImpl new];
    __auto_type subscriber2 = [STXTestMainDelegateInterceptor new];
    
    [self.proxy addBroadcastSubscriber:subscriber1];
    [self.proxy addBroadcastSubscriber:subscriber2];
    
    [self.mainObj call_delegationWithParam:@(10)];
    
    XCTAssert(self.orgImpl.evaluationValue == 12, @"Evaluation value is supposed to be changed, broadcasting will not intercept the invocation chain.");
    XCTAssert(self.interceptor.evaluationValue == 0, @"Evaluation value should not be changed for the interceptor, since it's in broadcasting");
    
    XCTAssert(subscriber1.evaluationValue == 12, @"Evaluation value is supposed to be changed in the broadcasting mode for subscribers");
    XCTAssert(subscriber2.evaluationValue == 10, @"Evaluation value is supposed to be changed, broadcasting will not intercept the invocation chain.");
}

- (void)testOnBroardcastingCallWithReturnValueAndSubscribers {
    [self.proxy setProxyingSelector:@selector(call_delegationWithReturnValue)
                    withRunningMode:STXMessageProxyRunningModeBroadcasting];
    
    __auto_type subscriber1 = [STXTestMainDelegateImpl new];
    __auto_type subscriber2 = [STXTestMainDelegateInterceptor new];
    
    [self.proxy addBroadcastSubscriber:subscriber1];
    [self.proxy addBroadcastSubscriber:subscriber2];
    
    __auto_type returnVal = [self.mainObj call_delegationWithReturnVal];
    
    XCTAssert(returnVal == 10, @"Return value is supposed to be returned from the source, since no interception will happen in the broadcasting mode");
    XCTAssert(subscriber1.evaluationValue == 20, @"Evaluation value is supposed to be 20 for subscriber1, as it's be invoked from the broadcasting");
    XCTAssert(subscriber2.evaluationValue == 40, @"Evaluation value is supposed to be 40 for subscriber2, as it's be invoked from the broadcasting");
}

- (void)testOnBroadcastingSubscribersNotGetRetained {
    __auto_type subscriber1 = [STXTestMainDelegateImpl new];
    __auto_type subscriber2 = [STXTestMainDelegateInterceptor new];
    
    [self.proxy addBroadcastSubscriber:subscriber1];
    [self.proxy addBroadcastSubscriber:subscriber2];
    
    __auto_type expect = [self expectationWithDescription:@"Subscription dealloc test"];
    
    subscriber1 = nil;
    subscriber2 = nil;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        XCTAssert(self.proxy.isAllSubscriberGone, @"Subscribers should not be retained");
        [expect fulfill];
    });
    
    [self waitForExpectations:@[expect] timeout:1.0];
}

- (void)testOnPrimitiveReturnTypeFromProxyingMethod {
    [self.proxy setProxyingSelector:@selector(call_delegationWithStructReturnValue)
                    withRunningMode:STXMessageProxyRunningModeBroadcasting];
    
    __auto_type subscriber1 = [STXTestMainDelegateImpl new];
    __auto_type subscriber2 = [STXTestMainDelegateInterceptor new];
    
    [self.proxy addBroadcastSubscriber:subscriber1];
    [self.proxy addBroadcastSubscriber:subscriber2];
    
    __auto_type returnVal = [self.mainObj call_delegationWithStructReturnVal];
    
    XCTAssert(CGRectEqualToRect(returnVal, CGRectMake(1, 1, 10, 10)),
              @"Return value is supposed to be returned from the source, since no interception will happen in the broadcasting mode");
    XCTAssert(CGRectEqualToRect(subscriber1.evaluationStructValue, CGRectMake(1, 1, 10, 10)),
              @"Evaluation value is supposed to be CGRectMake(1, 1, 10, 10) for subscriber1, as it's be invoked from the broadcasting");
    XCTAssert(CGRectEqualToRect(subscriber2.evaluationStructValue, CGRectNull),
              @"Evaluation value is supposed to be CGRectNull for subscriber2, as it's be invoked from the broadcasting");
}

@end
