//
//  DetailTweetVM.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "DetailTweetVM.h"

#import "Tweet+CoreDataProperties.h"
#import "LTweet.h"
#import "DataManager.h"

@implementation DetailTweetVM

-(void)loadTweetWithSid:(NSString*)sid successful:(void(^)(LTweet*))successfulBlock failed:(void(^)(void))failed
{
    [DataManager.instance loadTweetWithSid:sid successful:^(Tweet * _Nonnull tweet) {
        LTweet *lTweet = [[LTweet alloc] initWithTweet:tweet];
        if(successfulBlock) {
            successfulBlock(lTweet);
        }
    } failed:^{
        if(failed) {
            failed();
        }
    }];
}

@end
