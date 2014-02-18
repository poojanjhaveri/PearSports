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

- (void) viewWillAppear:(BOOL)animated
{
    
    if ([[[PJ_ClientStore sharedClientStore] clients] count] == 0) {
        NSLog(@"About to add some random clients");
        [[PJ_ClientStore sharedClientStore] addRandomClients];
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    
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
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    NSLog(@"Number of rows to show... %d", [[[PJ_ClientStore sharedClientStore] clients] count]);
    return [[[PJ_ClientStore sharedClientStore] clients] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    int myIndex = [indexPath row];
    
    PJ_Client * myClient = [[[PJ_ClientStore sharedClientStore] clients] objectAtIndex:myIndex];
    
    /* Name Label  = Tag 212 */
    
    UILabel *label;
    
    label = (UILabel *)[cell viewWithTag:212];
    
    // Load dynamic content
    label.text = myClient.name;
    
    /* Notification Label  = Tag 213 */

    CGRect positionFrame = CGRectMake(247,20,20,20);
    PJ_NotificationView * noteView = [[PJ_NotificationView alloc] initWithFrame:positionFrame];
    [cell.contentView addSubview:noteView];
    //[cell.contentView sendSubviewToBack:noteView];
    
    UILabel *noteLabel;
    
    noteLabel = (UILabel *)[cell viewWithTag:213];
    noteLabel.textColor = [UIColor whiteColor];
    
    // Load dynamic content
    noteLabel.text = [NSString stringWithFormat:@"%d", myClient.numNotifications];
    [cell.contentView bringSubviewToFront:noteLabel];

    
    /* Client Details View Controller = Tag 214 */
    
    
    UIView * clientDetailsView = (UIView *)[cell viewWithTag:214];
    
    [clientDetailsView setBackgroundColor:[UIColor redColor]];
    
    
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
