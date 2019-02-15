//
//  NetworkManager.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 08/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "NetworkManager.h"

#import "Environment.h"
#import "AuthenticationResponse.h"
#import "TweetResponse.h"

static NSString *tokenUDKey = @"token-user-defaults-key";

static NSString *oauthEndpoint = @"oauth2/token";
static NSString *tweetTimelinesEndpoint = @"1.1/statuses/user_timeline.json";
static NSString *tweetShowEndpoint = @"1.1/statuses/show.json";

typedef NS_ENUM(NSInteger, TwitterApiEndpoint) {
    TwitterApiEndpointOauth,
    TwitterApiEndpointTimelines,
    TwitterApiEndpointShow
};

@interface NetworkManager()

@property (nonatomic, copy) NSURLSession *session;
@property (nonatomic, copy) NSString *token;

@end

@implementation NetworkManager

-(instancetype)init
{
    if(self = [super init]) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:configuration];
    }
    
    return self;
}

-(void)authenticationWithCompletion:(void(^ _Nullable )(void))successfulBlock failed:(void(^)(NSError*))failedBlock
{
    if(self.token) {
        if(successfulBlock) {
            successfulBlock();
        }
        
        return;
    }
    
    NSString *encodingToken = [self encodingTwitterToken];
    NSString *httpHeaderValue = [NSString stringWithFormat:@"Basic %@", encodingToken];
    
    NSURL *url = [NSURL URLWithString:[self urlForEndpoint:TwitterApiEndpointOauth]];
    NSData *parameters = [@"grant_type=client_credentials" dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:httpHeaderValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:parameters];
    
    __weak typeof(self) weakSelf = self;
    [self resumeTaskWithRequest:request successful:^(id object) {
        NSError *error = nil;
        AuthenticationResponse *response = [[AuthenticationResponse alloc] initWithObject:object error:&error];
        if(error) {
            if(failedBlock) {
                failedBlock(error);
            }
            return;
        }
        weakSelf.token = response.accessToken;
        if(successfulBlock) {
            successfulBlock();
        }
    } failed:^(NSError *error) {
        weakSelf.token = nil;
        if(failedBlock) {
            failedBlock(error);
        }
    }];
}

-(void)loadTweetUser:(NSString*)screenUser count:(NSInteger)count successful:(void(^)(NSArray*))successfulBlock failed:(void(^)(void))failedBlock {
    NSString *tokenHeader = [NSString stringWithFormat:@"Bearer %@", self.token];
    
    NSURLComponents *urlComponent = [NSURLComponents componentsWithString:[self urlForEndpoint:TwitterApiEndpointTimelines]];
    NSURLQueryItem *userItem = [[NSURLQueryItem alloc] initWithName:@"screen_name" value:screenUser];
    NSURLQueryItem *countItem = [[NSURLQueryItem alloc] initWithName:@"count" value:[NSString stringWithFormat:@"%ld", (long)count]];
    urlComponent.queryItems = @[userItem, countItem];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlComponent.URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:tokenHeader forHTTPHeaderField:@"Authorization"];

    [self resumeTaskWithRequest:request successful:^(id object) {
        if(successfulBlock) {
            successfulBlock((NSArray*)object);
        }
    } failed:^(NSError *error) {
        if(failedBlock) {
            failedBlock();
        }
    }];
}

-(void)loadTweetWithSid:(NSString*)tweetSid successful:(void(^)(TweetResponse*))successfulBlock failed:(void(^)(NSError*))failedBlock
{
    NSString *tokenHeader = [NSString stringWithFormat:@"Bearer %@", self.token];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *tweetNumber = [formatter numberFromString:tweetSid];
    
    NSURLComponents *urlComponent = [NSURLComponents componentsWithString:[self urlForEndpoint:TwitterApiEndpointShow]];
    NSURLQueryItem *tweeId = [[NSURLQueryItem alloc] initWithName:@"id" value:[NSString stringWithFormat:@"%@", tweetNumber]];
    urlComponent.queryItems = @[tweeId];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlComponent.URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:tokenHeader forHTTPHeaderField:@"Authorization"];
    
    
    [self resumeTaskWithRequest:request successful:^(id object) {
        NSError *error = nil;
        TweetResponse *response = [[TweetResponse alloc] initWithObject:object error:&error];
        if(error) {
            if(failedBlock) {
                failedBlock(error);
            }
            return;
        }
        
        if(successfulBlock) {
            successfulBlock(response);
        }
    } failed:^(NSError *error) {
        if(failedBlock) {
            failedBlock(error);
        }
    }];
}

#pragma mark - Properties

-(void)setToken:(NSString *)token
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:token forKey:tokenUDKey];
    [ud synchronize];
}

-(NSString*)token {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    return [ud objectForKey:tokenUDKey];
}

#pragma mark - Private methods

-(NSString*)urlForEndpoint:(TwitterApiEndpoint)endpoint {
    NSString *result = nil;
    NSString *baseUrl = Environment.sharedEnvironment.baseURL;
    switch (endpoint) {
        case TwitterApiEndpointOauth:
            result = [NSString stringWithFormat:@"%@/%@", baseUrl, oauthEndpoint];
            break;
        case TwitterApiEndpointTimelines:
            result = [NSString stringWithFormat:@"%@/%@", baseUrl, tweetTimelinesEndpoint];
            break;
        case TwitterApiEndpointShow:
            result = [NSString stringWithFormat:@"%@/%@", baseUrl, tweetShowEndpoint];
            break;
    }
    
    return result;
}

-(NSString*)encodingTwitterToken {
    NSString *escapingTwitterKey = [Environment.sharedEnvironment.twitterKey stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *escapingTwitterSecret = [Environment.sharedEnvironment.twitterSecter stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSData *data = [[NSString stringWithFormat:@"%@:%@", escapingTwitterKey, escapingTwitterSecret] dataUsingEncoding:NSUTF8StringEncoding];
    
    return [data base64EncodedStringWithOptions:0];
}

-(void)resumeTaskWithRequest:(NSURLRequest*)request successful:(void(^)(id))successful failed:(void(^)(NSError*))failed
{
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if([(NSHTTPURLResponse*)response statusCode]/200 == 0 || error) {
            if(failed) {
                failed(error);
            }
            return;
        }
        
        NSError* sError = nil;
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&sError];
        
        if(successful) {
            successful(object);
        }
    }];
    [task resume];
}

@end
