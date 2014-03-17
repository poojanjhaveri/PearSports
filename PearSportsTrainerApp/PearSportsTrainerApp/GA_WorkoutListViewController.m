//
//  GA_WorkoutListViewController.m
//  PearSportsTrainerApp
//
//  Created by Garima Aggarwal on 3/11/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "GA_WorkoutListViewController.h"
#import "GA_PersonalizeViewController.h"
#import "GA_Workout.h"

@interface GA_WorkoutListViewController ()

@end

@implementation GA_WorkoutListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    
    [self addWorkout:@"Run"];
    [self addWorkout:@"Power Walk"];
    [self addWorkout:@"Bike"];
    [self addWorkout:@"Treadmill"];
    [self addWorkout:@"Stretch/Yoga"];
    [self addWorkout:@"Water Fitness"];
    [self addWorkout:@"Core and Strength"];

}

-(void) addWorkout: (NSString*) name
{
    GA_Workout *wname = [[GA_Workout alloc] init];
    wname.workoutName = name;
    [self.workoutList addObject:wname];
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


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"showWorkoutDetail"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        GA_PersonalizeViewController *destViewController = segue.destinationViewController;
        
        GA_Workout *w = [self.workoutList objectAtIndex:indexPath.row];
        destViewController.wName = w.workoutName;
        
    }
}



@end
