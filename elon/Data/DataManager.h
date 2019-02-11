//
//  DataManager.h
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tweet;

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject

+(instancetype)instance;

-(void)authenticationWithCompletion:(nullable void(^)(void))successfulBlock failed:(nullable void(^)(void))failedBlock;
-(void)loadTweetUser:(NSString*)screenUser count:(NSInteger)count successful:(void(^)(NSArray<Tweet*>*tweets))successfulBlock failed:(void(^)(void))failedBlock;
-(void)loadTweetWithSid:(NSString*)tweetSid successful:(void(^)(Tweet*tweet))successfulBlock failed:(void(^)(void))failedBlock;
-(void)fetchTweetsWithCompletion:(void(^)(NSArray<Tweet*>*tweets))completionBlock;

@end

NS_ASSUME_NONNULL_END
