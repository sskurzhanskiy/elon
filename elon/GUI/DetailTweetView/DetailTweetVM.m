//
//  DetailTweetVM.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "DetailTweetVM.h"

#import "Tweet+CoreDataProperties.h"
#import "LDetailTweet.h"
#import "DataManager.h"

@implementation DetailTweetVM

-(void)loadTweetWithSid:(NSString*)sid successful:(void(^)(LDetailTweet*))successfulBlock failed:(void(^)(NSError*))failed
{
    [DataManager.instance loadTweetWithSid:sid successful:^(Tweet * _Nonnull tweet) {
        LDetailTweet *lTweet = [[LDetailTweet alloc] initWithTweet:tweet];
        if(successfulBlock) {
            successfulBlock(lTweet);
        }
    } failed:^(NSError *error){
        if(failed) {
            failed(error);
        }
    }];
}

@end
