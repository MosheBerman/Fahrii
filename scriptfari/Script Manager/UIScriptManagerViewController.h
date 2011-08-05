//
//  UIScriptManagerViewController.h
//  scriptfari
//
//  Created by Moshe Berman on 8/4/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Userscript.h"

@interface UIScriptManagerViewController : UITableViewController <UITableViewDelegate, UITableViewDelegate, NSFetchedResultsControllerDelegate>{
    
    NSFetchedResultsController *fetchedResultsController;

    IBOutlet UITableViewCell *scriptCell;
    
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) UITableViewCell *scriptCell;

@end
