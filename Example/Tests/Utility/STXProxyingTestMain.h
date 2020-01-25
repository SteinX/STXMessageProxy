//
//  STXProxyingTestMain.h
//  STXMessageProxy_Tests
//
//  Created by Yiming XIA on 2019/2/8.
//  Copyright © 2019 SteinX. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@protocol STXProxyingTestMainDelegate <NSObject>

- (void)call_delegationWithParam:(id)parameter;
- (NSInteger)call_delegationWithReturnValue;
- (CGRect)call_delegationWithStructReturnValue;

@end

@interface STXProxyingTestMain : NSObject

@property (nonatomic, weak) id<STXProxyingTestMainDelegate> delegate;

- (void)call_delegationWithParam:(id)parameter;
- (NSInteger)call_delegationWithReturnVal;
- (CGRect)call_delegationWithStructReturnVal;

@end

NS_ASSUME_NONNULL_END
