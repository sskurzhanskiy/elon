//
//  Tweet+CoreDataProperties.h
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//
//

#import "Tweet+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Tweet (CoreDataProperties)

+ (NSFetchRequest<Tweet *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *createAt;
@property (nullable, nonatomic, copy) NSString *sid;
@property (nullable, nonatomic, copy) NSString *text;
@property (nonatomic) int32_t retweetCount;
@property (nonatomic) int32_t favoriteCount;
@property (nonatomic) double_t timestamp;

@end

NS_ASSUME_NONNULL_END
