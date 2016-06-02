//
//  TodayViewController.m
//  LogTimeExtension
//
//  Created by Avinash Tag on 30/05/16.
//  Copyright © 2016 ZooZoo. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "Logs.h"
#import "NSDate+ZDate.h"
#import "NSString+TString.h"

@interface TodayViewController () <NCWidgetProviding>

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContextex;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModelex;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinatorex;
@end

@implementation TodayViewController
@synthesize managedObjectContextex = _managedObjectContextex;
@synthesize managedObjectModelex = _managedObjectModelex;
@synthesize persistentStoreCoordinatorex = _persistentStoreCoordinatorex;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (IBAction)stampDo:(id)sender {
    
    NSLog(@"Stamp Do");
    Logs *log = (Logs *)[self insertEntity:[Logs class]];
    log.stamp = [NSDate date];
    [self saveContext];
}


- (NSManagedObjectModel *)managedObjectModelex {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModelex != nil) {
        return _managedObjectModelex;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LogTime" withExtension:@"momd"];
    _managedObjectModelex = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModelex;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinatorex != nil) {
        return _persistentStoreCoordinatorex;
    }
    
    // Create the coordinator and store
    
    NSString *containerPath = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.zoozoo"].path;
    NSString *sqlitePath = [NSString stringWithFormat:@"%@/%@", containerPath, @"LogTime.sqlite"];

    _persistentStoreCoordinatorex = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModelex]];
//    NSURL *storeURL = [NSURL URLWithString:sqlitePath];

    NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"LogTime.sqlite"];
    NSError *error = nil;
    
    NSDictionary *fileAttributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
    if (![[NSFileManager defaultManager] setAttributes:fileAttributes ofItemAtPath:[storeURL path] error:&error]) {
        // Deal with the error
    }
    
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    @try {
        if (![_persistentStoreCoordinatorex addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
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

    } @catch (NSException *exception) {
        NSLog(@"Exception: %@",exception);
    } @finally {
        
    }
    
    return _persistentStoreCoordinatorex;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContextex != nil) {
        return _managedObjectContextex;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContextex = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContextex setPersistentStoreCoordinator:coordinator];
    return _managedObjectContextex;
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

- (NSManagedObject *) fetchEntity:(Class)classs perdicate:(NSPredicate *)predicate sortKey:(NSString *)sortKey ascending:(BOOL)ascending{
    
    NSArray *fetchedObjects = [self fetchEntities:classs perdicate:predicate sortKey:sortKey ascending:ascending];
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


- (NSArray *)logsOfDate:(NSDate *)date{
    return [self fetchEntities:[Logs class] perdicate:[NSPredicate predicateWithFormat:@"stamp >= %@ AND stamp < %@", date , [date nextDate]] sortKey:@"stamp" ascending:YES];
}

- (NSArray *)logs:(NSInteger)month{
    
    NSDate *date = [[NSString stringWithFormat:@"01-%lu-2016",(unsigned long)month] dateInFormat:@"dd-MM-yyyy"];
    return [self fetchEntities:[Logs class] perdicate:[NSPredicate predicateWithFormat:@"stamp >= %@ AND stamp < %@", date , [date nextMonthDate]] sortKey:@"stamp" ascending:YES];
}

@end
