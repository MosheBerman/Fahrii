//
//  NSString+USerscriptParsing.h
//  scriptfari
//
//  Created by Moshe Berman on 8/4/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_USerscriptParsing)

//
//  Check if a given line contains a keyword
//

- (BOOL) containsKeyWord:(NSString *)keyword;

//
//  Check if a given line contains a substring string
//

- (BOOL) containsValue:(NSString *)value;

//
//  Read the value from a given keyword
//

- (NSString *)valueForUserscriptKeyword:(NSString *)keyword;


@end
