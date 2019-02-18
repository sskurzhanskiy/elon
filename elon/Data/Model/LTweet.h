//
//  LTweet.h
//  elon
//
//  Created by Sergey Skurzhanskiy on 08/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TweetResponse;
@class Tweet;

NS_ASSUME_NONNULL_BEGIN

@interface LTweet : NSObject

-(instancetype)initWithTweet:(Tweet*)tweet;
-(instancetype)initWithTweetResponse:(TweetResponse*)tResponse;

@property (nonatomic, copy, readonly) NSString *sid;
@property (nonatomic, copy, readonly) NSString *text;
@property (nonatomic, copy, readonly) NSString *customDateString;

@end

NS_ASSUME_NONNULL_END
