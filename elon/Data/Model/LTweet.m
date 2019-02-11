//
//  LTweet.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 08/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "LTweet.h"

#import "Tweet+CoreDataProperties.h"

@implementation LTweet

-(instancetype)initWithTweet:(Tweet*)tweet;
{
    if(self = [super init]) {
        self.sid = tweet.sid;
        self.text = tweet.text;
        self.createDate = tweet.createAt;
        self.favoritesCount = tweet.favoriteCount;
        self.retweetCount = tweet.retweetCount;
    }
    
    return self;
}

@end
