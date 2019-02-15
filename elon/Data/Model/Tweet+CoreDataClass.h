//
//  Tweet+CoreDataClass.h
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TweetResponse;

NS_ASSUME_NONNULL_BEGIN

@interface Tweet : NSManagedObject

-(void)updateWithSource:(TweetResponse*)response;

@end

NS_ASSUME_NONNULL_END

#import "Tweet+CoreDataProperties.h"
