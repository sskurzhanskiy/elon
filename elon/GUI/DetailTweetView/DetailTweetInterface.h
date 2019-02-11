//
//  DetailTweetVM.h
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LTweet;

@protocol DetailTweetInterface <NSObject>

-(void)loadTweetWithSid:(NSString*)sid successful:(void(^)(LTweet*))successfulBlock failed:(void(^)(void))failed;

@end

NS_ASSUME_NONNULL_END
