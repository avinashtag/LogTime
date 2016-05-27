//
//  Logs.m
//  LogTime
//
//  Created by Avinash Tag on 27/05/16.
//  Copyright © 2016 ZooZoo. All rights reserved.
//

#import "Logs.h"
#import "ModelContext.h"
#import "NSDate+ZDate.h"

@implementation Logs

// Insert code here to add functionality to your managed object subclass


+ (NSArray *)logsOfDate:(NSDate *)date{
    return [[ModelContext sharedContext] fetchEntities:[Logs class] perdicate:[NSPredicate predicateWithFormat:@"stamp >= %@ AND stamp < %@", date , [date nextDate]] sortKey:@"stamp" ascending:YES];
}

@end
