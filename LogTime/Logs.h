//
//  Logs.h
//  LogTime
//
//  Created by Avinash Tag on 27/05/16.
//  Copyright © 2016 ZooZoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN



@interface Logs : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+ (NSArray *)logsOfDate:(NSDate *)date;
+ (NSArray *)logs:(NSInteger)month;
@end

NS_ASSUME_NONNULL_END

#import "Logs+CoreDataProperties.h"
