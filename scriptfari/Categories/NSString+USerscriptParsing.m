//
//  NSString+USerscriptParsing.m
//  scriptfari
//
//  Created by Moshe Berman on 8/4/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import "NSString+USerscriptParsing.h"

@implementation NSString (NSString_USerscriptParsing)

//
//  Check if a given line contains a keyword
//


- (BOOL) containsKeyWord:(NSString *)keyword{
    
    return [self containsValue:[NSString stringWithFormat:@"@%@", keyword]];
    
}

//
//  Check if a given line contains a substring string
//

- (BOOL) containsValue:(NSString *)value{
    if ([self rangeOfString:value].location != NSNotFound) {
        return YES;
    }
    return NO;
}

//
//  Read the value from a given keyword
//

- (NSString *)valueForUserscriptKeyword:(NSString *)keyword{
    
    //
    //  Add the @ symbol to the beginning of the given string
    //
    
    NSString *keyWordWithAtSymbol = [NSString stringWithFormat:@"@%@", keyword];
    
    //
    //  Get the range of the string
    //
    
    NSRange range = NSMakeRange(0, [self rangeOfString:keyWordWithAtSymbol].location+[self rangeOfString:keyWordWithAtSymbol].length);
    
    //
    //  Return the value without the key
    //
    
    return [[[self stringByReplacingCharactersInRange:range withString:@""]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
}

@end
