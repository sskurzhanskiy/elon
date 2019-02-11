//
//  TweetListVM.h
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TweetListInterface.h"

@class DataManager;

NS_ASSUME_NONNULL_BEGIN

@interface TweetListVM : NSObject<TweetListInterface>

-(instancetype)initWithDataManager:(DataManager*)dataManager;

@end

NS_ASSUME_NONNULL_END
