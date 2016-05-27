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
@end
