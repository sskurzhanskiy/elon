//
//  Tweet+CoreDataProperties.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//
//

#import "Tweet+CoreDataProperties.h"

@implementation Tweet (CoreDataProperties)

+ (NSFetchRequest<Tweet *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
}

@dynamic createAt;
@dynamic sid;
@dynamic text;
@dynamic retweetCount;
@dynamic favoriteCount;

@end
