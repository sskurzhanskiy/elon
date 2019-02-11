//
//  NetworkManager.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 08/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "NetworkManager.h"

#import "Environment.h"

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

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSString *token;

@end

@implementation NetworkManager

-(instancetype)init
{
    if(self = [super init]) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:configuration];
        
        if(self.token == nil) {
            [self authenticationWithCompletion:^(NSDictionary *dict) {
                self.token = dict[@"access_token"];
            } failed:^{
                self.token = nil;
            }];
        }
    }
    
    return self;
}

-(void)authenticationWithCompletion:(void(^)(NSDictionary*))successfulBlock failed:(void(^)(void))failedBlock
{
    if(self.token) {
        if(successfulBlock) {
            successfulBlock(nil);
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
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if([(NSHTTPURLResponse*)response statusCode]/200 == 0 || error) {
            if(failedBlock) {
                failedBlock();
            }
            return;
        }
        
        NSError* sError = nil;
        NSDictionary *object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&sError];
        if(object == nil) {return;}
        
        if(object[@"errors"]) {
            self.token = nil;
            if(failedBlock) {
                failedBlock();
            }
        }
        
        self.token = object[@"access_token"];
        if(successfulBlock) {
            successfulBlock(object);
        }
    }];
    [task resume];
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

    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if([(NSHTTPURLResponse*)response statusCode]/200 == 0 || error) {
            if(failedBlock) {
                failedBlock();
            }
            return;
        }
        
        NSError* sError = nil;
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&sError];
        if(object == nil) {return;}
        
        if([object isKindOfClass:NSDictionary.class]) {
            if(object[@"errors"]) {
                if(failedBlock) {
                    failedBlock();
                }
            }
            return;
        }
        
        if(successfulBlock) {
            successfulBlock(object);
        }
    }];
    [task resume];
}

-(void)loadTweetWithSid:(NSString*)tweetSid successful:(void(^)(NSDictionary*))successfulBlock failed:(void(^)(void))failedBlock
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
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if([(NSHTTPURLResponse*)response statusCode]/200 == 0 || error) {
            if(failedBlock) {
                failedBlock();
            }
            return;
        }
        
        NSError* sError = nil;
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&sError];
        if(object == nil) {return;}
        
        if(![object isKindOfClass:NSDictionary.class]) {return;}
        if(object[@"errors"]) {
            if(failedBlock) {
                failedBlock();
            }
        } else {
            if(successfulBlock) {
                successfulBlock(object);
            }
        }
    }];
    [task resume];
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

@end
