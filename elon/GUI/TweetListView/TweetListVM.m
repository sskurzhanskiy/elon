//
//  TweetListVM.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "TweetListVM.h"

#import "DataManager.h"
#import "Tweet+CoreDataProperties.h"
#import "LTweet.h"

@interface TweetListVM()

@property (nonatomic, weak) DataManager *dataManager;

@end

@implementation TweetListVM

-(instancetype)initWithDataManager:(DataManager*)dataManager
{
    if(self = [super init]) {
        self.dataManager = dataManager;
    }
        
    return self;
}

#pragma mark - TweetListInterface

-(void)loadTweetUser:(NSString*)screenUser count:(NSInteger)count successful:(void(^)(NSArray<LTweet*>*tweets))successfulBlock failed:(void(^)(void))failedBlock
{
    [self.dataManager loadTweetUser:screenUser count:count successful:^(NSArray<Tweet *> * _Nonnull tweets) {
        NSMutableArray *result = [NSMutableArray array];
        for(Tweet *tweet in tweets) {
            [result addObject:[self createLTweetFromTweet:tweet]];
        }
        
        if(successfulBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                successfulBlock(result);
            });
        }
    } failed:^{
        if(failedBlock) {
            failedBlock();
        }
    }];
}

-(void)fetchTweetsWithCompletion:(void(^)(NSArray<LTweet*>*tweets))completionBlock
{
    [self.dataManager fetchTweetsWithCompletion:^(NSArray<Tweet *> * _Nonnull tweets) {
        NSMutableArray *result = [NSMutableArray array];
        for(Tweet *tweet in tweets) {
            [result addObject:[self createLTweetFromTweet:tweet]];
        }
        
        if(completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(result);
            });
        }
    }];
}

#pragma mark - Private methods

-(LTweet*)createLTweetFromTweet:(Tweet*)tweet
{
    LTweet *lTweet = [LTweet new];
    lTweet.sid = tweet.sid;
    lTweet.text = tweet.text;
    lTweet.createDate = tweet.createAt;
    
    return lTweet;
}

@end
