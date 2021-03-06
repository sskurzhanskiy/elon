//
//  AppDelegate.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 08/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "AppDelegate.h"

#import "NetworkManager.h"
#import "DataManager.h"
#import "TweetListVM.h"

#import "TweetListViewController.h"
#import "AuthenticationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    AuthenticationController *vc = [AuthenticationController new];
    __weak typeof(self) weakSelf = self;
    vc.didAppear = ^{
        [DataManager.instance authenticationWithCompletion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf launchMainScreen];
            });
        } failed:nil];
    };
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    window.rootViewController = vc;
    self.window = window;
    
    [window makeKeyAndVisible];
    
    return YES;
}


#pragma mark - Private methods

-(void)launchMainScreen
{
    DataManager *dataManager = DataManager.instance;
    TweetListVM *viewModel = [[TweetListVM alloc] initWithDataManager:dataManager];
    
    TweetListViewController *tweetListVc = [TweetListViewController new];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:tweetListVc];
    tweetListVc.title = NSLocalizedString(@"main_screen_title", nil);
    tweetListVc.model = viewModel;
    
    UIWindow *window = self.window;
    window.rootViewController = nc;
    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        window.rootViewController = nc;
                    } completion:nil];
}


@end
