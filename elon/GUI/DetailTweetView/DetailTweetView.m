//
//  DetailTweetView.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "DetailTweetView.h"

@interface DetailTweetView()

@property (nonatomic, weak, readwrite) UILabel *textLabel;
@property (nonatomic, weak, readwrite) UILabel *likeCountLabel;
@property (nonatomic, weak, readwrite) UILabel *retweetCountLabel;

@end

@implementation DetailTweetView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *textLabel = [UILabel new];
        textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        textLabel.backgroundColor = self.backgroundColor;
        textLabel.numberOfLines = 0;
        [self addSubview:textLabel];
        self.textLabel = textLabel;
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        
        UILabel *likeLabel = [UILabel new];
        likeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        likeLabel.backgroundColor = self.backgroundColor;
        likeLabel.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"detail_like_text", nil)];
        [self addSubview:likeLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:likeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:textLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:likeLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:textLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:likeLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:textLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        
        UILabel *likeCountLabel = [UILabel new];
        likeCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
        likeCountLabel.backgroundColor = self.backgroundColor;
        likeCountLabel.text = @"0";
        [self addSubview:likeCountLabel];
        self.likeCountLabel = likeCountLabel;
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:likeCountLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:likeLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:likeCountLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:likeLabel attribute:NSLayoutAttributeRight multiplier:1 constant:10]];
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:likeCountLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:likeLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        
        UILabel *retweetLabel = [UILabel new];
        retweetLabel.translatesAutoresizingMaskIntoConstraints = NO;
        retweetLabel.backgroundColor = self.backgroundColor;
        retweetLabel.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"detail_retweet_text", nil)];
        [self addSubview:retweetLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:retweetLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:likeLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:retweetLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:likeLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:retweetLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:likeLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        
        UILabel *retweetCountLabel = [UILabel new];
        retweetCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
        retweetCountLabel.backgroundColor = self.backgroundColor;
        retweetCountLabel.text = @"0";
        [self addSubview:retweetCountLabel];
        self.retweetCountLabel = retweetCountLabel;
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:retweetCountLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:retweetLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:retweetCountLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:retweetLabel attribute:NSLayoutAttributeRight multiplier:1 constant:10]];
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:retweetCountLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:retweetLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    }
    
    return self;
}

@end
