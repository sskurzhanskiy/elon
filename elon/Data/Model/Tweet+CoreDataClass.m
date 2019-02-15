//
//  Tweet+CoreDataClass.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//
//

#import "Tweet+CoreDataClass.h"

#import "TweetResponse.h"

static NSDateFormatter* dateFormatter()
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"E MMM d HH:mm:ss Z yyyy";
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
    });
    return dateFormatter;
}

@implementation Tweet

-(void)updateWithSource:(TweetResponse*)response
{
    self.createAt = response.createdAt;
    self.text = response.text;
    self.favoriteCount = (int)response.favoriteCount;
    self.retweetCount = (int)response.retweetCount;
    
    NSDate *date = [dateFormatter() dateFromString:response.createdAt];
    self.timestamp = date.timeIntervalSince1970;
}

@end
