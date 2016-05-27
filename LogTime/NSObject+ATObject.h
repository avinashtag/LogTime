//
//  NSObject+ATObject.h
//  PQAApp
//
//  Created by Avinash Tag on 25/05/16.
//  Copyright © 2016 Rohde & Schwarz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ATObject)


- (dispatch_source_t ) createGCDTimer:(NSTimeInterval )fireTime queue:(dispatch_queue_t )queue eventHandler:(void (^)())eventHandle;
- (dispatch_source_t ) createGCDTimerOneShot:(NSTimeInterval )fireTime queue:(dispatch_queue_t )queue eventHandler:(void (^)())eventHandle;

@end
