//
//  TweetListResponse.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 15/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "TweetListResponse.h"

#import "TweetResponse.h"

@interface TweetListResponse()

@property (nonatomic, copy, readwrite) NSArray<TweetResponse*> *tweetList;

@end

@implementation TweetListResponse

-(BOOL)disassembledObject:(id)object
{
    if(![object isKindOfClass:NSArray.class]) {
        return NO;
    }
    
    NSArray<NSDictionary*> *responseMap = (NSArray<NSDictionary*>*)object;
    NSMutableArray *result = [NSMutableArray array];
    for(NSDictionary *map in responseMap) {
        NSError *error = nil;
        TweetResponse *tResponse = [[TweetResponse alloc] initWithObject:map error:&error];
        if(error) {continue;}
        
        [result addObject:tResponse];
    }
    self.tweetList = [result copy];
    
    return YES;
}

@end
