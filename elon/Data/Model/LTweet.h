//
//  LTweet.h
//  elon
//
//  Created by Sergey Skurzhanskiy on 08/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTweet : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *publishedDate;

@end

NS_ASSUME_NONNULL_END
