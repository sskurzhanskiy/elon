//
//  TweetResponse.h
//  elon
//
//  Created by Sergey Skurzhanskiy on 15/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "Response.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetResponse : Response

@property (nullable, nonatomic, copy, readonly) NSString *createdAt;
@property (nullable, nonatomic, copy, readonly) NSString *sid;
@property (nullable, nonatomic, copy, readonly) NSString *text;
@property (nonatomic, assign, readonly) NSInteger retweetCount;
@property (nonatomic, assign, readonly) NSInteger favoriteCount;

@end

NS_ASSUME_NONNULL_END
