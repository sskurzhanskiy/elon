//
//  LDetailTweet.h
//  elon
//
//  Created by Sergey Skurzhanskiy on 11.02.2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TweetResponse;
@class Tweet;

@interface LDetailTweet : NSObject

-(instancetype)initWithTweetResponse:(TweetResponse*)tResponse;
-(instancetype)initWithTweet:(Tweet*)tweet;

@property (nonatomic, copy, readonly) NSString *sid;
@property (nonatomic, copy, readonly) NSString *text;
@property (nonatomic, assign, readonly) NSInteger favoritesCount;
@property (nonatomic, assign, readonly) NSInteger retweetCount;

@end
