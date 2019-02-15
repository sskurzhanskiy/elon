//
//  Response.h
//  elon
//
//  Created by Sergey Skurzhanskiy on 15/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Response : NSObject

-(instancetype)initWithObject:(id)object error:(NSError**)error;

-(BOOL)disassembledObject:(id)object;

@end

NS_ASSUME_NONNULL_END
