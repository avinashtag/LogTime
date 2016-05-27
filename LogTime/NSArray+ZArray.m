//
//  NSArray+ZArray.m
//  LogTime
//
//  Created by Avinash Tag on 27/05/16.
//  Copyright © 2016 ZooZoo. All rights reserved.
//

#import "NSArray+ZArray.h"

@implementation NSArray (ZArray)

- (void)splitArray:(void(^)(NSArray *odds, NSArray* evens))completion {
    
    __block NSMutableArray *evens = [[NSMutableArray alloc]init];
    __block NSMutableArray *odds = [[NSMutableArray alloc]init];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        if (index % 2 == 0) {
            // even stuff here
            [evens addObject:obj];
        } else {
            // odd stuff here
            [odds addObject:obj];
        }
    }];
    completion? completion(odds, evens):nil;
}
@end
