//
//  AuthenticationController.h
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NetworkManager;

NS_ASSUME_NONNULL_BEGIN

@interface AuthenticationController : UIViewController

-(instancetype)initWithNetworkManager:(NetworkManager*)networkManager;

@property (nonatomic, copy) void(^didAppear)(void);
@property (nonatomic, copy) void(^authenticationCompletion)(void);

@end

NS_ASSUME_NONNULL_END
