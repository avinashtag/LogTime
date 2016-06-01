//
//  LogsMonth.h
//  LogTime
//
//  Created by Avinash Tag on 01/06/16.
//  Copyright © 2016 ZooZoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef NS_ENUM(NSUInteger, LogMonth) {
    
    Jan = 1,
    Feb,
    Mar,
    Apr,
    May,
    Jun,
    Jul,
    Aug,
    Sep,
    Oct,
    Nov,
    Dec,
};

NS_ASSUME_NONNULL_BEGIN

@interface LogsMonth : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+ (LogsMonth *)logsOfMonth:(NSDate*)date;
+ (NSArray *) logsFrom:(NSDate*)fromDate to:(NSDate*)toDate;
@end

NS_ASSUME_NONNULL_END

#import "LogsMonth+CoreDataProperties.h"
