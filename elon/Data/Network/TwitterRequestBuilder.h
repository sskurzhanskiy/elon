//
//  UrlRequestBuilder.h
//  elon
//
//  Created by Sergey Skurzhanskiy on 18/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TwitterRequestBuilder : NSObject

@property (nonatomic, copy) NSString *token;

-(NSURLRequest*)requestAuthentication;
-(NSURLRequest*)requestShowWithParameters:(NSDictionary*)params;
-(NSURLRequest*)requestTimelineWithParameters:(NSDictionary*)params;


@end

NS_ASSUME_NONNULL_END
