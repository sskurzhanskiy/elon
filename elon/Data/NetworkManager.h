//
//  NetworkManager.h
//  elon
//
//  Created by Sergey Skurzhanskiy on 08/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject

-(void)authenticationWithCompletion:(void(^)(NSDictionary*))successfulBlock failed:(void(^)(void))failedBlock;
-(void)loadTweetUser:(NSString*)screenUser count:(NSInteger)count successful:(void(^)(NSArray*))successfulBlock failed:(void(^)(void))failedBlock;
-(void)loadTweetWithSid:(NSString*)tweetSid successful:(void(^)(NSDictionary*))successfulBlock failed:(void(^)(void))failedBlock;

@end

NS_ASSUME_NONNULL_END
