//
//  STXMessageProxy+TestOnly.h
//  STXMessageProxy_Tests
//
//  Created by Yiming XIA on 2019/2/9.
//  Copyright © 2019 SteinX. All rights reserved.
//

#import <STXMessageProxy/STXMessageProxy.h>

NS_ASSUME_NONNULL_BEGIN

@interface STXMessageProxy (TestOnly)

@property (readonly) BOOL isAllSubscriberGone;

@end

NS_ASSUME_NONNULL_END
