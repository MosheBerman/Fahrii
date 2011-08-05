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
    
    //
    //  Show an alert view
    //
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //
    //  Load up userscripts over here...
    //
    
    [self runApplicableUserscripts];

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

//
//  Parse and read out the script, then save it.
//

- (void) installUserScript{

    NSError *error = nil;

    //
    //  TODO: detect correct encoding
    //
    
    NSString *scriptText = [NSString stringWithContentsOfURL:self.workingURL encoding:NSUTF8StringEncoding error:&error];
    
    //
    //  Check for an error. If the string loaded, parse the script
    //
    
    NSMutableDictionary *scriptInfo = [[[NSMutableDictionary alloc] init] autorelease];
    
    if (error != nil) {
        
        //
        //  TODO: Inform the user...
        //
        
        NSLog(@"Failed to open userscript for use. Returning. Error: %@", [error userInfo]);
        return;
    }else if(scriptText != nil){
        scriptInfo = [self parseUserscriptString:scriptText];        
    }
    
    //
    //  If there's no script info, we can't save the script
    //
    
    if (scriptInfo == nil) {
        NSLog(@"Could not parse script info");
        return;
    }
    
    //
    //  Grab a reference to the App Delegate's managed object context
    //
    
    scriptfariAppDelegate *delegate = ((scriptfariAppDelegate *)[[UIApplication sharedApplication] delegate]);
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    //
    //  If there is no user supplied name, 
    //  use the filename as the script name.
    //
    
    if ([scriptInfo objectForKey:@"name"] == nil) {
        
        NSString *defaultName = [[[self.workingURL URLByDeletingPathExtension] URLByDeletingPathExtension] lastPathComponent];
        
        [scriptInfo setObject:defaultName forKey:@"name"];
    }    
    
    //
    //  Use the current base URL as the namespace,
    //  if there is no user supplied value
    //
    
    if ([scriptInfo objectForKey:@"namespace"] == nil) {
        [scriptInfo setObject:[self.workingURL baseURL] forKey:@"namespace"];
    }
    
    //
    //  If there's no description, set an empty one
    //
    
    if ([scriptInfo objectForKey:@"description"] == nil) {
        [scriptInfo setObject:@"" forKey:@"description"];
    }
    
    
    
    //
    //  Create a script managed object
    //
    
    Userscript *newScript = [[Userscript alloc] initWithEntity:[NSEntityDescription entityForName:@"Userscript" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
    
    //
    //  Save out the basic information that we can
    //
    
    [newScript setScriptAuthor:[scriptInfo valueForKey:@"author"]];
    [newScript setScriptDescription:[scriptInfo valueForKey:@"description"]];
    //  TODO: Handle saving of icon
    [newScript setScriptIconPath:@""];
    [newScript setScriptInstallDate:[NSDate date]];
    [newScript setScriptName:[scriptInfo valueForKey:@"name"]];
    [newScript setNamespaceOfScript:[scriptInfo valueForKey:@"namespace"]];
    [newScript setScriptVersion:[scriptInfo objectForKey:@"version"]];
    
    //This defaults to "no", but we will change it later if necessary
    [newScript setIncludeEverywhere:[NSNumber numberWithBool:NO]];    
    
    //
    //  Load existing ExecutionRules
    //
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"ExecutionRule" inManagedObjectContext:context]];
    
    NSArray *executionRules = [context executeFetchRequest:fetchRequest error:&error];
    
    [fetchRequest release];
    
    //
    //  Filter duplicate include/exclude directives
    //
    
    NSSet *includeRules = [NSSet setWithArray:[scriptInfo objectForKey:@"includes"]];
    NSSet *excludeRules = [NSSet setWithArray:[scriptInfo objectForKey:@"excludes"]];
    
    //
    //  Set up the includes
    //
    
    for (NSString *URLForRule in includeRules) {
        
        //
        //  Create a flag to check if the rule exists
        //
        
        BOOL ruleExists = NO;
        
        if ([URLForRule isEqualToString:@"*"]) {
            [newScript setIncludeEverywhere:[NSNumber numberWithBool:YES]];
        }
        for (ExecutionRule *rule in executionRules) {
            if ([rule.RuleType boolValue] == YES && [rule.URLString isEqualToString:URLForRule]) {
                
                //
                //  We found a matching rule that exists
                //
                
                ruleExists = YES;

                //
                //
                //
                
                [newScript addIncludeAndExcludesObject:rule];
            }
        }
        
        //
        //  Create new Rule
        //
        
        if (!ruleExists) {
            
            NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"ExecutionRule" inManagedObjectContext:context];
            
            ExecutionRule *tempRule = [[ExecutionRule alloc]initWithEntity:entityDesc insertIntoManagedObjectContext:context];
            
            [tempRule setRuleType:[NSNumber numberWithBool:YES]];
            [tempRule setURLString:URLForRule];
            
            [newScript addIncludeAndExcludesObject:tempRule];
            
            [tempRule release];
            
        }
    }
    
    //
    //  Set up the includes
    //
    
    for (NSString *URLForRule in excludeRules) {
        
        //
        //  Create a flag to check if the rule exists
        //
        
        BOOL ruleExists = NO;
        
        for (ExecutionRule *rule in executionRules) {
            if ([rule.RuleType boolValue] == NO && [rule.URLString isEqualToString:URLForRule]) {
                
                //
                //  We found a matching rule that exists
                //
                
                ruleExists = YES;
                
                //
                //
                //
                
                [newScript addIncludeAndExcludesObject:rule];
            }
        }
        
        //
        //  Create new Rule
        //
        
        if (!ruleExists) {
            
            NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"ExecutionRule" inManagedObjectContext:context];
            
            ExecutionRule *tempRule = [[ExecutionRule alloc]initWithEntity:entityDesc insertIntoManagedObjectContext:context];
            
            [tempRule setRuleType:[NSNumber numberWithBool:NO]];
            [tempRule setURLString:URLForRule];
            
            [newScript addIncludeAndExcludesObject:tempRule];
            
            [tempRule release];
            
        }
    }
    
    //
    //  Save the script to disc, then the metadata
    //
    
    NSString *scriptName = [self UUIDAsAnNSString];
    
    NSURL *pathToDocumentsDirectory = [delegate applicationDocumentsDirectory];
    
    NSURL *pathToSaveTo = [[pathToDocumentsDirectory URLByAppendingPathComponent:scriptName] URLByAppendingPathExtension:@"user.js"];
    [scriptText writeToURL:pathToSaveTo atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (error == nil) {
        NSLog(@"Saved userscipt as %@", pathToSaveTo);
    }else{
        NSLog(@"Could not save script as %@. Error: %@", pathToSaveTo, [error localizedDescription]);
    }
    
    //
    //  Save the path of the script so we can get at when we need to!
    //
    
    [newScript setPathToScript:[pathToSaveTo absoluteString]];
    
    [context save:&error];
    
    if (error != nil) {

        //
        //  Inform the user of an error.
        //
        
        NSLog(@"Failed save: %@", [error userInfo]);
    }
    
    [newScript release];
    
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
//  Parse a userscript for useful meta data
//
     
-(NSMutableDictionary *)parseUserscriptString:(NSString *)script{

    //
    //  Create a dictionary to store the metadata in
    //
    
    NSMutableDictionary *scriptInfo = [[[NSMutableDictionary alloc] init] autorelease];
    NSMutableArray *includes = [[NSMutableArray alloc] init];
    NSMutableArray *excludes = [[NSMutableArray alloc] init];    
    
    [script enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
        
        //NSLog(@"Line: %@", line);
        
        //
        //  Get the author, if we find it
        //
        
        if([line containsKeyWord:@"author"]){
            
            NSString *author = [line valueForUserscriptKeyword:@"author"];
            
            [scriptInfo setObject:author forKey:@"author"];
        }
        
        //
        //  Parse the namespace - We only read the first one
        //
        
        if ([line containsKeyWord:@"namespace"] && [scriptInfo objectForKey:@"namespace"] == nil) {
            [scriptInfo setObject:[line valueForUserscriptKeyword:@"namespace"] forKey:@"namespace"];   
        }
        
        //
        //  Read out the description.
        //
        
        if ([line containsKeyWord:@"description"]) {
            [scriptInfo setObject:[line valueForUserscriptKeyword:@"description"] forKey:@"description"];
        }

        if ([line containsKeyWord:@"include"]) {
            [includes addObject:[line valueForUserscriptKeyword:@"include"]];
        }
        
        
        if ([line containsKeyWord:@"exclude"]) {
            [includes addObject:[line valueForUserscriptKeyword:@"exclude"]];
        }        
        
        if ([line containsKeyWord:@"version"]) {
            [scriptInfo setObject:[NSNumber numberWithDouble:[[line valueForUserscriptKeyword:@"version"]doubleValue]]forKey:@"version"];
        }
        
        //
        //  Stop parsing at this point, we read out the metadata
        //
        
        if ([line containsValue:@"==/UserScript=="]) {
            *stop = YES;
        }
    }];
    
    NSLog(@"Done.");
    
    //
    //  Store includes and excludes in the dictionary
    //
    
    [scriptInfo setObject:includes forKey:@"includes"];
    [scriptInfo setObject:excludes forKey:@"excludes"];
    
    [includes release];
    [excludes release];
    
    return scriptInfo;
}


//
//  Run the applicable user scripts
//

- (void) runApplicableUserscripts{
    
    //
    //  Grab a reference to the App Delegate's managed object context
    //
    
    scriptfariAppDelegate *delegate = ((scriptfariAppDelegate *)[[UIApplication sharedApplication] delegate]);
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    //
    //  Get a list of all of the userscripts
    //
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Userscript" inManagedObjectContext:context]];
    
    NSError *error = nil;
    
    NSArray *scripts = [context executeFetchRequest:fetchRequest error:&error];

    NSMutableArray *candidatesForInclude = [[NSMutableArray alloc] init];
    
    //
    //  Add all scripts with applicable includes
    //
    
    for (Userscript *script in scripts) {        
        for(ExecutionRule *rule in script.includeAndExcludes){
            if ([rule.URLString matchesURL:self.workingURL] && [rule.RuleType boolValue] == YES) {
                [candidatesForInclude addObject:script]; 
            }
            
        }
    }
    
    //
    //  Check for scripts that have excludes
    //
    
    NSMutableArray *scriptsToExecute = [[NSMutableArray alloc] init];    
    
    for (Userscript *script in candidatesForInclude) {
        
        BOOL hasContradictingExclude = NO;
        
        for(ExecutionRule *rule in script.includeAndExcludes){
            if ([rule.URLString matchesURL:self.workingURL] && [rule.RuleType boolValue] == NO) {
                hasContradictingExclude = YES;
            }   
        }
        
        if (!hasContradictingExclude) {
            [scriptsToExecute addObject:script];
        }
    }
    
    [candidatesForInclude release];
    
    //
    //  Run the remaining scripts
    //
    
    for (Userscript *script in scriptsToExecute) {
        
        [self.browser stringByEvaluatingJavaScriptFromString:[NSString stringWithContentsOfURL:[NSURL URLWithString:script.pathToScript] encoding:NSUTF8StringEncoding error:&error]];
    }
    
    [scriptsToExecute release];
    [fetchRequest release];

}



#pragma mark - Utility methods

//
//  Create a UUID
//

- (NSString *)UUIDAsAnNSString{
    
    //
    //  Create a UUID and convert it to NSString
    //
    
    
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    
    //
    //  Memory management
    //
    
    [uuidString autorelease];
    CFRelease(uuid);
    
    return uuidString;
}


@end
