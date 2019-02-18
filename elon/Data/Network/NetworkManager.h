//
//  NetworkManager.h
//  elon
//
//  Created by Sergey Skurzhanskiy on 08/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TweetResponse;
@class TweetListResponse;

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject

-(void)authenticationWithCompletion:(void(^ _Nullable )(void))successfulBlock failed:(void(^)(NSError*))failedBlock;
-(void)loadTweetUser:(NSString*)screenUser count:(NSInteger)count successful:(void(^)(TweetListResponse*))successfulBlock failed:(void(^)(NSError*))failedBlock;
-(void)loadTweetWithSid:(NSString*)tweetSid successful:(void(^)(TweetResponse*))successfulBlock failed:(void(^)(NSError*))failedBlock;

@end

NS_ASSUME_NONNULL_END
