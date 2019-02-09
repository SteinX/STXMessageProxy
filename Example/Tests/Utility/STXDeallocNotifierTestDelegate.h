//
//  STXDeallocNotifierTestDelegate.h
//  STXMessageProxy_Tests
//
//  Created by Yiming XIA on 2019/2/9.
//  Copyright © 2019 SteinX. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+DeallocNotifiy.h"

NS_ASSUME_NONNULL_BEGIN

@interface STXDeallocNotifierTestDelegate : NSObject <STXDeallocNotifierDelegate>

@property (nonatomic, readonly) NSSet<NSUUID *> *deallocatedIdentifiers;

@end

NS_ASSUME_NONNULL_END
