//
//  Tweet+CoreDataClass.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//
//

#import "Tweet+CoreDataClass.h"

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

-(void)updateWithSource:(NSDictionary*)src
{
    self.createAt = src[@"created_at"];
    self.text = src[@"text"];
    self.favoriteCount = [src[@"favorite_count"] intValue];
    self.retweetCount = [src[@"retweet_count"] intValue];
    
    NSDate *date = [dateFormatter() dateFromString:src[@"created_at"]];
    self.timestamp = date.timeIntervalSince1970;
}

@end
