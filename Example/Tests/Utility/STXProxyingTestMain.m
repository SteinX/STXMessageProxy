//
//  STXProxyingTestMain.m
//  STXMessageProxy_Tests
//
//  Created by Yiming XIA on 2019/2/8.
//  Copyright © 2019 SteinX. All rights reserved.
//

#import "STXProxyingTestMain.h"

@implementation STXProxyingTestMain

- (void)call_delegationWithParam:(id)parameter {
    [self.delegate call_delegationWithParam:parameter];
}

- (NSInteger)call_delegationWithReturnVal {
    return [self.delegate call_delegationWithReturnValue];
}

- (CGRect)call_delegationWithStructReturnVal {
    return [self.delegate call_delegationWithStructReturnValue];
}

- (NSNumber *)call_delegationWithObjectReturnVal {
    return [self.delegate call_delegationWithObjectTypeReturnValue];
}

- (STXObjectBlock)call_delegationWithObjectBlockReturnVal {
    return [self.delegate call_delegationWithObjectBlockReturnValue];
}

@end
