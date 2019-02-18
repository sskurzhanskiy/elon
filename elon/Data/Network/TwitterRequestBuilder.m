//
//  UrlRequestBuilder.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 18/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "TwitterRequestBuilder.h"

#import "Environment.h"

static NSString *tokenUDKey = @"token-user-defaults-key";

static NSString *oauthEndpoint = @"oauth2/token";
static NSString *tweetTimelinesEndpoint = @"1.1/statuses/user_timeline.json";
static NSString *tweetShowEndpoint = @"1.1/statuses/show.json";

typedef NS_ENUM(NSInteger, TwitterRequestEndpoint) {
    TwitterRequestEndpointOauth,
    TwitterRequestEndpointTimelines,
    TwitterRequestEndpointShow
};

@implementation TwitterRequestBuilder

-(NSURLRequest*)requestAuthentication
{
    NSString *encodingToken = [self encodingTwitterToken];
    NSString *httpHeaderValue = [NSString stringWithFormat:@"Basic %@", encodingToken];
    
    NSURL *url = [NSURL URLWithString:[self urlForEndpoint:TwitterRequestEndpointOauth]];
    NSData *parameters = [@"grant_type=client_credentials" dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:httpHeaderValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:parameters];
    
    return [request copy];
}

-(NSURLRequest*)requestShowWithParameters:(NSDictionary*)params;
{
    if(params.allKeys.count == 0) {return nil;}
    
    NSURLComponents *urlComponent = [NSURLComponents componentsWithString:[self urlForEndpoint:TwitterRequestEndpointShow]];
    urlComponent.queryItems = [self queryItemsForDictionary:params];
    
    return [self getAuthenticatedRequestWithUrlComponent:urlComponent];
}

-(NSURLRequest*)requestTimelineWithParameters:(NSDictionary*)params
{
    if(params.allKeys.count == 0) {return nil;}
    
    NSURLComponents *urlComponent = [NSURLComponents componentsWithString:[self urlForEndpoint:TwitterRequestEndpointTimelines]];
    urlComponent.queryItems = [self queryItemsForDictionary:params];
    
    return [self getAuthenticatedRequestWithUrlComponent:urlComponent];
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

-(NSString*)urlForEndpoint:(TwitterRequestEndpoint)endpoint {
    NSString *result = nil;
    NSString *baseUrl = Environment.sharedEnvironment.baseURL;
    switch (endpoint) {
        case TwitterRequestEndpointOauth:
            result = [NSString stringWithFormat:@"%@/%@", baseUrl, oauthEndpoint];
            break;
        case TwitterRequestEndpointTimelines:
            result = [NSString stringWithFormat:@"%@/%@", baseUrl, tweetTimelinesEndpoint];
            break;
        case TwitterRequestEndpointShow:
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
