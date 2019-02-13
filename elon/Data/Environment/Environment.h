//
//  Environment.h
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Environment : NSObject

+(instancetype)sharedEnvironment;

@property (nonatomic, copy, readonly) NSString *twitterKey;
@property (nonatomic, copy, readonly) NSString *twitterSecter;
@property (nonatomic, copy, readonly) NSString *baseURL;

@end

NS_ASSUME_NONNULL_END
