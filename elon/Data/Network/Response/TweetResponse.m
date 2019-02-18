//
//  TweetResponse.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 15/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "TweetResponse.h"

@interface TweetResponse()

@property (nullable, nonatomic, copy, readwrite) NSString *createdAt;
@property (nullable, nonatomic, copy, readwrite) NSString *sid;
@property (nullable, nonatomic, copy, readwrite) NSString *text;
@property (nonatomic, assign, readwrite) NSInteger retweetCount;
@property (nonatomic, assign, readwrite) NSInteger favoriteCount;

@end

@implementation TweetResponse

-(BOOL)disassembledObject:(id)object
{
    if(![object isKindOfClass:NSDictionary.class]) {
        return NO;
    }
    
    NSDictionary *map = (NSDictionary*)object;
    self.createdAt = map[@"created_at"];
    self.sid = map[@"id_str"];
    self.text = map[@"text"];
    self.retweetCount = [map[@"retweet_count"] integerValue];
    self.favoriteCount = [map[@"favorite_count"] integerValue];
    
    return self.sid && self.text && self.createdAt;
}

@end
