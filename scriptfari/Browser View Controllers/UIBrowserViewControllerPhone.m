//
//  UIBrowserViewControllerPhone.m
//  scriptfari
//
//  Created by Moshe Berman on 8/4/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import "UIBrowserViewControllerPhone.h"
#import "UIScriptManagerViewController.h"

@implementation UIBrowserViewControllerPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navBar setFrame:CGRectMake(0, 0, self.navBar.frame.size.width, self.navBar.frame.size.height)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"View will appear.");
    
    [self.navBar setFrame:CGRectMake(0, 0, self.navBar.frame.size.width, self.navBar.frame.size.height)];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//
//  Create a script manager and then show it
//


- (IBAction)showScriptManager:(id)sender{
    
    UIScriptManagerViewController *scriptManager = [[UIScriptManagerViewController alloc] initWithStyle:UITableViewStylePlain];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:scriptManager];
    
    [scriptManager release];
    
    [self presentModalViewController:navController animated:YES];
    
    [navController release];
}

@end
