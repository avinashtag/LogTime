//
//  NSString+TString.m
//  PQAApp
//
//  Created by Avinash Tag on 18/12/15.
//  Copyright © 2015 Rohde & Schwarz. All rights reserved.
//

#import "NSString+TString.h"

@implementation NSString (TString)


- (BOOL) isBlank{
    
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}



NSString * randomString(int digit){
    
    NSMutableString *randString  = [[NSMutableString alloc]initWithCapacity:digit];
    while (randString.length<digit) {
        [randString appendString:[NSString stringWithFormat:@"%d",arc4random_uniform(9)+0]];
    }
    return randString;
}

//- (NSArray *) componentSepratedBy:(NSString *)sepration objectAtIndexes:(NSArray <NSNumber *>*)indexes{
//    
//    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc]init];
//    [indexes enumerateObjectsUsingBlock:^(NSNumber * index, NSUInteger idx, BOOL * _Nonnull stop) {
//       
//        [indexSet addIndex:[index integerValue]];
//    }];
//    NSArray *objects = [self componentsSeparatedByString:sepration];
//    @try {
//        if (objects.count) {
//            return [objects objectsAtIndexes:indexSet];
//        }
//    }
//    @catch (NSException *exception) {
//        return nil;
//    }
//    return nil;
//}


- (NSDictionary *) dictionarySepratedByString:(NSString *)sepration keys:(NSDictionary *)keys{
    
    NSArray *objects = [self componentsSeparatedByString:sepration];
    return [self buildDictionaryWithKeys:keys objects:objects];
}

- (NSDictionary *) dictionarySepratedByStrings:(NSArray <NSString *>*)seprations keys:(NSDictionary *)keys{
    
    __block NSArray *objects ;
    [seprations enumerateObjectsUsingBlock:^(NSString * sepration, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) {
            objects = [self componentsSeparatedByString:sepration];
        }
        else if(objects.count){
            __block NSMutableArray *temp = [[NSMutableArray alloc] init];
            [objects enumerateObjectsUsingBlock:^(NSString * object, NSUInteger idx, BOOL * _Nonnull stop) {
                [temp addObjectsFromArray:[object componentsSeparatedByString:sepration]];
            }];
            objects = [NSArray arrayWithArray:temp ];
        }
    }];
    return keys.allKeys.count ? [self buildDictionaryWithKeys:keys objects:objects] : [self buildDictionaryWithObjects:objects];
}

- (NSDictionary *) dictionarySepratedByStrings:(NSArray <NSString *>*)seprations{
    
    return [self dictionarySepratedByStrings:seprations keys:nil];
}


#pragma mark - Supporting methods

- (NSDictionary *) buildDictionaryWithKeys:(NSDictionary *)keys objects:(NSArray *)objects{
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    [keys enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  _Nonnull value, BOOL * _Nonnull stop) {
        
        NSUInteger index = [objects indexOfObject:key];
        if (index!= NSNotFound) {
            if (objects.count > index+1) {
                [result setValue:objects[index+1] forKey:key];
            }
            else{
                [result setValue:@1 forKey:key];
                NSLog(@"Value for key <%@> not found.",key);
            }
        }
        else{
            NSLog(@"Key <%@> not found.",key);
        }
    }];
    return result;

}

- (NSDictionary *) buildDictionaryWithObjects:(NSArray *)objects{
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    @try {
        int i = 0;
        while (i < objects.count) {
            [result setValue:objects[i+1] forKey:objects[i]];
            i += 2;
        }
    }
    @catch (NSException *exception) {
        [result setValue:self forKey:self];
    }
    return result;
}

- (BOOL) compareIncesetive:(NSString *)nextString{
    return [self caseInsensitiveCompare:nextString] == NSOrderedSame;
}

- (NSDate *) dateInFormat:(NSString*)format{
    
    NSDateFormatter *formator = [[NSDateFormatter alloc]init];
    [formator setDateFormat:format];
    return [formator dateFromString:self];
}

@end
