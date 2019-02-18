//
//  TweetResponse.m
//  elonTests
//
//  Created by Sergey Skurzhanskiy on 15/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TweetResponse.h"

@interface TweetResponseTest : XCTestCase

@end

@implementation TweetResponseTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testTweetResponseTest {
    NSDictionary *srcResponse = @{@"created_at": @"Thu Apr 06 15:28:43 +0000 2017",
                                  @"id_str": @"850007368138018817",
                                  @"text": @"RT @TwitterDev: 1/ Today we’re sharing our vision for the future of the Twitter API platform!nhttps://t.co/XweGngmxlP",
                                  @"favorite_count": @(26),
                                  @"retweet_count": @(284)
                                  };
    
    NSError *error = nil;
    TweetResponse *response = [[TweetResponse alloc] initWithObject:srcResponse error:&error];
    XCTAssertNil(error);
    XCTAssertEqual(response.createdAt, @"Thu Apr 06 15:28:43 +0000 2017");
    XCTAssertEqual(response.sid, @"850007368138018817");
    XCTAssertEqual(response.text, @"RT @TwitterDev: 1/ Today we’re sharing our vision for the future of the Twitter API platform!nhttps://t.co/XweGngmxlP");
    XCTAssertTrue(response.favoriteCount == 26);
    XCTAssertTrue(response.retweetCount == 284);
}

- (void)testAuthenticationResponseNotCorrect {
    NSError *error = nil;
    TweetResponse *response = [[TweetResponse alloc] initWithObject:@[] error:&error];
    XCTAssert(error);
}

@end
