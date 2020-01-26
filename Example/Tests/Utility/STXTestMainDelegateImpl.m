//
//  STXTestMainDelegateImpl.m
//  STXMessageProxy_Tests
//
//  Created by Yiming XIA on 2019/2/8.
//  Copyright © 2019 SteinX. All rights reserved.
//

#import "STXTestMainDelegateImpl.h"

@implementation STXTestMainDelegateImpl

- (void)call_delegationWithParam:(id)parameter {
    _evaluationValue = 2 + [parameter integerValue];
    NSLog(@"ORG IMPL, Evalation is supposed to be %zd", _evaluationValue);
}

- (NSInteger)call_delegationWithReturnValue {
    _evaluationValue = 20;
    return 10;
}

- (CGRect)call_delegationWithStructReturnValue {
    _evaluationStructValue = CGRectMake(1, 1, 10, 10);
    return _evaluationStructValue;
}

- (NSNumber *)call_delegationWithObjectTypeReturnValue {
    _evaluationObjValue = @(88888888.8888);
    return _evaluationObjValue;
}

- (STXObjectBlock)call_delegationWithObjectBlockReturnValue {
    return ^(NSNumber *number) {
        __auto_type str = [NSString stringWithFormat:@"Number passed: %@", number];
        NSLog(@"%@", str);
        return str;
    };
}

@end
