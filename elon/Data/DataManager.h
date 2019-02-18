//
//  DataManager.h
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TweetResponse;
@class Tweet;

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject

+(instancetype)instance;

-(void)authenticationWithCompletion:(nullable void(^)(void))successfulBlock failed:(nullable void(^)(NSError*))failedBlock;

-(void)loadTweetWithSid:(NSString*)tweetSid successful:(void(^)(TweetResponse*tResponse))successfulBlock failed:(void(^)(NSError*))failedBlock;
-(void)loadTweetUser:(NSString*)screenUser count:(NSInteger)count successful:(void(^)(NSArray<TweetResponse*>*tResponse))successfulBlock failed:(void(^)(NSError*))failedBlock;

-(void)fetchTweetsCount:(NSInteger)count completion:(void(^)(NSArray<Tweet*>*tweets))completionBlock;

@end

NS_ASSUME_NONNULL_END
