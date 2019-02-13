//
//  LDetailTweet.h
//  elon
//
//  Created by Sergey Skurzhanskiy on 11.02.2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tweet;

@interface LDetailTweet : NSObject

-(instancetype)initWithTweet:(Tweet*)tweet;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSInteger favoritesCount;
@property (nonatomic, assign) NSInteger retweetCount;

@end
