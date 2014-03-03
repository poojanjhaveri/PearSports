//
//  GA_WorkoutListTableViewController.m
//  PearSportsTrainerApp
//
//  Created by Garima Aggarwal on 2/26/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "GA_WorkoutListTableViewController.h"

@interface GA_WorkoutListTableViewController ()

@end

@implementation GA_WorkoutListTableViewController


@synthesize workoutList = _workoutList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        self.workoutList = [[NSMutableArray alloc] init];
        
        
//        WorkoutName *wname = [[WorkoutName alloc] initWithName:@"Running"];
//        GA_Workout *wname = [[GA_Workout alloc] init];
//        [wname setName:@"Garima"];
//        [self.workoutList addObject:wname];
//        
//        NSLog(@"Works");
//        
//        [self.tableView reloadData];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.workoutList = [[NSMutableArray alloc] init];

    GA_Workout *wname = [[GA_Workout alloc] init];
    [wname setName:@"Garima"];

    if(self.workoutList){
        [self.workoutList addObject:wname];
    }
    else{
        self.workoutList = [NSMutableArray arrayWithObjects:wname, nil];
    }
//    [self.workoutList addObject:wname];
  

    
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
    NSLog(@"Number of Workoutrows to show... %d", [self.workoutList count]);
    
    return [self.workoutList count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WorkoutCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    GA_Workout *wname = [GA_Workout alloc];
    wname = [(self.workoutList)objectAtIndex:indexPath.row];
    cell.textLabel.text = [wname workoutName];
    
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
