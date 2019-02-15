//
//  AuthenticationResponse.h
//  elon
//
//  Created by Sergey Skurzhanskiy on 15/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "Response.h"

NS_ASSUME_NONNULL_BEGIN

@interface AuthenticationResponse : Response

@property (nonatomic, copy, readonly) NSString *tokenType;
@property (nonatomic, copy, readonly) NSString *accessToken;

@end

NS_ASSUME_NONNULL_END
