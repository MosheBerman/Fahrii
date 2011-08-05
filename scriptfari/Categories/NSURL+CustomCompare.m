//
//  NSURL+CustomCompare.m
//  scriptfari
//
//  Created by Moshe Berman on 8/5/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import "NSURL+CustomCompare.h"

@implementation NSURL (NSURL_CustomCompare)


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
    
    self = [self URLByAppendingPathComponent:@""];
    anotherURL = [anotherURL URLByStandardizingPath];
    
    NSLog(@"Self: %@, Other: %@", [self description], [anotherURL description]);
    
    //
    //  If the URLS are identical, they match
    //
    
    if ([self isEqual:anotherURL]) {
        NSLog(@"Identical.");
        return YES;
    }
    
    //
    //  Domain name with wildcard
    //
    //  @include http://MosheBerman.com/*
    //
    //  Should match http://MosheBerman.com/something
    //
    
    if ([self.baseURL isEqual:anotherURL] && [[anotherURL.baseURL URLByAppendingPathComponent:@"*"] isEqual:anotherURL]) {
        NSLog(@"Same base URL.");
        return YES;
    }    
    
    //
    //  Wildcard
    //
    //  This should match anything.
    //
    
    if ([self isEqual:[NSURL URLWithString:@"*"]]) {
        NSLog(@"Wildcard.");
        return YES;
    }
    
    //
    //  TODO: Compare subdomains...
    //
    
    
    return NO;
}


@end
