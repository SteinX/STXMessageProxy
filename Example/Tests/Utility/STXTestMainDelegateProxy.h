//
//  STXTestMainDelegateProxy.h
//  STXMessageProxy_Tests
//
//  Created by Yiming XIA on 2019/2/8.
//  Copyright © 2019 SteinX. All rights reserved.
//

#import <STXMessageProxy/STXMessageProxy.h>

#import "STXProxyingTestMain.h"

NS_ASSUME_NONNULL_BEGIN

@interface STXTestMainDelegateProxy : STXMessageProxy <STXProxyingTestMainDelegate>

@end

NS_ASSUME_NONNULL_END
