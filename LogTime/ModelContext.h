//
//  ModelContext.h
//  PQAApp
//
//  Created by Avinash Tag on 24/12/15.
//  Copyright © 2015 Rohde & Schwarz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ModelContext : NSObject


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
+(ModelContext*) sharedContext;


-(void)removeIfExist:(Class)classs;
- (void) removeEntity:(NSManagedObject *)entity;

- (NSManagedObject *) insertEntity:(Class)classs;
- (NSArray <NSManagedObject *>*) fetchEntities:(Class)classs;
- (NSArray <NSManagedObject *>*) fetchEntities:(Class)classs perdicate:(NSPredicate *)predicate;
- (NSArray <NSManagedObject *>*) fetchEntities:(Class)classs perdicate:(NSPredicate *)predicate sortKey:(NSString *)sortKey ascending:(BOOL)ascending;
- (NSManagedObject *) fetchEntity:(Class)classs;
- (NSManagedObject *) fetchEntity:(Class)classs perdicate:(NSPredicate *)predicate;
- (NSManagedObject *) fetchEntity:(Class)classs perdicate:(NSPredicate *)predicate sortKey:(NSString *)sortKey ascending:(BOOL)ascending;
@end
