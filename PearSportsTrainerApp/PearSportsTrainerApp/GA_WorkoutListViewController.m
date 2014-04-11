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
    NSString *workout_type = [NSString stringWithFormat:@"workout"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:workout_type, nil] forKeys:[NSArray arrayWithObjects:@"type", nil]];
    
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
            
            NSString *sku_type = [obj objectForKey:@"sku_type"];
            
            if([sku_type isEqualToString:[NSString stringWithFormat:@"workout"]]){
                [self.workoutList addObject:w];
            }
            else{
                [self.planList addObject:w];
            }
//            
            
        }];
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
    }];
    
    [manager.operationQueue addOperation:operation];

  
    
 /*
    
    [self addWorkout:@"Endurance Ride 73 min" :@"CFN030014-00M"];
    [self addWorkout:@"Pyramid Indoor Cycle": @"CFN01001D-00M"];
    [self addWorkout:@"Fat-Burn 1": @"CFN01000E-00M"];
    [self addWorkout:@"Post Run Strength Mini": @"CFN020024-00M"];
    [self addWorkout:@"Interval Advanced Run ": @"CFN030006-00M"];
    [self addWorkout:@"Speed Treadmill": @"CFN020003-00M"];
    [self addWorkout:@"Tempo Treadmill": @"CFN020004-00M"];
    [self addWorkout:@"Fat-Burn 3": @"CFN01000G-00M"];
    [self addWorkout:@"Fat-Burn 2": @"CFN01000F-00M"];
    [self addWorkout:@"Sprint Triathlon Brick": @"CFN01000Z-00M"];
    [self addWorkout:@"Iron Triathlon Brick": @"CFN01000Y-00M"];
    [self addWorkout:@"Functional Strength ": @"CFN030005-00M"];
    [self addWorkout:@"Bike Trainer 1": @"CFN030007-00M"];
    [self addWorkout:@"Endurance Ride": @"CFN030008-00M"];
    [self addWorkout:@"Super SlimTone Bands 3": @"CFN050040-00M"];
    [self addWorkout:@"Robert Reames - Super SlimTone Bands 2": @"CFN050041-00M"];
    [self addWorkout:@"Super SlimTone Gym 3": @"CFN050032-00M"];
    [self addWorkout:@"Time Saver Super Blast 1": @"CFN050014-00M"];
    [self addWorkout:@"Super SlimTone Gym 1": @"CFN050030-00M"];
    [self addWorkout:@"Super SlimTone Gym 2": @"CFN050031-00M"];
    [self addWorkout:@"Time Saver Super Blast 2": @"CFN050015-00M"];
    [self addWorkout:@"Interval Walk Run Climb": @"CFN050016-00M"];
    [self addWorkout:@"Super SlimTone Bands 1": @"CFN050036-00M"];
    [self addWorkout:@"Short Interval Special": @"CFN050017-00M"];
    [self addWorkout:@"Post Cardio Flexibility": @"CFN050011-00M"];
    [self addWorkout:@"Injury Prevention": @"CFN01008M-00M"];
    [self addWorkout:@"Lunchtime Power Walk": @"CFN090003-00M"];
    [self addWorkout:@"The 5 min Warmup": @"CFN090008-00M"];
    [self addWorkout:@"Cardio Band Blast 2": @"CFN090002-00M"];
    [self addWorkout:@"Endurance Ride 110min": @"CFN030012-00M"];
    [self addWorkout:@"Endurance Ride 83min": @"CFN030017-00M"];
    [self addWorkout:@"Cardio Band Blast 1": @"CFN090001-00M"];
    [self addWorkout:@"Endurance Ride 95min": @"CFN030019-00M"];
    [self addWorkout:@"Endurance Ride 100min": @"CFN030011-00M"];
    [self addWorkout:@"Endurance Ride 70min": @"CFN030013-00M"];
    [self addWorkout:@"Endurance Ride 75min": @"CFN030015-00M"];
    [self addWorkout:@"Endurance Ride 77min": @"CFN030016-00M"];
    [self addWorkout:@"Endurance + Hill Run": @"CFN030010-00M"];
    [self addWorkout:@"Endurance Ride 90min": @"CFN030018-00M"];
    [self addWorkout:@"Pyramid + Hill Run": @"CFN030021-00M"];
    [self addWorkout:@"Hi-Intensity Interval 1": @"CFN01000H-00M"];
    [self addWorkout:@"HIIT 30 Thirties": @"CFN080003-00M"];
    [self addWorkout:@"Tread 'N' Shred Advanced 1": @"CFN150003-00M"];
    [self addWorkout:@"Tread'N'Shred Moderate 1": @"CFN150002-00M"];
    [self addWorkout:@"Functional Strength Circuit": @"CFN01001C-00M"];
    [self addWorkout:@"Tred'N'Shred Beginner 1": @"CFN150001-00M"];
    
*/

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
    NSLog(@"Number of Workoutrows to show... %d", [self.workoutList count]);
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
        destViewController.wDate = _wDate;
        destViewController.wSKU = w.SKU;
        
    }
}



@end
