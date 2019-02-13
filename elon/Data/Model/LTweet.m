//
//  LTweet.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 08/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "LTweet.h"

#import "Tweet+CoreDataProperties.h"

static NSDateFormatter* dateFormatter()
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"E MMM d HH:mm:ss yyyy";
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
    });
    return dateFormatter;
}

@implementation LTweet

-(instancetype)initWithTweet:(Tweet*)tweet;
{
    if(self = [super init]) {
        self.sid = tweet.sid;
        self.text = tweet.text;
        self.customDateString = [self timeStampToString:tweet.timestamp];
    }
    
    return self;
}

-(NSString*)timeStampToString:(double)timestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return [dateFormatter() stringFromDate:date];
}

@end
