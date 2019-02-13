//
//  CDStorage.m
//  elon
//
//  Created by Sergey Skurzhanskiy on 11/02/2019.
//  Copyright © 2019 Sergey Skurzhanskiy. All rights reserved.
//

#import "CDStorage.h"

#import "Tweet+CoreDataClass.h"

static NSString *const CDSQLFileName = @"elon";
static NSString *const CDModelFileName = @"elon";

@interface CDStorage()

@property (nonatomic, strong) NSPersistentStoreCoordinator *mainCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *mainContext;
@property (nonatomic, strong) NSManagedObjectContext *backgroundContext;

@property (nonatomic, strong) NSManagedObjectModel *objectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *backgroundCoordinator;

@end

@implementation CDStorage

- (instancetype)init {
    if (self = [super init]) {
        NSURL *storeUrl = [CDStorage storeURL];
        
        self.objectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSError *error = nil;
        self.mainCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.objectModel];
        if (![self.mainCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
            NSAssert(false, @"Fail to add persistentStore");
            return nil;
        }
        
        self.mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        self.mainContext.persistentStoreCoordinator = self.mainCoordinator;
        
        self.backgroundCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.objectModel];
        if (![self.backgroundCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
            NSAssert(false, @"Fail to add persistentStore");
            return nil;
        }
        
        self.backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        self.backgroundContext.persistentStoreCoordinator = self.backgroundCoordinator;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mocDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:self.backgroundContext];
        
    }
    return self;
}

-(NSArray<Tweet*>*)allTweets
{
    NSEntityDescription *entityDescriptor = [NSEntityDescription entityForName:@"Tweet" inManagedObjectContext:self.mainContext];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescriptor];
    
    NSArray* sortDescriptors = @[ [[NSSortDescriptor alloc] initWithKey:@"createAt" ascending:NO] ];
    [request setSortDescriptors:sortDescriptors];
    
    NSError* error = nil;
    NSArray* resultSet = [self.mainContext executeFetchRequest:request error:&error];
    if(resultSet == nil) {
        NSLog( @"%s %@", __PRETTY_FUNCTION__, error );
        return nil;
    } else {
        return resultSet;
    }
}

-(NSArray<Tweet*>*)tweetsCount:(NSInteger)count
{
    NSEntityDescription *entityDescriptor = [NSEntityDescription entityForName:@"Tweet" inManagedObjectContext:self.mainContext];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescriptor];
    request.fetchLimit = count;
    
    NSArray* sortDescriptors = @[ [[NSSortDescriptor alloc] initWithKey:@"createAt" ascending:NO] ];
    [request setSortDescriptors:sortDescriptors];
    
    NSError* error = nil;
    NSArray* resultSet = [self.mainContext executeFetchRequest:request error:&error];
    if(resultSet == nil) {
        NSLog( @"%s %@", __PRETTY_FUNCTION__, error );
        return nil;
    } else {
        return resultSet;
    }
}

-(Tweet*)tweetWithSid:(NSString*)tweetSid
{
    return [self tweetWithSid:tweetSid context:self.mainContext];
}

-(void)addTweet:(NSDictionary*)srcTweet
{
    NSString *tweetSid = srcTweet[@"id_str"];
    Tweet *tweet = [self tweetWithSid:tweetSid context:self.backgroundContext];
    if(tweet == nil) {
        tweet = [self createNewTweetEntity];
        tweet.sid = tweetSid;
    }
    [tweet updateWithSource:srcTweet];
    
    NSError *error = nil;
    [self.backgroundContext save:&error];
    if(error) {
        NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
    }
}

#pragma mark - Notifications

-(void)mocDidSaveNotification:(NSNotification *)notification {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        for(NSManagedObject *object in [[notification userInfo] objectForKey:NSUpdatedObjectsKey]) {
            [[weakSelf.mainContext objectWithID:[object objectID]] willAccessValueForKey:nil];
        }
        [weakSelf.mainContext mergeChangesFromContextDidSaveNotification:notification];
    });
}

#pragma mark - Private methods

+(NSURL*)storeURL {
    NSString *storeFilename = [NSString stringWithFormat:@"%@.sqlite", CDSQLFileName];
    return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:storeFilename];
}

+(NSURL*)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(Tweet*)tweetWithSid:(NSString*)tweetSid context:(NSManagedObjectContext*)context
{
    NSEntityDescription *entityDescriptor = [NSEntityDescription entityForName:@"Tweet" inManagedObjectContext:context];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescriptor];
    [request setPredicate:[NSPredicate predicateWithFormat:@"sid = %@", tweetSid]];
    
    NSError* error = nil;
    NSArray* resultSet = [context executeFetchRequest:request error:&error];
    
    if(resultSet == nil) {
        return nil;
    }
    
    return (resultSet.count > 0) ? resultSet.firstObject : nil;
}

-(Tweet*)createNewTweetEntity
{
    NSEntityDescription *entityDescriptor = [NSEntityDescription entityForName:@"Tweet" inManagedObjectContext:self.backgroundContext];
    Tweet *tweet = [[Tweet alloc] initWithEntity:entityDescriptor insertIntoManagedObjectContext:self.backgroundContext];
    
    return tweet;
}

@end
