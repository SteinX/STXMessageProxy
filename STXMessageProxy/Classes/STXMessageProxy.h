//
//  STXMessageProxy.h
//  STXMessageProxy
//
//  Created by Yiming XIA on 2019/2/7.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, STXMessageProxyRunningMode) {
    STXMessageProxyRunningModeBroadcasting = 1, // The method call will be delivered to all subscribers and source
    STXMessageProxyRunningModeInterception, // The method call will be delivered to interceptor if it responds, or to the source if it not.
};

NS_ASSUME_NONNULL_BEGIN

/**
 A proxy to control the distribution of the message delivery of the objc based on the message forwarding mechanism.
 */
@interface STXMessageProxy : NSProxy
/**
 The interceptor will only be used in interception mode, the message method invocation will be intercepted if the interceptor responds to the call.
 */
@property (nonatomic, weak, nullable) id interceptor;

/**
 Adding broadcast subscriber in the broadcasting mode, all the subscribers will get notified if it responds to the call

 @param subscriber subscriber
 @discussion To be clear, it's not thread-safe to add a subscriber
 */
- (void)addBroadcastSubscriber:(id)subscriber;

/**
 Define the running mode of the specific seleector

 @param selector selector
 @param mode running mode
 */
- (void)setProxyingSelector:(SEL)selector withRunningMode:(STXMessageProxyRunningMode)mode;

/**
 Initialize the proxy from the source

 @param source The source is the object to which the method call is originally to be sent.
 @return instance
 */
- (instancetype)initWithSource:(id<NSObject>)source NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
