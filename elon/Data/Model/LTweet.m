//
//  LTweet.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 08/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "LTweet.h"

#import "TweetResponse.h"
#import "Tweet+CoreDataProperties.h"

static NSDateFormatter* serverDateFormatter()
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

static NSDateFormatter* clientDateFormatter()
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

@interface LTweet()

@property (nonatomic, copy, readwrite) NSString *sid;
@property (nonatomic, copy, readwrite) NSString *text;
@property (nonatomic, copy, readwrite) NSString *customDateString;

@end

@implementation LTweet

-(instancetype)initWithTweetResponse:(TweetResponse*)tResponse
{
    if(self = [super init]) {
        self.sid = tResponse.sid;
        self.text = tResponse.text;
        
        NSDate *date = [serverDateFormatter() dateFromString:tResponse.createdAt];
        self.customDateString = [clientDateFormatter() stringFromDate:date];
    }
    
    return self;
}

-(instancetype)initWithTweet:(Tweet*)tweet;
{
    if(self = [super init]) {
        self.sid = tweet.sid;
        self.text = tweet.text;
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:tweet.timestamp];
        self.customDateString = [clientDateFormatter() stringFromDate:date];
    }
    
    return self;
}

-(NSString*)description {
    return [NSString stringWithFormat:@"sid: %@ text: %@ date: %@", self.sid, self.text, self.customDateString];
}

@end
