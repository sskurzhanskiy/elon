//
//  UrlRequestBuilder.m
//  elonTests
//
//  Created by Sergey Skurzhanskiy on 18/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TwitterRequestBuilder.h"

@interface TwitterRequestBuilderTest : XCTestCase

@property (nonatomic, strong) TwitterRequestBuilder *requestBuilder;

@end

@implementation TwitterRequestBuilderTest

- (void)setUp {
    self.requestBuilder = [TwitterRequestBuilder new];
}

- (void)tearDown {
    self.requestBuilder = nil;
}

- (void)testRequestAuthentication {
    NSURLRequest *request = [self.requestBuilder requestAuthentication];
    XCTAssert(request);
    
    NSDictionary *headers = request.allHTTPHeaderFields;
    XCTAssert(headers);
    XCTAssert(headers[@"Authorization"]);
    XCTAssert(request.HTTPBody);
}

-(void)testRequestTimeline {
    NSURLRequest *request = [self.requestBuilder requestTimelineWithParameters:@{@"screen_name": @"elonmusk",
                                                                                 @"count": @(5)
                                                                                 }];
    XCTAssert(request);
}

-(void)testRequestTimelineParamsNil {
    NSURLRequest *request = [self.requestBuilder requestTimelineWithParameters:@{}];
    XCTAssert(request);
}

-(void)testRequestShow {
    NSURLRequest *request = [self.requestBuilder requestShowWithParameters:@{@"id":@"123"}];
    XCTAssertNil(request);
}

-(void)testRequestShowParamsNil {
    NSURLRequest *request = [self.requestBuilder requestShowWithParameters:@{}];
    XCTAssertNil(request);
}

@end
