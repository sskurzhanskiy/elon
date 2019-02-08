//
//  LTweet.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 08/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "LTweet.h"

@implementation LTweet

-(instancetype)init
{
    if(self = [super init]) {
        self.text = @"Text Text TextText Text Text";
        self.publishedDate = @"08.02.2019";
    }
    
    return self;
}

@end
