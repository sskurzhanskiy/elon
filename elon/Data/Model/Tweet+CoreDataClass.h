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

NS_ASSUME_NONNULL_BEGIN

@interface Tweet : NSManagedObject

-(void)updateWithSource:(NSDictionary*)scr;

@end

NS_ASSUME_NONNULL_END

#import "Tweet+CoreDataProperties.h"
