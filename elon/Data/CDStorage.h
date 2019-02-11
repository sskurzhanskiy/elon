//
//  CDStorage.h
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tweet;

NS_ASSUME_NONNULL_BEGIN

@interface CDStorage : NSObject

-(NSArray<Tweet*>*)allTweets;
-(void)addTweet:(NSDictionary*)srcTweet;
-(Tweet*)tweetWithSid:(NSString*)tweetSid;

@end

NS_ASSUME_NONNULL_END