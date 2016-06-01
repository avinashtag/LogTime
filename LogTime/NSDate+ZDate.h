//
//  NSDate+ZDate.h
//  PQAApp
//
//  Created by Avinash Tag on 28/01/16.
//  Copyright © 2016 Rohde & Schwarz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ZDate)

- (NSString *) dateStringInFormat:(NSString*)format;
- (NSDate *) nextDate;
- (NSDate *) nextMonthDate;
- (NSDate *) eliminateTime;
- (NSInteger) dateMonth;
- (NSUInteger) daysInMonthCount;
- (NSArray *) datesInMonth;
- (NSDate *) startDateOfMonth;
@end
