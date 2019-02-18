//
//  DetailTweetVM.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "DetailTweetVM.h"

#import "TweetResponse.h"
#import "LDetailTweet.h"
#import "DataManager.h"

@implementation DetailTweetVM

-(void)loadTweetWithSid:(NSString*)sid successful:(void(^)(LDetailTweet*))successfulBlock failed:(void(^)(NSError*))failed
{
    [DataManager.instance loadTweetWithSid:sid successful:^(TweetResponse * _Nonnull tResponse) {
        LDetailTweet *lTweet = [[LDetailTweet alloc] initWithTweetResponse:tResponse];
        dispatch_async(dispatch_get_main_queue(), ^{
            successfulBlock(lTweet);
        });
        
    } failed:^(NSError *error){
        if(failed) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failed(error);
            });
        }
    }];
}

@end
