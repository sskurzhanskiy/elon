//
//  elonTests.m
//  elonTests
//
//  Created by Sergey Skurzhanskiy on 13/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NetworkManager.h"

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
    XCTestExpectation *expectation = [self expectationWithDescription:@"expection"];

    [self.nManager authenticationWithCompletion:^{
        [expectation fulfill];
    } failed:^(NSError * _Nonnull error) {
        XCTFail(@"%@", [error description]);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:expectionTime handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
}

@end
