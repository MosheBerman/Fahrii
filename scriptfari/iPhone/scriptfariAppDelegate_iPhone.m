//
//  scriptfariAppDelegate_iPhone.m
//  scriptfari
//
//  Created by Moshe Berman on 4/6/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import "scriptfariAppDelegate_iPhone.h"
#import "UIBrowserViewControllerPhone.h"

@implementation scriptfariAppDelegate_iPhone

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    //
    //  Instantiate the browser
    //
    
    UIBrowserViewControllerPhone *browser = [[UIBrowserViewControllerPhone alloc]initWithNibName:@"UIBrowserViewControllerPhone" bundle:nil];
    self.browserViewController = browser;
    [browser release];
    
    //
    //  Add the browser to the main window
    //
    
    [self.window addSubview:self.browserViewController.view];
    
    //
    //  Ask the superview to set up and show the window
    //
    
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (void)dealloc{
	[super dealloc];
}

@end
