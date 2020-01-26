//
//  STXProxyingTestMain.h
//  STXMessageProxy_Tests
//
//  Created by Yiming XIA on 2019/2/8.
//  Copyright © 2019 SteinX. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

typedef NSString * __nullable(^STXObjectBlock)(NSNumber *);
typedef void(^STXStructBlock)(CGRect);

@protocol STXProxyingTestMainDelegate <NSObject>

- (void)call_delegationWithParam:(id)parameter;
- (NSInteger)call_delegationWithReturnValue;
- (CGRect)call_delegationWithStructReturnValue;

- (NSNumber *)call_delegationWithObjectTypeReturnValue;
- (STXObjectBlock)call_delegationWithObjectBlockReturnValue;

@end

@interface STXProxyingTestMain : NSObject

@property (nonatomic, weak) id<STXProxyingTestMainDelegate> delegate;

- (void)call_delegationWithParam:(id)parameter;
- (NSInteger)call_delegationWithReturnVal;
- (CGRect)call_delegationWithStructReturnVal;
- (NSNumber *)call_delegationWithObjectReturnVal;
- (STXObjectBlock)call_delegationWithObjectBlockReturnVal;

@end

NS_ASSUME_NONNULL_END
