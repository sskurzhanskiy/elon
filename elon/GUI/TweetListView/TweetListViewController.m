//
//  ViewController.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 08/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "TweetListViewController.h"

#import "TweetListInterface.h"
#import "LTweet.h"
#import "DetailTweetVM.h"

#import "DetailTweetController.h"

static NSString *cellIdentifier = @"cell-identifier";
static NSInteger limitTweets = 5;

@interface TweetListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIRefreshControl *refreshHeadController;

@property (nonatomic, copy) NSArray<LTweet*> *tweets;

@end

@implementation TweetListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    self.navigationController.navigationBar.translucent = NO;
    
    UITableView *tableView = [UITableView new];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    UIRefreshControl *refreshHeadController = [[UIRefreshControl alloc] init];
    [refreshHeadController addTarget:self action:@selector(refreshHeadTableView) forControlEvents:UIControlEventValueChanged];
    [tableView addSubview:refreshHeadController];
    self.refreshHeadController = refreshHeadController;

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    __weak typeof(self) weakSelf = self;
    [self.model fetchLastTweetsCount:limitTweets completion:^(NSArray<LTweet *> * _Nonnull tweets) {
        if(tweets.count > 0) {
            weakSelf.tweets = tweets;
            [weakSelf.tableView reloadData];
        } else {
            [weakSelf loadElonTweetCount:limitTweets];
        }
    }];
}

#pragma mark - Handlers

-(void)refreshHeadTableView
{
    [self loadElonTweetCount:limitTweets];
}

#pragma mark - UITableViewDataSources

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LTweet *tweet = self.tweets[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = tweet.text;
    cell.detailTextLabel.text = tweet.customDateString;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    LTweet *tweet = self.tweets[indexPath.row];
    DetailTweetVM *viewModel = [DetailTweetVM new];
    DetailTweetController *detailController = [[DetailTweetController alloc] initWithTweetSid:tweet.sid];
    detailController.model = viewModel;
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - Private methods

-(void)loadElonTweetCount:(NSInteger)count {
    __weak typeof(self) weakSelf = self;
    [self.model loadTweetUser:@"elonmusk" count:count successful:^(NSArray<LTweet *> * _Nonnull tweets) {
        weakSelf.tweets = tweets;
        [weakSelf.tableView reloadData];
        [weakSelf.refreshHeadController endRefreshing];
    } failed:^{
        NSLog(@"failed");
        [weakSelf.refreshHeadController endRefreshing];
    }];
}

@end
