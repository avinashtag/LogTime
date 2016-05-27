//
//  NSString+TString.h
//  PQAApp
//
//  Created by Avinash Tag on 18/12/15.
//  Copyright © 2015 Rohde & Schwarz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TString)

@property (nonatomic , assign, readonly) BOOL isBlank;

//******* Return SHA256 random string having n digits *******//
NSString * randomString(int digit);
//- (NSArray *) componentSepratedBy:(NSString *)sepration objectAtIndexes:(NSArray <NSNumber *>*)indexes;
- (NSDictionary *) dictionarySepratedByString:(NSString *)sepration keys:(NSDictionary *)keys;
- (NSDictionary *) dictionarySepratedByStrings:(NSArray <NSString *>*)seprations keys:(NSDictionary *)keys;
- (NSDictionary *) dictionarySepratedByStrings:(NSArray <NSString *>*)seprations;
- (BOOL) compareIncesetive:(NSString *)nextString;

- (NSDate *) dateInFormat:(NSString*)format;
- (BOOL) isBlank;
@end
