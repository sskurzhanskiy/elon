//
//  Response.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 15/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "Response.h"

@implementation Response

-(instancetype)initWithObject:(id)object error:(NSError**)error
{
    if(self = [super init]) {
        if(error == nil) {return self;}
        if([object isKindOfClass:NSDictionary.class] && object[@"errors"]) {
            NSArray *errors = object[@"errors"];
            if(errors.count == 0) {
                *error = [NSError errorWithDomain:@"Server" code:-2 userInfo:@{NSLocalizedDescriptionKey: @"Undefined error"}];
                return self;
            }
            
            NSDictionary *errorMap = [errors firstObject];
            NSInteger eCode = [errorMap[@"code"] integerValue];
            NSString *message = errorMap[@"message"];
            
            *error = [NSError errorWithDomain:@"Server" code:eCode userInfo:@{NSLocalizedDescriptionKey: message}];
            return self;
        }
        
        if(![self disassembledObject:object]) {
            *error = [NSError errorWithDomain:@"Response" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Response object is not correct"}];
            return self;
        }
    }
    
    return self;
}

-(BOOL)disassembledObject:(id)object
{
    return NO;
}

@end
