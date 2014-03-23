//
//  GA_WorkoutsViewController.m
//  PearSportsTrainerApp
//
//  Created by Poojan Jhaveri on 2/23/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "GA_ViewController.h"
#import "GA_WorkoutListCell.h"
#import "GA_WorkoutListViewController.h"
#import "API.h"

@interface GA_ViewController ()
@property NSString *weekstart;
@property NSString *weekend;
@property NSMutableArray *weekarray;

@end

@implementation GA_ViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSLog(@"Hi i am in here");
    
    [[self.tabBarController.tabBar.items objectAtIndex:2] setTitle:[[API sharedInstance] getTraineeInfo].name];
    self.tabBarController.navigationItem.title =@"Workouts";
    self.tabBarController.navigationItem.backBarButtonItem.title=@"Back";
    [self getCurrentWeek];
    [self sendWorkOutRequest];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
 //    self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
}

-(void)sendWorkOutRequest
{
    
   
     NSLog(@"weekstart : %@",self.weekstart);
     NSLog(@"weekend : %@",self.weekend);
    

    
    NSString * token = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser" ] valueForKey:@"token"];
    NSString *tra_id = [NSString stringWithFormat:@"%@",[[API sharedInstance] getTraineeInfo].trainee_id];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:tra_id, nil] forKeys:[NSArray arrayWithObjects:@"trainee_id", nil]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSURLCredential *credential = [NSURLCredential credentialWithUser:token password:@"" persistence:NSURLCredentialPersistenceNone];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:token password:@""];
    
    
 //   NSString *urlstring = [NSString stringWithFormat:@"https://cs477-backend.herokuapp.com/workout_schedule/1392152092/1394744077"];
    
    NSString *urlstring = [NSString stringWithFormat:@"https://cs477-backend.herokuapp.com/workout_schedule/%@/%@",self.weekstart,self.weekend];
    
    NSMutableURLRequest *reqst = [manager.requestSerializer requestWithMethod:@"GET" URLString:urlstring parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:reqst];
    [operation setCredential:credential];
    [operation setResponseSerializer:[AFJSONResponseSerializer alloc]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
    }];
    
    [manager.operationQueue addOperation:operation];
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
    
    NSLog(@"Number of sections to show... %d", [self.weekarray count]);
    
    return [self.weekarray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    GA_WorkoutListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-YYYY"];// you can use your format.
    
    NSDate *date = [self.weekarray objectAtIndex:section];
    
    
    NSString *header=[NSString stringWithFormat:@"%@ %@",[dateFormat stringFromDate:date],[self getWeekDay:date]];
    
    return  header;
}


-(void)getCurrentWeek
{
    
    NSDate* sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    
    
    NSDate *today = destinationDate;
    NSLog(@"Today date is %@",today);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];// you can use your format.
    
    //Week Start Date
    
    NSCalendar *gregorian = [[NSCalendar alloc]        initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];
    
    int dayofweek = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:today] weekday];// this will give you current day of week
    
    [components setDay:([components day] - ((dayofweek) - 2))];// for beginning of the week.
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    
    
    self.weekstart =[NSString stringWithFormat:@"%lli",[@(floor([beginningOfWeek timeIntervalSince1970])) longLongValue]];
    
    
    NSDateFormatter *dateFormat_first = [[NSDateFormatter alloc] init];
    [dateFormat_first setDateFormat:@"yyyy-MM-dd"];
    NSString * dateString2Prev = [dateFormat stringFromDate:beginningOfWeek];
    
    NSDate * weekstartPrev = [dateFormat_first dateFromString:dateString2Prev];
    
    
    
    NSLog(@"Week start previous %@",weekstartPrev);
    
    
    //Week End Date
    
    NSCalendar *gregorianEnd = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *componentsEnd = [gregorianEnd components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];
    
    int Enddayofweek = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:today] weekday];// this will give you current day of week
    
    [componentsEnd setDay:([componentsEnd day]+(7-Enddayofweek)+1)];// for end day of the week
    
    NSDate *EndOfWeek = [gregorianEnd dateFromComponents:componentsEnd];
    
    self.weekend =[NSString stringWithFormat:@"%lli",[@(floor([EndOfWeek timeIntervalSince1970])) longLongValue]];
    
    
    
    NSDateFormatter *dateFormat_End = [[NSDateFormatter alloc] init];
    [dateFormat_End setDateFormat:@"yyyy-MM-dd"];
    NSString *dateEndPrev = [dateFormat stringFromDate:EndOfWeek];
    
    NSDate *weekEndPrev = [dateFormat_End dateFromString:dateEndPrev];
    NSLog(@"Week end previous %@",weekEndPrev);
    
    
    self.weekarray = [[NSMutableArray alloc] init];
    NSDate *iterator=weekstartPrev;
    for(int i=0;i<7;i++)
    {
        [self.weekarray addObject:iterator];
        iterator=[NSDate dateWithTimeInterval:(24*60*60) sinceDate:iterator];
    }
    [self.tableView reloadData];
}

-(NSString *)getWeekDay:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[gregorian components:NSWeekdayCalendarUnit fromDate:date];
    NSInteger weekday = [weekdayComponents weekday];
    NSString *string = [[NSString alloc] init];
    switch(weekday)
    {
        case 1:
            string=@"Sunday";
            break;
        case 2:
            string=@"Monday";
            break;
        case 3:
            string=@"Tuesday";
            break;
        case 4:
            string=@"Wednesday";
            break;
        case 5:
            string=@"Thursday";
            break;
        case 6:
            string=@"Friday";
            break;
        case 7:
            string=@"Saturday";
            break;

    }
    
    return string;
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
    if([segue.identifier isEqualToString:@"showWorkoutList"]){
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
        GA_WorkoutListViewController *destViewController = segue.destinationViewController;
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM-dd-YYYY"];// you can use your format.
        
        NSDate *date = [self.weekarray objectAtIndex:indexPath.section];
        
        destViewController.wDate = date;
        
    }
    
}



@end
