//
//  UIScriptManagerViewController.m
//  scriptfari
//
//  Created by Moshe Berman on 8/4/11.
//  Copyright 2011 MosheBerman.com. All rights reserved.
//

#import "UIScriptManagerViewController.h"
#import "scriptfariAppDelegate.h"

@implementation UIScriptManagerViewController

@synthesize fetchedResultsController;
@synthesize scriptCell;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

-(void)dealloc{
    fetchedResultsController.delegate = nil;
    [fetchedResultsController release];
    [scriptCell release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self.parentViewController action:@selector(dismissModalViewControllerAnimated:)] autorelease];
    
    //
    //  Resize the row height
    //
    
    self.tableView.rowHeight = 90.0;
    
    //
    //  Run the query to load up the groups
    //
    
    NSError *error = nil;
    
    [self.fetchedResultsController performFetch:&error];
    
    if (error != nil) {
        
        //
        //  TODO: Inform the user that there was a problem.
        //
        
        NSString *errorString = [NSString stringWithFormat: @"There was an error findinding existing groups. %@", [error localizedDescription]];
        
       NSLog(@"Could not load scripts. %@", errorString);
        
    }
  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

//
//
//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [[self.fetchedResultsController sections] count];
}

//
//
//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    NSLog(@"Rows: %i", [sectionInfo numberOfObjects]);
    
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        [[NSBundle mainBundle] loadNibNamed:@"ScriptCellPhone" owner:self options:nil];
        
        cell = scriptCell;
        self.scriptCell = nil;
        
    }
    
    [((UILabel *)[cell viewWithTag:5]) setText:((Userscript *)[fetchedResultsController objectAtIndexPath:indexPath]).scriptName];
    
    [((UILabel *)[cell viewWithTag:6]) setText:((Userscript *)[fetchedResultsController objectAtIndexPath:indexPath]).scriptDescription];
    
    if ([((Userscript *)[fetchedResultsController objectAtIndexPath:indexPath]).scriptDescription isEqualToString:@""]) {
        [((UILabel *)[cell viewWithTag:6]) setText:@"No description is available."];
    }
    
    [((UILabel *)[cell viewWithTag:7]) setText:[((Userscript *)[fetchedResultsController objectAtIndexPath:indexPath]).scriptVersion description]];    
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (NSFetchedResultsController *)fetchedResultsController{
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
  
    //
    //  Reference the MOC
    //
    
    scriptfariAppDelegate *delegate = ((scriptfariAppDelegate *)[[UIApplication sharedApplication] delegate]);
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    //
    //  Set up a fetch request
    //
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Userscript" inManagedObjectContext:context]];
    
    //
    //
    //
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"scriptName" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    [sortDescriptors release];
    [sortDescriptor release];
    
    //
    //  Instantiate the fetched results controller
    //
    
    NSFetchedResultsController *tempFetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];

    
    
    [fetchRequest release];
 
    
    
    tempFetchedResultsController.delegate = self;
    self.fetchedResultsController = tempFetchedResultsController;
    
    [tempFetchedResultsController release];
    
    return fetchedResultsController;
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView reloadData];
}
@end
