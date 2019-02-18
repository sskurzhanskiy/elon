//
//  TweetListResponseList.m
//  elonTests
//
//  Created by Sergey Skurzhanskiy on 18/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TweetResponse.h"
#import "TweetListResponse.h"

@interface TweetListResponseTest : XCTestCase

@end

@implementation TweetListResponseTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testTweetResponseTest {
    NSArray *srcResponse = @[@{@"created_at": @"Thu Apr 06 15:28:43 +0000 2017",
                                  @"id_str": @"850007368138018817",
                                  @"text": @"RT @TwitterDev: 1/ Today we’re sharing our vision for the future of the Twitter API platform!nhttps://t.co/XweGngmxlP",
                                  @"favorite_count": @(26),
                                  @"retweet_count": @(284)
                                  }];
    
    NSError *error = nil;
    TweetListResponse *response = [[TweetListResponse alloc] initWithObject:srcResponse error:&error];
    for(TweetResponse *tResponse in response.tweetList) {
        XCTAssert([tResponse.createdAt isEqualToString:@"Thu Apr 06 15:28:43 +0000 2017"]);
        XCTAssert([tResponse.sid isEqualToString:@"850007368138018817"]);
        XCTAssert([tResponse.text isEqualToString:@"RT @TwitterDev: 1/ Today we’re sharing our vision for the future of the Twitter API platform!nhttps://t.co/XweGngmxlP"]);
        XCTAssertTrue(tResponse.favoriteCount == 26);
        XCTAssertTrue(tResponse.retweetCount == 284);
    }
}

- (void)testAuthenticationResponseNotCorrect {
    NSError *error = nil;
    TweetListResponse *response = [[TweetListResponse alloc] initWithObject:@{} error:&error];
    XCTAssert(error);
}

@end
