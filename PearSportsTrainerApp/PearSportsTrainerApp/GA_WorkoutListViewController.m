//
//  GA_WorkoutListViewController.m
//  PearSportsTrainerApp
//
//  Created by Garima Aggarwal on 3/11/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "GA_WorkoutListViewController.h"
#import "GA_PersonalizeWorkout.h"
#import "GA_PersonalizePlan.h"
#import "GA_Workout.h"

@interface GA_WorkoutListViewController ()

@end

@implementation GA_WorkoutListViewController

@synthesize wDate = _wDate;

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
    self.planList = [[NSMutableArray alloc] init];

    
    NSString * token = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser" ] valueForKey:@"token"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSURLCredential *credential = [NSURLCredential credentialWithUser:token password:@"" persistence:NSURLCredentialPersistenceNone];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:token password:@""];
    
    
    NSString *urlstring = [NSString stringWithFormat:@"https://cs477-backend.herokuapp.com/sku_list"];
    
    NSMutableURLRequest *reqst = [manager.requestSerializer requestWithMethod:@"GET" URLString:urlstring parameters:nil error:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:reqst];
    [operation setCredential:credential];
    [operation setResponseSerializer:[AFJSONResponseSerializer alloc]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success of workout list: %@", responseObject);
        
        NSDictionary *jsonDict = (NSDictionary *) responseObject;

        NSMutableArray *list = [[NSMutableArray alloc] init];
        list = [jsonDict objectForKey:@"sku_list"];
        
        [list enumerateObjectsUsingBlock:^(id obj,NSUInteger idx, BOOL *stop){
           
            GA_Workout *w = [GA_Workout alloc];
            w.workoutName = [obj objectForKey:@"title"];
            w.SKU = [obj objectForKey:@"sku"];
            w.longDes = [obj objectForKey:@"description_short"];
            w.totalWeeks = [obj objectForKey:@"total_weeks"];
            w.perWeek = [obj objectForKey:@"per_week"];
            
            NSString *sku_type = [obj objectForKey:@"sku_type"];
            
            if([sku_type isEqualToString:[NSString stringWithFormat:@"workout"]]){
                [self.workoutList addObject:w];
            }
            else{
                [self.planList addObject:w];
            }
            
        }];
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
        
        [self showLoadingError];
    }];
    
    [manager.operationQueue addOperation:operation];
 
}


-(void) showLoadingError
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error retrieving the data." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert setTag:12];
    [alert show];
}


-(void) addWorkout: (NSString*) name :(NSString*) SKU
{
    GA_Workout *wname = [[GA_Workout alloc] init];
    wname.workoutName = name;
    wname.SKU = SKU;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if(section == 0){
        return [self.workoutList count];
    }
    else{
        return [self.planList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WorkoutCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(indexPath.section == 0){
        GA_Workout *wname = [GA_Workout alloc];
        wname = [(self.workoutList)objectAtIndex:indexPath.row];
        cell.textLabel.text = [wname workoutName];
    }
    else{
        GA_Workout *wname = [GA_Workout alloc];
        wname = [(self.planList)objectAtIndex:indexPath.row];
        cell.textLabel.text = [wname workoutName];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header;
    if(section == 0){
        header = [NSString stringWithFormat:@"Workout List"];
    }
    else{
        header = [NSString stringWithFormat:@"Plan List"];
    }
    
    return  header;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0){
        [self performSegueWithIdentifier:@"showWorkoutDetail" sender:self];
        NSLog(@"Workout Selected");
    }
    else if(indexPath.section == 1){
        [self performSegueWithIdentifier:@"showPlanDetail" sender:self];
        NSLog(@"Plan Selected");
    }
    
    
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
        GA_PersonalizeWorkout *destViewController = segue.destinationViewController;
        
        GA_Workout *w = [self.workoutList objectAtIndex:indexPath.row];
        destViewController.wName = w.workoutName;
        destViewController.wDate = _wDate;
        destViewController.wSKU = w.SKU;
        destViewController.notes = w.longDes;
        
    }
    else if([segue.identifier isEqualToString:@"showPlanDetail"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        GA_PersonalizePlan *destViewController = segue.destinationViewController;
        
        GA_Workout *w = [self.planList objectAtIndex:indexPath.row];
        destViewController.wName = w.workoutName;
        destViewController.wDate = _wDate;
        destViewController.wSKU = w.SKU;
        
    }
}



@end
