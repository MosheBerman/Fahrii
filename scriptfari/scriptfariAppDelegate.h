//
//  scriptfariAppDelegate.h
//  scriptfari
//
//  Created by Moshe Berman on 4/6/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "UIBrowserViewController.h"

@interface scriptfariAppDelegate : NSObject <UIApplicationDelegate> {

}
@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) UIBrowserViewController *browserViewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
