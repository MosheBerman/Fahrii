//
//  UIBrowser.h
//  scriptfari
//
//  Created by Moshe Berman on 8/4/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import "Userscript.h"
#import "ExecutionRule.h"

@interface UIBrowserViewController : UIViewController <UIWebViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>{
    
}

@property (nonatomic, retain) IBOutlet UIWebView *browser;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) IBOutlet UITextField *addressBar;
@property (nonatomic, retain) NSURL *workingURL;

//
//  Take the contents of the address bar and load that URL if possible
//

-(void)loadWebPageFromAddressBar;

//
//  Ask the user if they want to install a script
//

- (void) promptUserToInstallScript;

//
//  Install a given userscript
//
//  It is assumed that the script will 
//  be based on the entered URL.
//

- (void) installUserScript;

//
//  Parse out a userscript
//

-(NSMutableDictionary *)parseUserscriptString:(NSString *)script;

//
//  Run applicable userscripts
//

- (void) runApplicableUserscripts;

//
//  Go Forward/Back
//


- (IBAction)goBack:(id)sender;
- (IBAction)goForward:(id)sender;

//
//  Create a UUID
//

- (NSString *)UUIDAsAnNSString;

@end
