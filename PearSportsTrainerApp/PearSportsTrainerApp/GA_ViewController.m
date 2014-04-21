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
#import "GA_DetailViewController.h"
#import "GA_IncDetailViewController.h"
#import "API.h"

@interface GA_ViewController ()
@property NSString *weekstart;
@property NSString *weekend;
@property NSMutableArray *weekarray;
@property NSMutableArray *weekarrayRaw;
@property (strong,nonatomic) NSDate *currentDay;
@property NSMutableArray *workouts;
@property NSMutableArray *calendarWorkouts;
@property GA_Workout *selectedWorkout;


@property (weak, nonatomic) IBOutlet UILabel *workoutLabel;

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
    //NSLog(@"Hi i am in here");
    
    [[self.tabBarController.tabBar.items objectAtIndex:2] setTitle:[[API sharedInstance] getTraineeInfo].name];
    self.tabBarController.navigationItem.title =@"Workouts";
    self.tabBarController.navigationItem.backBarButtonItem.title=@"Back";
    
    UIBarButtonItem *btnUp = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"up.png"] style:UIBarButtonItemStylePlain target:self action:@selector(prevWeek)];
    
    UIBarButtonItem *btnDown = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"down.png"] style:UIBarButtonItemStylePlain target:self action:@selector(nextWeek)];
    
    [self.tabBarController.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: btnDown,btnUp, nil]];
    
    [self getWeek:[self getTodayDate]];
    
}


-(void)prevWeek
{
    NSDate *today = self.currentDay;
    NSDate *nextweekdate=[NSDate dateWithTimeInterval:(-7*24*60*60) sinceDate:today];
    [self getWeek:nextweekdate];
}

-(void)nextWeek
{
    NSDate *today = self.currentDay;
    NSDate *nextweekdate=[NSDate dateWithTimeInterval:(7*24*60*60) sinceDate:today];
    [self getWeek:nextweekdate];
    
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
    
   
     //NSLog(@"weekstart : %@",self.weekstart);
     //NSLog(@"weekend : %@",self.weekend);
    

    
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
        //NSLog(@"Success of schedule workout: %@", responseObject);
        
        NSDictionary *jsonDict = (NSDictionary *) responseObject;
        
        self.workouts = [[NSMutableArray alloc] init];
        self.wIncompleteList = [[[jsonDict objectForKey:@"workout_data"] objectForKey:@"workouts"] objectForKey:@"data"];
        self.wCompleteList = [[[jsonDict objectForKey:@"workout_data"] objectForKey:@"results"] objectForKey:@"data"];
        
        
        [self.wIncompleteList enumerateObjectsUsingBlock:^(id obj,NSUInteger idx, BOOL *stop){
            
            GA_Workout *w = [GA_Workout alloc];
            w.wdate = [obj objectForKey:@"scheduled_at"];
            w.wdate = [w.wdate substringToIndex:10];

            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            NSString *input = [obj objectForKey:@"scheduled_at"];
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"]; //iso 8601 format
            NSDate *output = [dateFormat dateFromString:input];
            w.date = output;
            
            w.status = [obj objectForKey:@"status"];
            w.workoutName = [[obj objectForKey:@"plan"] objectForKey:@"title"];
            w.SKU = [[obj objectForKey:@"plan"] objectForKey:@"sku"];
            w.activityType = [obj objectForKey:@"activity_type"];
            w.shortDes = [obj objectForKey:@"description_short"];
            w.longDes = [obj objectForKey:@"description_long"];
            w.wID = [obj objectForKey:@"workout_header_id"];
            
            [self.workouts addObject:w];
            
        }];
        

        [self.wCompleteList enumerateObjectsUsingBlock:^(id obj,NSUInteger idx, BOOL *stop){
            
            GA_Workout *w = [GA_Workout alloc];
            w.wdate = [obj objectForKey:@"completed_at"];
            w.wdate = [w.wdate substringToIndex:10];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            NSString *input = [obj objectForKey:@"scheduled_at"];
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"]; //iso 8601 format
            NSDate *output = [dateFormat dateFromString:input];
            w.date = output;

            w.status = [obj objectForKey:@"status"];
            w.workoutName = [[obj objectForKey:@"workout"] objectForKey:@"title"];
            w.SKU = [[[obj objectForKey:@"workout"] objectForKey:@"plan"]objectForKey:@"sku"];
            w.duration = [obj objectForKey:@"duration"];
            w.avgHeartRate = [obj objectForKey:@"avg_hr"];
            w.distance = [obj objectForKey:@"distance"];
            w.calories = [obj objectForKey:@"calories"];
            w.grade = [obj objectForKey:@"grade"];
            w.activityType = [[obj objectForKey:@"workout"] objectForKey:@"activity_type"];
            w.shortDes = [[obj objectForKey:@"workout"] objectForKey:@"description_short"];
            w.longDes = [[obj objectForKey:@"workout"] objectForKey:@"description_html"];
            w.wID = [[obj objectForKey:@"workout"] objectForKey:@"workout_header_id"];
            
            //NSLog(@"Grade: %@", w.grade);
            //NSLog(@"Activity Type: %@", w.activityType);

            [self.workouts addObject:w];
            
        }];



        [self createCalendarList];
        
        [self.tableView reloadData];
        
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
    }];
    
    [manager.operationQueue addOperation:operation];
    
}


- (void) createCalendarList
{
    self.calendarWorkouts = [[NSMutableArray alloc] init];
    GA_WorkoutListForCalendar *workout = [[GA_WorkoutListForCalendar alloc] init];
    GA_Workout *wname = [[GA_Workout alloc] init];
    
    for(int i=0;i<7;i++)
    {
        GA_WorkoutListForCalendar *work = [[GA_WorkoutListForCalendar alloc] init];
        NSDate *date = [self.weekarrayRaw objectAtIndex:i];
        work.date = date;
        
        [self.calendarWorkouts addObject:work];
    }
    
    for(int i=0;i<self.workouts.count;i++)
    {
        wname = [(self.workouts) objectAtIndex:i];
        for(int j=0;j<self.calendarWorkouts.count;j++)
        {
            workout = [(self.calendarWorkouts)objectAtIndex:j];
            if([workout checkIfDateExists:wname.wdate] == true){
                [workout addWorkoutToList:wname];
            }
        }
    }
    
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
    
    //NSLog(@"Number of sections to show... %d", [self.weekarray count]);
    
    return [self.weekarray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
//    return 1;

    return [[self.calendarWorkouts objectAtIndex:section] getWorkoutCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    GA_WorkoutListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell..
    cell.addButton.hidden=TRUE;
    [cell.addButton setTag:indexPath.section];
    
    GA_Workout *wname = [GA_Workout alloc];
    
    wname = [[self.calendarWorkouts objectAtIndex:indexPath.section] getWorkout:(NSInteger*)indexPath.row];
    
    if(wname == nil)
    {
        NSLog(@"No workout");
    }
    else
    {
   
        //grey: complete no results
        //red: skipped
        //green: complete
        //blue: future
        
    
        NSDate * now = [NSDate date];
        NSComparisonResult result = [now compare:wname.date];
        
        [cell.activityTypeText sizeToFit];
        [cell.gradeText sizeToFit];
        cell.gradeText.hidden = NO;
        
        
        switch (result)
        {
            case NSOrderedAscending:{
                if ([wname.status isEqualToString:@"marked_complete"]) {
                    cell.colourCode.backgroundColor=[UIColor lightGrayColor];
                    cell.gradeText.hidden = true;
                }
                else if ([wname.status isEqualToString:@"completed"]) {
                    cell.colourCode.backgroundColor=[UIColor greenColor];
//                    cell.gradeText.hidden = false;
                    cell.gradeText.text = [wname grade];
                }
                else{
                    cell.colourCode.backgroundColor=[UIColor blueColor];
                    cell.gradeText.hidden = true;
                }
                break;
            }
            case NSOrderedDescending:{
                if ([wname.status isEqualToString:@"marked_complete"]) {
                    cell.colourCode.backgroundColor=[UIColor lightGrayColor];
                    cell.gradeText.hidden = true;
                }
                else if ([wname.status isEqualToString:@"completed"]) {
                    cell.colourCode.backgroundColor=[UIColor greenColor];
//                    cell.gradeText.hidden = false;
                    cell.gradeText.text = [wname grade];
                }
                else{
                    cell.colourCode.backgroundColor=[UIColor redColor];
                    cell.gradeText.hidden = true;
                }
                break;            }
            case NSOrderedSame:{
                if ([wname.status isEqualToString:@"marked_complete"]) {
                    cell.colourCode.backgroundColor=[UIColor lightGrayColor];
//                    cell.gradeText.hidden = true;
                }
                else if ([wname.status isEqualToString:@"completed"]) {
                    cell.colourCode.backgroundColor=[UIColor greenColor];
//                    cell.activityTypeText.text = [wname activityType];
//                    cell.gradeText.text = [wname grade];
                }
                else{
                    cell.colourCode.backgroundColor=[UIColor blueColor];
 //                   cell.gradeText.hidden = true;
                }
                break;  }
            default: NSLog(@"erorr dates"); break;
        }

//        [cell.workoutName setText:[wname workoutName]];
        cell.workoutName.text = [wname workoutName];
        cell.descriptionText.text = [wname shortDes];
        cell.activityTypeText.text = [NSString stringWithFormat:@"Type: %@",[wname activityType]];
        cell.gradeText.text = [NSString stringWithFormat:@"Grade: %@", [wname grade]];
        
    }
    
    
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

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GA_Workout *wname = [GA_Workout alloc];
    wname = [[self.calendarWorkouts objectAtIndex:indexPath.section] getWorkout:(NSInteger*)indexPath.row];
    
    self.selectedWorkout = [GA_Workout alloc];
    self.selectedWorkout = wname;
    
    
    if ([wname.status isEqualToString:@"completed"]) {
        [self performSegueWithIdentifier:@"showCompleteDetails" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"showIncompleteDetails" sender:self];
    }
}

//- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
//{
//    if( sourceIndexPath.section != proposedDestinationIndexPath.section )
//    {
//        return sourceIndexPath;
//    }
//    else
//    {
//        return proposedDestinationIndexPath;
//    }
//}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(NSDate *)getTodayDate
{
    
    NSDate* sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    
    
    NSDate *today = destinationDate;
        return today;
}

-(void)getWeek:(NSDate *)today
{

    self.currentDay=today;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];// you can use your format.
    
    //Week Start Date
    
    NSCalendar *gregorian = [[NSCalendar alloc]        initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];
    
    int dayofweek = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:today] weekday];// this will give you current day of week
    
    [components setDay:([components day] - ((dayofweek) - 2))];// for beginning of the week.
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    
    self.weekarrayRaw = [[NSMutableArray alloc] init];
    NSDate *it=beginningOfWeek;
    for(int i=0;i<7;i++)
    {
        //NSLog(@"Day %i: %@", i, it);
        [self.weekarrayRaw addObject:it];
        it=[NSDate dateWithTimeInterval:(24*60*60) sinceDate:it];
    }

    
    self.weekstart =[NSString stringWithFormat:@"%lli",[@(floor([beginningOfWeek timeIntervalSince1970])) longLongValue]];
    
    
    NSDateFormatter *dateFormat_first = [[NSDateFormatter alloc] init];
    [dateFormat_first setDateFormat:@"yyyy-MM-dd"];
    NSString * dateString2Prev = [dateFormat stringFromDate:beginningOfWeek];
    
    NSDate * weekstartPrev = [dateFormat_first dateFromString:dateString2Prev];
 //   NSLog(@"Week start previous %@",weekstartPrev);
    
    
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
  //  NSLog(@"Week end previous %@",weekEndPrev);
    
    
    self.weekarray = [[NSMutableArray alloc] init];
    NSDate *iterator=weekstartPrev;
    for(int i=0;i<7;i++)
    {
        [self.weekarray addObject:iterator];
        iterator=[NSDate dateWithTimeInterval:(24*60*60) sinceDate:iterator];
    }
    
    [self sendWorkOutRequest];
//    [self.tableView reloadData];
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

-(void) showAlert
{
    UIAlertView *autosaveAlert = [[UIAlertView alloc]initWithTitle:@"Close" message:@"Autosave in (%d) seconds" delegate:self cancelButtonTitle:@"Press to cancel" otherButtonTitles:nil];
    [autosaveAlert show];
    
    for(int i = 10; i>=0; i--){
        NSString *tmp = @"Close in (%d) seconds";
        NSString *str = [NSString stringWithFormat:tmp, i];
        [autosaveAlert setMessage:str];
        CFRunLoopRunInMode(kCFRunLoopDefaultMode,1, false);
    }
    
    [autosaveAlert dismissWithClickedButtonIndex:0 animated:TRUE];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"showWorkoutList"]){

        UIButton *button = (UIButton *)sender;
        //NSLog(@"%ld",(long)button.tag);
        
        GA_WorkoutListViewController *destViewController = segue.destinationViewController;
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM-dd-YYYY"];// you can use your format.
        
        NSDate *date = [self.weekarrayRaw objectAtIndex:button.tag];
        //NSLog(@"Date passed at index %i: %@", button.tag, date);
        
        destViewController.wDate = date;
        
    }
    else if([segue.identifier isEqualToString:@"showCompleteDetails"]){

        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        
        GA_Workout *wname = [GA_Workout alloc];
        wname = [[self.calendarWorkouts objectAtIndex:indexPath.section] getWorkout:(NSInteger*)indexPath.row];
        
        GA_DetailViewController *destViewController = segue.destinationViewController;
        destViewController.workout = self.selectedWorkout;
    }
    else if([segue.identifier isEqualToString:@"showIncompleteDetails"]){
        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        
        GA_Workout *wname = [GA_Workout alloc];
        wname = [[self.calendarWorkouts objectAtIndex:indexPath.section] getWorkout:(NSInteger*)indexPath.row];
        
        GA_DetailViewController *destViewController = segue.destinationViewController;
        destViewController.workout = self.selectedWorkout;
    }
    
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //Headerview
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 20.0)];
    [myView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [button setFrame:CGRectMake(275.0, 5.0, 30.0, 30.0)];
    button.tag = section;
    button.hidden = NO;
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [myView addSubview:button];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-YYYY"];// you can use your format.
    
    NSDate *date = [self.weekarray objectAtIndex:section];
    
    
    NSString *header=[NSString stringWithFormat:@"%@ %@",[dateFormat stringFromDate:date],[self getWeekDay:date]];

    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 40)];
    label.text=header;
    [label setFont:[UIFont fontWithName:@"Avenir" size:16.0f]];
    [myView addSubview:label];
    
    return myView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0;
}

-(void)addButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"showWorkoutList" sender:sender];
}

@end
