//
//  STXScrollDelegateInterceptor.m
//  STXMessageProxy_Example
//
//  Created by Yiming XIA on 2019/2/9.
//  Copyright © 2019 SteinX. All rights reserved.
//

#import "STXScrollDelegateInterceptor.h"

@interface STXScrollDelegateInterceptor () <UITableViewDelegate>

@end

@implementation STXScrollDelegateInterceptor

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"[INTERCEPTED] %@", NSStringFromSelector(_cmd));
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"[INTERCEPTED] %@", NSStringFromSelector(_cmd));
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
