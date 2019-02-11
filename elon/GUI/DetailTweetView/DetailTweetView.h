//
//  DetailTweetView.h
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailTweetView : UIView

@property (nonatomic, weak, readonly) UILabel *textLabel;
@property (nonatomic, weak, readonly) UILabel *likeCountLabel;
@property (nonatomic, weak, readonly) UILabel *retweetCountLabel;

@end

NS_ASSUME_NONNULL_END
