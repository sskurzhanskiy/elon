//
//  LDetailTweet.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 11.02.2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "LDetailTweet.h"

#import "TweetResponse.h"
#import "Tweet+CoreDataProperties.h"

@interface LDetailTweet()

@property (nonatomic, copy, readwrite) NSString *sid;
@property (nonatomic, copy, readwrite) NSString *text;
@property (nonatomic, assign, readwrite) NSInteger favoritesCount;
@property (nonatomic, assign, readwrite) NSInteger retweetCount;

@end

@implementation LDetailTweet

-(instancetype)initWithTweetResponse:(TweetResponse*)tResponse
{
    if(self = [super init]) {
        self.sid = tResponse.sid;
        self.text = tResponse.text;
        self.favoritesCount = tResponse.favoriteCount;
        self.retweetCount = tResponse.retweetCount;
    }
    
    return self;
}

-(instancetype)initWithTweet:(Tweet*)tweet;
{
    if(self = [super init]) {
        self.sid = tweet.sid;
        self.text = tweet.text;
        self.favoritesCount = tweet.favoriteCount;
        self.retweetCount = tweet.retweetCount;
    }
    
    return self;
}

@end
