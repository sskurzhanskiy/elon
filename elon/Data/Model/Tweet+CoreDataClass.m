//
//  Tweet+CoreDataClass.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//
//

#import "Tweet+CoreDataClass.h"

@implementation Tweet

-(void)updateWithSource:(NSDictionary*)src
{
    self.createAt = src[@"created_at"];
    self.text = src[@"text"];
    self.favoriteCount = [src[@"favorite_count"] intValue];
    self.retweetCount = [src[@"retweet_count"] intValue];
}

@end
