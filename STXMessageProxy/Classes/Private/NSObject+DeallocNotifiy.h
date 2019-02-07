//
//  NSObject+DeallocNotifiy.h
//  STXMessageProxy
//
//  Created by Yiming XIA on 2019/2/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class STXDeallocNotifier;

@protocol STXDeallocNotifierDelegate <NSObject>
- (void)stx_objectDidDealloc:(NSUUID *)identifier;
@end

@interface STXDeallocNotifier : NSObject
@property (nonatomic, readonly) NSUUID *identifier;
@property (nonatomic, weak) id<STXDeallocNotifierDelegate> delegate;
@end

@interface NSObject (DeallocNotifiy)

@property (nonatomic, readonly) STXDeallocNotifier *stx_deallocNotifier;

@end

NS_ASSUME_NONNULL_END
