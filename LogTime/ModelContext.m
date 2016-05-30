//
//  ModelContext.m
//  PQAApp
//
//  Created by Avinash Tag on 24/12/15.
//  Copyright © 2015 Rohde & Schwarz. All rights reserved.
//

#import "ModelContext.h"

@implementation ModelContext


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;



+(ModelContext*) sharedContext{
    static dispatch_once_t dispatchOnce = 0;
    static ModelContext *sharedContext;
    
    dispatch_once(&dispatchOnce, ^{
        sharedContext = [[ModelContext alloc]init];
    });
    return sharedContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LogTime" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"LogTime.sqlite"];
    NSError *error = nil;

    NSDictionary *fileAttributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
    if (![[NSFileManager defaultManager] setAttributes:fileAttributes ofItemAtPath:[storeURL path] error:&error]) {
        // Deal with the error
    }

    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        else{
            NSLog(@"** Value saved in database **");
        }
    }
}


- (NSManagedObject *) insertEntity:(Class)classs{
    NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(classs) inManagedObjectContext:[self managedObjectContext]];
    [managedObject awakeFromInsert];
    return managedObject;
}

- (NSArray <NSManagedObject *>*) fetchEntities:(Class)classs{
    
    return [self fetchEntities:classs perdicate:nil];
}

- (NSArray <NSManagedObject *>*) fetchEntities:(Class)classs perdicate:(NSPredicate *)predicate{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass(classs)  inManagedObjectContext: context];
    [fetch setEntity:entityDescription];
    if (predicate) {
        [fetch setPredicate:predicate];
    }
    NSError * error = nil;
    return [context executeFetchRequest:fetch error:&error];
}

- (NSArray <NSManagedObject *>*) fetchEntities:(Class)classs perdicate:(NSPredicate *)predicate sortKey:(NSString *)sortKey ascending:(BOOL)ascending{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass(classs)  inManagedObjectContext: context];
    [fetch setEntity:entityDescription];
    if (predicate) {
        [fetch setPredicate:predicate];
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey
                                                                   ascending:ascending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetch setSortDescriptors:sortDescriptors];
    NSError * error = nil;
    return [context executeFetchRequest:fetch error:&error];
}


- (NSManagedObject *) fetchEntity:(Class)classs{
    return [self fetchEntity:classs perdicate:nil];
}

- (NSManagedObject *) fetchEntity:(Class)classs perdicate:(NSPredicate *)predicate{
    
    NSArray *fetchedObjects = [self fetchEntities:classs perdicate:predicate];
    return (fetchedObjects.count) ? fetchedObjects[0] : nil;
}

-(void)removeIfExist:(Class)classs{
    
    NSArray *objects = [self fetchEntities:classs];
    
    [objects enumerateObjectsUsingBlock:^(NSManagedObject * object, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [self.managedObjectContext deleteObject:object];
    }];
    [self saveContext];
}

- (void) removeEntity:(NSManagedObject *)entity{
    @try {
        if (entity) {
            [self.managedObjectContext deleteObject:entity];
            [self saveContext];
        }

    }
    @catch (NSException *exception) {
        
    }
}

@end
