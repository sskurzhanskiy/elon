//
//  ResponseTest.m
//  elonTests
//
//  Created by Sergey Skurzhanskiy on 15/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Response.h"

@interface ResponseTest : XCTestCase

@end

@implementation ResponseTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testResponseSuccessfulWithError {
    NSDictionary *object = @{@"errors": @[@{@"code": @(215),
                                            @"message": @"Bad Authentication data."
                                            }]
                             };
    NSError *error = nil;
    Response *response = [[Response alloc] initWithObject:object error:&error];
    XCTAssert(error);
    XCTAssertTrue(error.code == 215);
    XCTAssertEqual(error.localizedDescription, @"Bad Authentication data.");
}

-(void)testResponseUndefinedError {
    NSDictionary *object = @{@"errors": @[]};
    NSError *error = nil;
    Response *response = [[Response alloc] initWithObject:object error:&error];
    XCTAssert(error);
}

-(void)testDesassembledOblect {
    Response *response = [[Response alloc] initWithObject:@[] error:nil];
    XCTAssertFalse([response disassembledObject:@[]]);
}

@end
