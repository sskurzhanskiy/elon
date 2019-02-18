//
//  elonTests.m
//  elonTests
//
//  Created by Sergey Skurzhanskiy on 13/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NetworkManager.h"
#import "TweetResponse.h"

static NSInteger expectionTime = 5;

@interface elonTests : XCTestCase

@property (nonatomic, strong) NetworkManager *nManager;
@property (nonatomic, strong) XCTestExpectation *expection;

@end

@implementation elonTests

- (void)setUp {
    self.nManager = [[NetworkManager alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testAuthentication {
    XCTestExpectation *expectation = [self expectationWithDescription:@"authentication"];

    [self.nManager authenticationWithCompletion:^{
        [expectation fulfill];
    } failed:^(NSError * _Nonnull error) {
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:expectionTime handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
}

- (void)testLoadTweetWithSid {
    XCTestExpectation *expectation = [self expectationWithDescription:@"loadTweet"];
    
    [self.nManager loadTweetWithSid:@"850007368138018817" successful:^(TweetResponse * _Nonnull response) {
        XCTAssert(response);
        XCTAssert([response.sid isEqualToString:@"850007368138018817"]);
        XCTAssert(response.text);
        XCTAssert(response.createdAt);
        [expectation fulfill];
    } failed:^(NSError * _Nonnull error) {
        XCTAssertNotNil(error, @"testLoadTweetWithSid error");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:expectionTime handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
}

- (void)testLoadTweetWithSidError {
    XCTestExpectation *expectation = [self expectationWithDescription:@"loadTweet"];
    
    [self.nManager loadTweetWithSid:@"85000736" successful:^(TweetResponse * _Nonnull response) {
        XCTAssert(response);
        XCTAssert([response.sid isEqualToString:@"850007368138018817"]);
        XCTAssert(response.text);
        XCTAssert(response.createdAt);
        [expectation fulfill];
    } failed:^(NSError * _Nonnull error) {
        XCTAssertNotNil(error, @"testLoadTweetWithSid error");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:expectionTime handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
}

- (void)testLoadTweetListSuccessful {
    XCTestExpectation *expectation = [self expectationWithDescription:@"loadTweetList"];
    
    [self.nManager loadTweetUser:@"elonmusk" count:10 successful:^(TweetListResponse * _Nonnull response) {
        XCTAssert(response);
        [expectation fulfill];
    } failed:^(NSError * _Nonnull error) {
        XCTAssertNotNil(error, @"testLoadTweetWithSid error");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:expectionTime handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
}

@end
