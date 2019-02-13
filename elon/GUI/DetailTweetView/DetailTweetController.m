//
//  DetailTweetController.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "DetailTweetController.h"

#import "DetailTweetInterface.h"
#import "LDetailTweet.h"

#import "DetailTweetView.h"

@interface DetailTweetController ()

@property (nonatomic, weak) DetailTweetView *detailView;
@property (nonatomic, copy) NSString *tweetSid;

@end

@implementation DetailTweetController

-(instancetype)initWithTweetSid:(NSString*)tweetSid
{
    if(self = [super init]) {
        self.tweetSid = tweetSid;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    DetailTweetView *detailView = [DetailTweetView new];
    detailView.translatesAutoresizingMaskIntoConstraints = NO;
    detailView.backgroundColor = [UIColor whiteColor];
    detailView.alpha = 0;
    [self.view addSubview:detailView];
    self.detailView = detailView;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:detailView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:detailView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:detailView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:detailView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    __weak typeof(self) weakSelf = self;
    [self.model loadTweetWithSid:self.tweetSid successful:^(LDetailTweet * tweet) {
        weakSelf.detailView.textLabel.text = tweet.text;
        weakSelf.detailView.likeCountLabel.text = [NSString stringWithFormat:@"%ld", (long)tweet.favoritesCount];
        weakSelf.detailView.retweetCountLabel.text = [NSString stringWithFormat:@"%ld", (long)tweet.retweetCount];
        
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.detailView.alpha = 1;
        }];
    } failed:^{
        NSLog(@"error");
    }];
}

@end
