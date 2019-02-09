//
//  STXViewController.m
//  STXMessageProxy
//
//  Created by SteinX on 02/07/2019.
//  Copyright (c) 2019 SteinX. All rights reserved.
//

#import "STXViewController.h"
#import "STXScrollDelegateProxy.h"
#import "STXScrollDelegateInterceptor.h"
#import "STXScrollDelegateSubscriber.h"

@interface STXViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISwitch *modeSwitch;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) STXScrollDelegateProxy *proxy;
@property (nonatomic) STXScrollDelegateInterceptor *interceptor;

@property (nonatomic) NSArray<STXScrollDelegateSubscriber *> *subscribers;

@end

@implementation STXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.interceptor = [STXScrollDelegateInterceptor new];
    self.subscribers = @[
                         [[STXScrollDelegateSubscriber alloc] initWithName:@"Subscriber-1"],
                         [[STXScrollDelegateSubscriber alloc] initWithName:@"Subscriber-2"]
                         ];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    
    [self applyModeChange];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __auto_type cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    cell.textLabel.text = indexPath.description;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%@ selected", indexPath);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

- (IBAction)modeSwitchChangedValue:(id)sender {
    [self applyModeChange];
}

- (void)applyModeChange {
    STXMessageProxyRunningMode mode = self.modeSwitch.on ? STXMessageProxyRunningModeInterception : STXMessageProxyRunningModeBroadcasting;
    
    if (!_proxy) {
        self.proxy = [[STXScrollDelegateProxy alloc] initWithSource:self];
        self.proxy.interceptor = self.interceptor;
        [self.subscribers enumerateObjectsUsingBlock:^(STXScrollDelegateSubscriber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.proxy addBroadcastSubscriber:obj];
        }];
    }
    
    [self.proxy setProxyingSelector:@selector(scrollViewWillBeginDragging:)
                    withRunningMode:mode];
    [self.proxy setProxyingSelector:@selector(tableView:didSelectRowAtIndexPath:)
                    withRunningMode:mode];
    
    self.tableView.delegate = self.proxy;

}

@end
