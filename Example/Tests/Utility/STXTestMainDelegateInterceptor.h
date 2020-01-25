//
//  STXTestMainDelegateInterceptor.h
//  STXMessageProxy_Tests
//
//  Created by Yiming XIA on 2019/2/8.
//  Copyright © 2019 SteinX. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STXProxyingTestMain.h"

NS_ASSUME_NONNULL_BEGIN

@interface STXTestMainDelegateInterceptor : NSObject <STXProxyingTestMainDelegate>

@property (nonatomic, readonly, assign) NSInteger evaluationValue;
@property (nonatomic, readonly, assign) CGRect evaluationStructValue;

@end

NS_ASSUME_NONNULL_END
