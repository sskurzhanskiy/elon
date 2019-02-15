//
//  TweetListResponse.h
//  elon
//
//  Created by Sergey Skurzhanskiy on 15/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "Response.h"

@class TweetResponse;

NS_ASSUME_NONNULL_BEGIN

@interface TweetListResponse : Response

@property (nonatomic, copy, readonly) NSArray<TweetResponse*> *tweetList;

@end

NS_ASSUME_NONNULL_END
