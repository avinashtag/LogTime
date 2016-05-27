//
//  NSArray+ZArray.h
//  LogTime
//
//  Created by Avinash Tag on 27/05/16.
//  Copyright © 2016 ZooZoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ZArray)
- (void)splitArray:(void(^)(NSArray *odds, NSArray* evens))completion;
@end
