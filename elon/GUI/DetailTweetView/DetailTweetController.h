//
//  DetailTweetController.h
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailTweetInterface;

NS_ASSUME_NONNULL_BEGIN

@interface DetailTweetController : UIViewController

-(instancetype)initWithTweetSid:(NSString*)tweetSid;

@property (nonatomic, strong) id<DetailTweetInterface> model;

@end

NS_ASSUME_NONNULL_END
