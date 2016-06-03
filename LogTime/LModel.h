//
//  LModel.h
//  LogTime
//
//  Created by Avinash Tag on 02/06/16.
//  Copyright © 2016 ZooZoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LModel : NSObject
@property ( nonatomic, assign) NSTimeInterval breakTime;
@property ( nonatomic, assign) NSTimeInterval logTime;
@property ( nonatomic, assign) NSTimeInterval remainingTime;
@property ( nonatomic, retain) NSDate *stamp;
@property ( nonatomic, retain) NSDate *logout;

@end
