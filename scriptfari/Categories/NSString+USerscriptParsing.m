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
    
    return [self stringByReplacingCharactersInRange:range withString:@""];
}

//
//  Check if a given string matches a URL
//
//  TODO: Ensure that userscript validation works
//  the way it should.
//  
//  Make no assumptions about a domain.
//
//


- (BOOL) matchesURL:(NSURL *)anotherURL{

    NSURL *selfAsURL = [NSURL URLWithString:self];
    NSLog(@"Self: %@", self);
    //
    //  Wildcard
    //
    //  This should match anything.
    //
    
    if ([anotherURL isEqual:[NSURL URLWithString:@"*"]]) {
        NSLog(@"Wildcard.");
        return YES;
    }
    
    //
    //  Domain name with wildcard
    //
    //  @include http://MosheBerman.com/*
    //
    //  Should match http://MosheBerman.com/something
    //
    
    if ([selfAsURL.baseURL isEqual:anotherURL] && [[anotherURL.baseURL URLByAppendingPathComponent:@"*"] isEqual:anotherURL]) {
        NSLog(@"Same base URL.");
        return YES;
    }    
    
    //
    //  If the URLS are identical, they match
    //
    
    if ([selfAsURL isEqual:anotherURL]) {
        NSLog(@"Identical.");
        return YES;
    }
    
    //
    //  TODO: Compare subdomains...
    //
    

    return NO;
}

@end
