//
//  TweetListInterface.h
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LTweet;
@protocol DetailTweetInterface;

NS_ASSUME_NONNULL_BEGIN

@protocol TweetListInterface <NSObject>

-(id<DetailTweetInterface>)detailTweetViewModel;

-(void)loadTweetUser:(NSString*)screenUser count:(NSInteger)count successful:(void(^)(NSArray<LTweet*>*tweets))successfulBlock failed:(void(^)(NSError*))failedBlock;
-(void)fetchLastTweetsCount:(NSInteger)count completion:(void(^)(NSArray<LTweet*>*tweets))completionBlock;

@end

NS_ASSUME_NONNULL_END
