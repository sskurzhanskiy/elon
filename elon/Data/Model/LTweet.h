//
//  LTweet.h
//  elon
//
//  Created by Sergey Skurzhanskiy on 08/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tweet;
NS_ASSUME_NONNULL_BEGIN

@interface LTweet : NSObject

-(instancetype)initWithTweet:(Tweet*)tweet;

@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *createDate;

@end

NS_ASSUME_NONNULL_END
