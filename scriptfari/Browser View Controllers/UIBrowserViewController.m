//
//  UIBrowser.m
//  scriptfari
//
//  Created by Moshe Berman on 8/4/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import "UIBrowserViewController.h"
#import "scriptfariAppDelegate.h"

#define kMagicNumberFortyFour 44.0
#define kMagicNumberTen 10.0

@implementation UIBrowserViewController

@synthesize browser;
@synthesize navBar;
@synthesize addressBar;
@synthesize workingURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.

    //
    //  Configure a text field to use
    //
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height-kMagicNumberTen)];
    
    textField.enablesReturnKeyAutomatically = YES;
    
    [textField setReturnKeyType:UIReturnKeyGo];
    
    [textField release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc{
    [workingURL release];
    [navBar release];    
    [addressBar release];
    [browser release];
    [super dealloc];
}

#pragma mark - Web View delegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //
    //  Load up userscripts over here...
    //
    
    

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    //
    //  Load up the webpage
    //
    //  This method is also where we check for scripts or incomplete URLs
    //
    
    [self loadWebPageFromAddressBar];
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{

    return YES;
}


#pragma mark - Load URL from address bar

//
//  This method uses code based on this StackOverflow answer:
//
// http://stackoverflow.com/questions/1471201/how-to-validate-an-url-on-the-iphone/5081447#5081447 
//


-(void)loadWebPageFromAddressBar{
 
    NSURL *candidateURL = [NSURL URLWithString:self.addressBar.text];
    
    //
    //  Add HTTP to the beginning of URLs that are missing it
    //
    
    if (!candidateURL.scheme) {
        candidateURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", self.addressBar.text]];
    }
    

    if (candidateURL && candidateURL.scheme && candidateURL.host) {
        
        //
        //
        // candidate is a well-formed url with:
        //  - a scheme (like http://)
        //  - a host (like stackoverflow.com)
        //
        //  Store the "working URL".
        //
        
        self.workingURL = candidateURL;
        
        //
        //  Check if we're installing a userscript
        //
        

        if ([candidateURL.pathExtension isEqualToString:@"js"] && [[candidateURL URLByDeletingPathExtension].pathExtension isEqualToString: @"user"]) {
                
                //
                //  TODO: Check for existing scripts and update if necessary
                //
                
                [self promptUserToInstallScript];
            
                //return;
        }
        
        //
        //  Load up the requested resource
        //
        
        [self.browser loadRequest:[NSURLRequest requestWithURL:candidateURL]];
    }
}

//
//  Prompt the user to see if the want to install the userscript
//

- (void) promptUserToInstallScript{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Install Script?",@"") 
                                                        message:NSLocalizedString(@"Do you want to install this userscript?", @"Prompt the user to install the userscript") 
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"No",@"") 
                                              otherButtonTitles:NSLocalizedString(@"Yes",@""), nil];
    [alertView show];
    [alertView release];
    
}

//
//  Respond to the script installation prompt
//

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex != alertView.cancelButtonIndex) {
        
        //
        //  Save and install the script
        //
        
        [self installUserScript];
        
        
    }
}


#pragma mark - Install the Userscript

- (void) installUserScript{
    
    //
    //  TODO: Parse and read out the script
    //
    
    NSError *error = nil;
    
    NSString *scriptText = [NSString stringWithContentsOfURL:self.workingURL encoding:NSUTF8StringEncoding error:&error];
    
    if (error != nil) {
        NSLog(@"Failed to open userscript for use. Returning. Error: %@", [error userInfo]);
        return;
    }else if(scriptText != nil){
        [self parseUserscriptString:scriptText];        
    }else{
        NSLog(@"Nil string... %@", [self.workingURL description]);
    }
    
    NSManagedObjectContext *context = ((scriptfariAppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    //
    //  Load ExecutionRules
    //
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"ExecutionRule" inManagedObjectContext:context]];
    
    NSArray *executionRules = [context executeFetchRequest:fetchRequest error:&error];
    
    for (ExecutionRule *rule in executionRules) {
       
        //
        //  Check if the new script contains any of these rules
        //
    }
    
    //
    //  Store metadata in a Managed Object
    //
    
    //
    //  Save
    //
    
    if (error != nil) {

        //
        //  Inform the user of an error.
        //
        
        NSLog(@"Failed load: ");
    }
    
    //
    //  Zing!
    //
    //  ...
    //
    //  Because we can.
    //
    //  But don't forget to inform users of an error
    //
    //
    
}

     //
     //
     //
     
-(NSDictionary *)parseUserscriptString:(NSString *)script{

    //
    //  Create a dictionary to store the metadata in
    //
    
    NSMutableDictionary *scriptInfo = [[[NSMutableDictionary alloc] init] autorelease];
    NSMutableArray *includes = [[NSMutableArray alloc] init];
    NSMutableArray *excludes = [[NSMutableArray alloc] init];    
    
    [script enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
        
        NSLog(@"Line: %@", line);
        
        if([line containsKeyWord:@"author"]) {
            
            //
            //  Get the author
            //
            
            NSString *author = [line valueForUserscriptKeyword:@"author"];
            
            [scriptInfo setObject:author forKey:@"Author"];
        }
        
        //
        //  Parse the namespace - We only read the first one
        //
        
        if ([line containsKeyWord:@"namespace"]) {
            
            [scriptInfo setObject:[line valueForUserscriptKeyword:@"namespace"] forKey:@"namespace"];
            
        }

        if ([line containsKeyWord:@"include"]) {
            [includes addObject:[line valueForUserscriptKeyword:@"include"]];
        }
        
        
        if ([line containsKeyWord:@"exclude"]) {
            [includes addObject:[line valueForUserscriptKeyword:@"include"]];
        }        
        
        //
        //  Stop parsing at this point, we read out the metadata
        //
        
        if ([line containsValue:@"==/UserScript=="]) {
            *stop = YES;
        }
    }];
    
    NSLog(@"Done.");
    
    [scriptInfo setObject:includes forKey:@"includes"];
    [scriptInfo setObject:excludes forKey:@"excludes"];
    
    [includes release];
    [excludes release];
    
    return [[scriptInfo copy] autorelease];
}

@end
