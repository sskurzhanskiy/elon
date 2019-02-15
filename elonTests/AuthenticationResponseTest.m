//
//  AuthenticationResponseTest.m
//  elonTests
//
//  Created by Sergey Skurzhanskiy on 15/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AuthenticationResponse.h"

@interface AuthenticationResponseTest : XCTestCase

@end

@implementation AuthenticationResponseTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testAuthenticationSuccessful {
    NSDictionary *object = @{@"token_type":@"bearer",
                             @"access_token":@"AAAAFAAADAAAAAAAA"};
    NSError *error = nil;
    AuthenticationResponse *response = [[AuthenticationResponse alloc] initWithObject:object error:&error];
    XCTAssertNil(error);
    XCTAssertEqual(response.tokenType, @"bearer");
    XCTAssertEqual(response.accessToken, @"AAAAFAAADAAAAAAAA");
}

- (void)testAuthenticationResponseNotCorrect {
    NSError *error = nil;
    AuthenticationResponse *response = [[AuthenticationResponse alloc] initWithObject:@[] error:&error];
    XCTAssert(error);
}

@end
