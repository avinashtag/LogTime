//
//  NSObject+ATObject.m
//  PQAApp
//
//  Created by Avinash Tag on 25/05/16.
//  Copyright © 2016 Rohde & Schwarz. All rights reserved.
//

#import "NSObject+ATObject.h"

@implementation NSObject (ATObject)


- (dispatch_source_t ) createGCDTimer:(NSTimeInterval )fireTime queue:(dispatch_queue_t )queue eventHandler:(void (^)())eventHandle{
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1* NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, eventHandle);
    return timer;
}


- (dispatch_source_t ) createGCDTimerOneShot:(NSTimeInterval )fireTime queue:(dispatch_queue_t )queue eventHandler:(void (^)())eventHandle{
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, fireTime* NSEC_PER_SEC), DISPATCH_TIME_FOREVER, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, eventHandle);
    return timer;
}
@end
