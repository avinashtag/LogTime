//
//  Logs+CoreDataProperties.h
//  
//
//  Created by Avinash Tag on 30/05/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Logs.h"

NS_ASSUME_NONNULL_BEGIN

@interface Logs (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *stamp;
@property (nullable, nonatomic, retain) NSString *logTime;
@property (nullable, nonatomic, retain) NSString *remainingTime;
@property (nullable, nonatomic, retain) NSString *breakTime;

@end

NS_ASSUME_NONNULL_END
