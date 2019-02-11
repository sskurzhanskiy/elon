//
//  ViewController.h
//  elon
//
//  Created by Sergey Skurzhanskiy on 08/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TweetListInterface;

@interface TweetListViewController : UIViewController

@property (nonatomic, strong) id<TweetListInterface> model;

@end

