//
//  TweetListVM.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "TweetListVM.h"

#import "DataManager.h"
#import "TweetResponse.h"
#import "Tweet+CoreDataProperties.h"
#import "LTweet.h"
#import "DetailTweetVM.h"

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

-(id<DetailTweetInterface>)detailTweetViewModel
{
    DetailTweetVM *vm = [[DetailTweetVM alloc] init];
    
    return vm;
}

-(void)loadTweetUser:(NSString*)screenUser count:(NSInteger)count successful:(void(^)(NSArray<LTweet*>*tweets))successfulBlock failed:(void(^)(NSError*))failedBlock
{
    [self.dataManager loadTweetUser:screenUser count:count successful:^(NSArray<TweetResponse *> * _Nonnull tweetsResponse) {
        NSMutableArray *result = [NSMutableArray array];
        for(TweetResponse *tResponse in tweetsResponse) {
            LTweet *lTweet = [[LTweet alloc] initWithTweetResponse:tResponse];
            [result addObject:lTweet];
        }
        
        if(successfulBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                successfulBlock([result copy]);
            });
        }
    } failed:^(NSError *error){
        if(failedBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failedBlock(error);
            });
        }
    }];
}

-(void)fetchLastTweetsCount:(NSInteger)count completion:(void(^)(NSArray<LTweet*>*tweets))completionBlock
{
    [self.dataManager fetchTweetsCount:count completion:^(NSArray<Tweet *> * _Nonnull tweets) {
        NSMutableArray *result = [NSMutableArray array];
        for(Tweet *tweet in tweets) {
            LTweet *lTweet = [[LTweet alloc] initWithTweet:tweet];
            [result addObject:lTweet];
        }
        
        if(completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([result copy]);
            });
        }
    }];
}

@end
