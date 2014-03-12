//
//  PJ_ClientListViewController.m
//  PearSportsTrainerApp
//
//  Created by Poojan Jhaveri on 2/4/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "PJ_ClientListViewController.h"
#import "PJ_NotificationView.h"
#import "PJ_Client.h"
#import "PJ_ClientStore.h"
#import "PJ_ClientCell.h"
#import "API.h"

@interface PJ_ClientListViewController ()

@end

@implementation PJ_ClientListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        
        // Custom initialization
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [[PJ_ClientStore sharedClientStore] updateDataAndPerformSelector:@selector(refreshView) withTarget:self];
        
    }
    return self;
    
}

- (void) viewWillAppear:(BOOL)animated
{
    
    // Have some flag regarding a need for refresh
    if (false) {
        
        [[PJ_ClientStore sharedClientStore] updateDataAndPerformSelector:@selector(refreshView) withTarget:self];
        
    }
    
    
}

- (void) refreshRequested:(UIRefreshControl *)sender
{
    
    [[PJ_ClientStore sharedClientStore] updateDataAndPerformSelector:@selector(refreshViewAndRemoveRefreshIcon) withTarget:self];
    
}

- (void) refreshView
{

    [self.tableView reloadData];
    [self.tableView setNeedsDisplay];
    
}

- (void) refreshViewAndRemoveRefreshIcon
{
    [self refreshView];
    [self.refreshController endRefreshing];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.refreshController addTarget:self action:@selector(refreshRequested:) forControlEvents:UIControlEventValueChanged];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [[[PJ_ClientStore sharedClientStore] clients] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ClientCell";
    PJ_ClientCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    PJ_Client * myClient = [[[PJ_ClientStore sharedClientStore] clients] objectAtIndex:indexPath.row];
    
    [cell setClient:myClient];
    [cell loadClientData];
    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[API sharedInstance] saveTrainee:[[[PJ_ClientStore sharedClientStore] clients] objectAtIndex:indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
