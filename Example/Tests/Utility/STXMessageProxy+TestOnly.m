//
//  STXMessageProxy+TestOnly.m
//  STXMessageProxy_Tests
//
//  Created by Yiming XIA on 2019/2/9.
//  Copyright © 2019 SteinX. All rights reserved.
//

#import "STXMessageProxy+TestOnly.h"

@interface STXMessageProxy ()
@property (nonatomic) NSMapTable *broadcastSubscribers;
@end

@implementation STXMessageProxy (TestOnly)

- (BOOL)isAllSubscriberGone {
    NSLog(@"Subscriber count %zd", self.broadcastSubscribers.count);
    return self.broadcastSubscribers.count == 0;
}

@end
