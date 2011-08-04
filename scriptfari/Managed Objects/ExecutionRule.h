//
//  ExecutionRule.h
//  scriptfari
//
//  Created by Moshe Berman on 8/4/11.
//  Copyright (c) 2011 MosheBerman.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Userscript;

@interface ExecutionRule : NSManagedObject

@property (nonatomic, retain) NSNumber * RuleType;
@property (nonatomic, retain) NSString * URLString;
@property (nonatomic, retain) NSSet *Userscript;
@end

@interface ExecutionRule (CoreDataGeneratedAccessors)

- (void)addUserscriptObject:(Userscript *)value;
- (void)removeUserscriptObject:(Userscript *)value;
- (void)addUserscript:(NSSet *)values;
- (void)removeUserscript:(NSSet *)values;

@end
