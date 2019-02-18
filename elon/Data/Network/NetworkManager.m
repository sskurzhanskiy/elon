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
#import "TweetListResponse.h"

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

-(void)loadTweetUser:(NSString*)screenUser count:(NSInteger)count successful:(void(^)(TweetListResponse*))successfulBlock failed:(void(^)(NSError*))failedBlock
{
    NSURLComponents *urlComponent = [NSURLComponents componentsWithString:[self urlForEndpoint:TwitterApiEndpointTimelines]];
    urlComponent.queryItems = [self queryItemsForDictionary:@{@"screen_name":screenUser,
                                                              @"count":[NSString stringWithFormat:@"%ld", (long)count]
                                                              }];
    
    NSURLRequest *request = [self getAuthenticatedRequestWithUrlComponent:urlComponent];
    [self resumeTaskWithRequest:request successful:^(id object) {
        NSError *error = nil;
        TweetListResponse *listResponse = [[TweetListResponse alloc] initWithObject:object error:&error];
        if(error) {
            if(failedBlock) {
                failedBlock(error);
            }
        }
        if(successfulBlock) {
            successfulBlock(listResponse);
        }
    } failed:^(NSError *error) {
        if(failedBlock) {
            failedBlock(error);
        }
    }];
}

-(void)loadTweetWithSid:(NSString*)tweetSid successful:(void(^)(TweetResponse*))successfulBlock failed:(void(^)(NSError*))failedBlock
{
    NSURLComponents *urlComponent = [NSURLComponents componentsWithString:[self urlForEndpoint:TwitterApiEndpointShow]];
    urlComponent.queryItems = [self queryItemsForDictionary:@{@"id": tweetSid}];
    
    NSURLRequest *request = [self getAuthenticatedRequestWithUrlComponent:urlComponent];
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

-(NSURLRequest*)getAuthenticatedRequestWithUrlComponent:(NSURLComponents*)urlComponent
{
    NSString *tokenHeader = self.token ? [NSString stringWithFormat:@"Bearer %@", self.token] : @"";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlComponent.URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:tokenHeader forHTTPHeaderField:@"Authorization"];
    
    return [request copy];
}

-(NSArray<NSURLQueryItem*>*)queryItemsForDictionary:(NSDictionary*)params
{
    NSMutableArray<NSURLQueryItem*> *items = [NSMutableArray array];
    for(NSString *key in params.allKeys) {
        NSURLQueryItem *query = [[NSURLQueryItem alloc] initWithName:key value:params[key]];
        [items addObject:query];
    }
    
    return [items copy];
}

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
