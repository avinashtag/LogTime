//
//  LogsMonth+CoreDataProperties.h
//  LogTime
//
//  Created by Avinash Tag on 01/06/16.
//  Copyright © 2016 ZooZoo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LogsMonth.h"

NS_ASSUME_NONNULL_BEGIN

@interface LogsMonth (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *breakTime;
@property (nullable, nonatomic, retain) NSNumber *logTime;
@property (nullable, nonatomic, retain) NSNumber *remainingTime;
@property (nullable, nonatomic, retain) NSDate *stamp;

@end

NS_ASSUME_NONNULL_END
