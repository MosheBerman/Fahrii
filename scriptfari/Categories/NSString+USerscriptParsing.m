//
//  NSString+USerscriptParsing.m
//  scriptfari
//
//  Created by Moshe Berman on 8/4/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import "NSString+USerscriptParsing.h"

@implementation NSString (NSString_USerscriptParsing)

- (NSString *)valueForUserscriptKeyword:(NSString *)keyword{
    
    NSString *keyWordWithAtSymbol = [NSString stringWithFormat:@"@%@", keyword];
    return [self stringByReplacingCharactersInRange:NSMakeRange(0, [self rangeOfString:keyWordWithAtSymbol].location+[self rangeOfString:keyWordWithAtSymbol].length) withString:@""];
}


- (BOOL) containsKeyWord:(NSString *)keyword{

    return [self containsValue:[NSString stringWithFormat:@"@%@", keyword]];

}

- (BOOL) containsValue:(NSString *)value{
    if ([self rangeOfString:value].location != NSNotFound) {
        return YES;
    }
    return NO;
}

@end
