//
//  STXScrollDelegateSubscriber.m
//  STXMessageProxy_Example
//
//  Created by Yiming XIA on 2019/2/9.
//  Copyright © 2019 SteinX. All rights reserved.
//

#import "STXScrollDelegateSubscriber.h"

@interface STXScrollDelegateSubscriber () <UITableViewDelegate>
@property (nonatomic) NSString *name;
@end

@implementation STXScrollDelegateSubscriber

- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        self.name = name;
    }
    return self;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"%@ get notified for %@", self.name, NSStringFromSelector(_cmd));
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@ get notified for %@", self.name, NSStringFromSelector(_cmd));
}

@end
