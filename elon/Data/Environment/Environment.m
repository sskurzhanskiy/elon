//
//  Environment.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "Environment.h"

@interface Environment ()

@property (copy, nonatomic) NSString *environment;
@property (copy, nonatomic) NSDictionary *variables;

@end

@implementation Environment

+ (instancetype) sharedEnvironment {
    static Environment *instance;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

-(instancetype)init
{
    if(self = [super init]) {
        NSString *file = [[NSBundle mainBundle] pathForResource:@"Environment" ofType:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:file];
#ifdef DEBUG
        self.environment = @"Debug";
#else
        self.environment = @"Release";
#endif
        self.variables = dict[self.environment];
    }
    
    return self;
}

#pragma mark - Property

-(NSString*)twitterKey {
    return self.variables[@"twitterCustomerKey"];
}

-(NSString*)twitterSecter {
    return self.variables[@"twitterCustomerSecret"];
}

-(NSString*)baseURL {
    return self.variables[@"baseURL"];
}

@end
