//
//  NSDate+ZDate.m
//  PQAApp
//
//  Created by Avinash Tag on 28/01/16.
//  Copyright © 2016 Rohde & Schwarz. All rights reserved.
//

#import "NSDate+ZDate.h"

@implementation NSDate (ZDate)


- (NSString *) dateStringInFormat:(NSString*)format{
    
    NSDateFormatter *formator = [[NSDateFormatter alloc]init];
    [formator setDateFormat:format];
    return [formator stringFromDate:self];
}
@end
