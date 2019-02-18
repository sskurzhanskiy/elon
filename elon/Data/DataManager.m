//
//  DataManager.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "DataManager.h"

#import "NetworkManager.h"
#import "CDStorage.h"
#import "Tweet+CoreDataProperties.h"
#import "TweetResponse.h"
#import "TweetListResponse.h"

@interface DataManager()

@property (nonatomic, strong) NetworkManager *networkManager;
@property (nonatomic, strong) CDStorage *dataStorage;

@end

@implementation DataManager

+(instancetype)instance {
    static DataManager *instance;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

-(instancetype)init
{
    if(self = [super init]) {
        self.networkManager = [NetworkManager new];
        self.dataStorage = [CDStorage new];
    }
    
    return self;
}

-(void)authenticationWithCompletion:(void(^)(void))successfulBlock failed:(void(^)(NSError*))failedBlock
{
    [self.networkManager authenticationWithCompletion:^{
        if(successfulBlock) {
            successfulBlock();
        }
    } failed:^(NSError *error){
        if(failedBlock) {
            failedBlock(error);
        }
    }];
}

-(void)loadTweetWithSid:(NSString*)tweetSid successful:(void(^)(TweetResponse*tResponse))successfulBlock failed:(void(^)(NSError*))failedBlock;
{
    __weak typeof(self) weakSelf = self;
    [self.networkManager loadTweetWithSid:tweetSid successful:^(TweetResponse * tweetResponse) {
        [weakSelf.dataStorage addTweet:tweetResponse];
        
        if(successfulBlock) {
            successfulBlock(tweetResponse);
        }
    } failed:^(NSError *error){
        if(failedBlock) {
            failedBlock(error);
        }
    }];
}

-(void)loadTweetUser:(NSString*)screenUser count:(NSInteger)count successful:(void(^)(NSArray<TweetResponse*>*tResponse))successfulBlock failed:(void(^)(NSError*))failedBlock;
{
    __weak typeof(self) weakSelf = self;
    [self.networkManager loadTweetUser:screenUser count:count successful:^(TweetListResponse *listResponse) {
        for(TweetResponse *tResponse in listResponse.tweetList) {
            [weakSelf.dataStorage addTweet:tResponse];
        }
        
        if(successfulBlock) {
            successfulBlock(listResponse.tweetList);
        }
    } failed:^(NSError *error){
        if(failedBlock) {
            failedBlock(error);
        }
    }];
}

-(void)fetchTweetsCount:(NSInteger)count completion:(void(^)(NSArray<Tweet*>*tweets))completionBlock
{
    if(completionBlock) {
        completionBlock([self.dataStorage tweetsCount:count]);
    }
}

@end
