//
//  AuthenticationController.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "AuthenticationController.h"

#import "NetworkManager.h"

@interface AuthenticationController ()

@property (nonatomic, weak) UIActivityIndicatorView *spinner;
@property (nonatomic, weak) UILabel *errorLabel;

@property (nonatomic, strong) NetworkManager *networkManager;

@end

@implementation AuthenticationController

-(instancetype)initWithNetworkManager:(NetworkManager*)networkManager
{
    if(self = [super init]) {
        self.networkManager = networkManager;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:spinner];
    self.spinner = spinner;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:spinner attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:spinner attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [spinner startAnimating];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    void (^handler)(void) = self.didAppear;
    if(handler) {
        handler();
    }
}

@end
