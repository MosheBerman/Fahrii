//
//  Userscript.h
//  scriptfari
//
//  Created by Moshe Berman on 8/4/11.
//  Copyright (c) 2011 MosheBerman.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Userscript : NSManagedObject

@property (nonatomic, retain) NSNumber * includeEverywhere;
@property (nonatomic, retain) NSString * namespaceOfScript;
@property (nonatomic, retain) NSString * pathToScript;
@property (nonatomic, retain) NSString * scriptAuthor;
@property (nonatomic, retain) NSString * scriptDescription;
@property (nonatomic, retain) NSString * scriptIconPath;
@property (nonatomic, retain) NSDate *scriptInstallDate;
@property (nonatomic, retain) NSString * scriptName;

@property (nonatomic, retain) NSNumber *scriptVersion;
@property (nonatomic, retain) NSSet *includeAndExcludes;

@end

@interface Userscript (CoreDataGeneratedAccessors)

- (void)addIncludeAndExcludesObject:(NSManagedObject *)value;
- (void)removeIncludeAndExcludesObject:(NSManagedObject *)value;
- (void)addIncludeAndExcludes:(NSSet *)values;
- (void)removeIncludeAndExcludes:(NSSet *)values;

@end
