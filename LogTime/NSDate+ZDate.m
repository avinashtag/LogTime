//
//  NSDate+ZDate.m
//  PQAApp
//
//  Created by Avinash Tag on 28/01/16.
//  Copyright © 2016 Rohde & Schwarz. All rights reserved.
//

#import "NSDate+ZDate.h"
#import "NSString+TString.h"

@implementation NSDate (ZDate)


- (NSString *) dateStringInFormat:(NSString*)format{
    
    NSDateFormatter *formator = [[NSDateFormatter alloc]init];
    [formator setDateFormat:format];
    return [formator stringFromDate:self];
}

- (NSInteger) dateMonth{
    
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar* calendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    NSDateComponents* components = [calendar components:flags fromDate:self];
    return components.month ;
}

- (NSDate *) nextDate{
    
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar* calendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    NSDateComponents* components = [calendar components:flags fromDate:self];
    components.day = components.day+1;
    NSDate* tomorrow = [calendar dateFromComponents:components];
    return tomorrow;
}

- (NSDate *) nextMonthDate{
    
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar* calendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    NSDateComponents* components = [calendar components:flags fromDate:self];
    components.month = components.month+1;
    NSDate* tomorrow = [calendar dateFromComponents:components];
    return tomorrow;
}

- (NSDate *) eliminateTime{
    return [[self dateStringInFormat:@"dd-MM-yyyy"] dateInFormat:@"dd-MM-yyyy"];
}

- (NSUInteger) daysInMonthCount{
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange range = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    NSUInteger numberOfDaysInMonth = range.length;
    return numberOfDaysInMonth;
}

- (NSDate *) startDateOfMonth{
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *dateStart = [cal startOfDayForDate:self];
    return dateStart;
}

- (NSArray *) datesInMonth{
    
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *dateStart = [cal startOfDayForDate:self];
    NSDate *firstDateOfMonth = [[NSString stringWithFormat:@"01/%@/%@", [dateStart dateStringInFormat:@"MM"],[dateStart dateStringInFormat:@"yyyy"]] dateInFormat:@"dd/MM/yyyy"];
    NSMutableArray *dates = [[NSMutableArray alloc]init];
    
    [dates addObject:firstDateOfMonth];
    NSInteger totalDays = [firstDateOfMonth daysInMonthCount];
    for (int i = 1; i<= totalDays; i++) {
        NSDate *lastDate = dates.lastObject;
        [dates addObject:[lastDate nextDate]];
    }
    return [[NSArray alloc]initWithArray:dates];
}
@end
