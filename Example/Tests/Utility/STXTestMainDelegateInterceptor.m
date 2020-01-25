//
//  STXTestMainDelegateInterceptor.m
//  STXMessageProxy_Tests
//
//  Created by Yiming XIA on 2019/2/8.
//  Copyright © 2019 SteinX. All rights reserved.
//

#import "STXTestMainDelegateInterceptor.h"

@implementation STXTestMainDelegateInterceptor

- (void)call_delegationWithParam:(id)parameter {
    _evaluationValue = [parameter integerValue];
    NSLog(@"INTERCEPTED BY %@, EVALUATION VALUE SHOULD BE '%zd'", self, _evaluationValue);
}

- (NSInteger)call_delegationWithReturnValue {
    _evaluationValue = 40;
    NSLog(@"INTERCEPTED BY %@, RETURN VALUE SHOULD BE 20", self);
    return 20;
}

- (CGRect)call_delegationWithStructReturnValue {
    _evaluationStructValue = CGRectNull;
    return _evaluationStructValue;
}

@end
