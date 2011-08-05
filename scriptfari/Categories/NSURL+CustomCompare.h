//
//  NSURL+CustomCompare.h
//  scriptfari
//
//  Created by Moshe Berman on 8/5/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (NSURL_CustomCompare)


//
//  Check if a given string matches a URL
//
//  TODO: Ensure that userscript validation works
//  the way it should.
//  
//  Make no assumptions about a domain.
//
//


- (BOOL) matchesURL:(NSURL *)anotherURL;
    
@end
