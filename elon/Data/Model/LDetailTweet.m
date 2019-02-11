//
//  LDetailTweet.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 11.02.2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "LDetailTweet.h"

#import "Tweet+CoreDataProperties.h"

@implementation LDetailTweet

-(instancetype)initWithTweet:(Tweet*)tweet;
{
    if(self = [super init]) {
        self.text = tweet.text;
        self.favoritesCount = tweet.favoriteCount;
        self.retweetCount = tweet.retweetCount;
    }
    
    return self;
}

@end
