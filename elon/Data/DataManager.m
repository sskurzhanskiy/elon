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

-(void)authenticationWithCompletion:(void(^)(void))successfulBlock failed:(void(^)(void))failedBlock
{
    [self.networkManager authenticationWithCompletion:^(NSDictionary *dict) {
        if(successfulBlock) {
            successfulBlock();
        }
    } failed:^{
        if(failedBlock) {
            failedBlock();
        }
    }];
}

-(void)loadTweetUser:(NSString*)screenUser count:(NSInteger)count successful:(void(^)(NSArray<Tweet*>*tweets))successfulBlock failed:(void(^)(void))failedBlock
{
    __weak typeof(self) weakSelf = self;
    [self.networkManager loadTweetUser:screenUser count:count successful:^(NSArray *array) {
        for(NSDictionary *tweetSrc in array) {
            [weakSelf.dataStorage addTweet:tweetSrc];
        }
        
        if(successfulBlock) {
            successfulBlock([weakSelf.dataStorage allTweets]);
        }
    } failed:^{
        if(failedBlock) {
            failedBlock();
        }
    }];
}

-(void)loadTweetWithSid:(NSString*)tweetSid successful:(void(^)(Tweet*tweet))successfulBlock failed:(void(^)(void))failedBlock
{
    __weak typeof(self) weakSelf = self;
    [self.networkManager loadTweetWithSid:tweetSid successful:^(NSDictionary * tweetSrc) {
        [weakSelf.dataStorage addTweet:tweetSrc];
        
        if(successfulBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                successfulBlock([weakSelf.dataStorage tweetWithSid:tweetSid]);
            });
        }
    } failed:^{
        if(failedBlock) {
            failedBlock();
        }
    }];
}

-(void)fetchTweetsWithCompletion:(void(^)(NSArray<Tweet*>*tweets))completionBlock
{
    if(completionBlock) {
        completionBlock([self.dataStorage allTweets]);
    }
}

@end
