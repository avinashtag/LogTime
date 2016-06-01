//
//  LogsMonth.m
//  LogTime
//
//  Created by Avinash Tag on 01/06/16.
//  Copyright © 2016 ZooZoo. All rights reserved.
//

#import "LogsMonth.h"
#import "ModelContext.h"
#import "NSDate+ZDate.h"
#import "NSString+TString.h"


@implementation LogsMonth

// Insert code here to add functionality to your managed object subclass
+ (LogsMonth *)logsOfMonth:(NSDate*)date{
    
    
    LogsMonth *logMonth = (LogsMonth *)[[ModelContext sharedContext] fetchEntity:[LogsMonth class] perdicate:[NSPredicate predicateWithFormat:@"stamp >= %@ AND stamp < %@", date , [date nextMonthDate]] sortKey:@"stamp" ascending:YES];
    if (!logMonth) {
        logMonth = (LogsMonth *)[[ModelContext sharedContext]insertEntity:[LogsMonth class]];
    }
    return logMonth;
}

+ (NSArray *) logsFrom:(NSDate*)fromDate to:(NSDate*)toDate{
    
    
    
    return [[ModelContext sharedContext] fetchEntities:[LogsMonth class] perdicate:[NSPredicate predicateWithFormat:@"stamp >= %@ AND stamp <= %@", fromDate , toDate] sortKey:@"stamp" ascending:YES];

}
@end
