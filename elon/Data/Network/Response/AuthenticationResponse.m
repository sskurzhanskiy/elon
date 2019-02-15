//
//  AuthenticationResponse.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 15/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "AuthenticationResponse.h"

@interface AuthenticationResponse()

@property (nonatomic, copy, readwrite) NSString *tokenType;
@property (nonatomic, copy, readwrite) NSString *accessToken;

@end

@implementation AuthenticationResponse

-(BOOL)disassembledObject:(id)object
{
    if(![object isKindOfClass:NSDictionary.class]) {
        return NO;
    }
    
    NSDictionary *rMap = (NSDictionary*)object;
    self.tokenType = rMap[@"token_type"];
    self.accessToken = rMap[@"access_token"];
    
    return self.tokenType && self.accessToken;
}

@end
