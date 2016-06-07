//
//  Logs+CoreDataProperties.h
//  LogTime
//
//  Created by Avinash Tag on 07/06/16.
//  Copyright © 2016 ZooZoo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Logs.h"

NS_ASSUME_NONNULL_BEGIN

@interface Logs (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *stamp;
@property (nullable, nonatomic, retain) NSNumber *mark;

@end

NS_ASSUME_NONNULL_END
