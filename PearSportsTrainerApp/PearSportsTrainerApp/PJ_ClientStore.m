//
//  PJ_ClientStore.m
//  PearSportsTrainerApp
//
//  Created by Devon on 2/9/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "PJ_ClientStore.h"
#import "PJ_Client.h"
#import "API.h"

@implementation PJ_ClientStore

@synthesize clients;


- (id) init {
    
    if (self = [super init]) {
        
        clients = [[NSMutableArray alloc] init];
        
    }
    
    return self;
    
}

+ (id) sharedClientStore
{
    
    static PJ_ClientStore * sharedMyClientStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyClientStore = [[self alloc] init];
    });
    return sharedMyClientStore;
    
    
}

- (void) addRandomClients
{
    PJ_Client * client1 = [[PJ_Client alloc] init];
    [client1 setName:@"John Doe"];
    [client1 setNumNotifications:2];
    
    PJ_Client * client2 = [[PJ_Client alloc] init];
    [client2 setName:@"Jane Fonda"];
    [client2 setNumNotifications:5];
    
    PJ_Client * client3 = [[PJ_Client alloc] init];
    [client3 setName:@"Devon Meyer"];
    [client3 setNumNotifications:0];
    
    
    [[[PJ_ClientStore sharedClientStore] clients] addObject:client1];
    [[[PJ_ClientStore sharedClientStore] clients] addObject:client2];
    [[[PJ_ClientStore sharedClientStore] clients] addObject:client3];
    
    
    
}

- (void) updateData
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSString * token = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser" ] valueForKey:@"token"];
    
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:token password:@""];
    
    [manager GET:@"https://cs477-backend.herokuapp.com/trainee_list" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         [self.clients removeAllObjects];
         //NSLog(@"%@", responseObject);
         
         NSMutableArray * traineeList = [NSMutableArray arrayWithArray:responseObject[@"trainee_list"]];
         
         for (NSString * trainee_id in traineeList) {
             PJ_Client * theTrainee = [[PJ_Client alloc] init];
             [theTrainee setName:@""];
             [theTrainee setTrainee_id:trainee_id];
             
             [self.clients addObject:theTrainee];
         }
         
         /*for (NSString * trainee_id in traineeList) {
          [self updateClientDataForTraineeWithId:trainee_id];
          }*/
         
         
         
         
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         
         NSLog(@"Error: %@", error);
         
         
     }];
    
    
}

- (void) updateDataAndPerformSelector:(SEL)aSelector withTarget:(id)aTarget onError:(SEL)errorSelector
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSString * token = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser" ] valueForKey:@"token"];
    
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:token password:@""];
    
    [manager GET:@"https://cs477-backend.herokuapp.com/trainee_list" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self.clients removeAllObjects];
         
         
         [[responseObject objectForKey:@"trainee_list"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
             
             PJ_Client * theTrainee = [[PJ_Client alloc] init];
             
             [theTrainee setName:[obj objectForKey:@"screen_name"]];
             [theTrainee setTrainee_id:key];
             [theTrainee setAge:[obj objectForKey:@"age"]];
             [theTrainee setDob:[obj objectForKey:@"dob"]];
             [theTrainee setEmail:[obj objectForKey:@"email"]];
             [theTrainee setGender:[obj objectForKey:@"gender"]];
           [theTrainee setHeight:[obj objectForKey:@"height"]];
           [theTrainee setWeight:[obj objectForKey:@"weight"]];
           [theTrainee setNotes:[obj objectForKey:@"notes"]];
             [theTrainee setImageName:[obj objectForKey:@"photo_url"]];
             if([[obj objectForKey:@"photo_url"] isEqualToString:@""])
             {
                 [theTrainee setImageName:@"http://3.bp.blogspot.com/-xma5UhDPjVQ/UgF9gJgVzvI/AAAAAAAAGDU/DwueSqKx2AI/s1600/7.jpg"];
             }
             
//             if([[obj objectForKey:@"screen_name"] isEqualToString:@"Joe R"])
//             {
//                 [theTrainee setImageName:@"Joe.png"];
//             }
//             else
//             {
//                 [theTrainee setImageName:@"poojan.jpg"];
//             }
             
             [theTrainee setWorkoutArray:[[NSMutableArray alloc] initWithCapacity:4]];
             
             [[theTrainee workoutArray] insertObject:[[NSMutableArray alloc] initWithCapacity:7] atIndex:0];
             [[theTrainee workoutArray] insertObject:[[NSMutableArray alloc] initWithCapacity:7] atIndex:1];
             [[theTrainee workoutArray] insertObject:[[NSMutableArray alloc] initWithCapacity:7] atIndex:2];
             
             
             
             for (int i = 0; i < 7; i++) {
                 
                 NSString * a = @"";
                 NSString * b = @"";
                 NSString * c = @"";
                 
                 [[theTrainee workoutArray][0] insertObject:a atIndex:i];
                 [[theTrainee workoutArray][1] insertObject:b atIndex:i];
                 [[theTrainee workoutArray][2] insertObject:c atIndex:i];
                 
             }
             
            
             
             NSMutableArray * markedCompleteTimes = [[obj objectForKey:@"workout_schedule_stats"] objectForKey:@"marked_complete_times"];
             
             NSMutableArray * completeTimes = [[obj objectForKey:@"workout_schedule_stats"] objectForKey:@"complete_times"];
             //NSLog(@"%@", obj);
             NSMutableArray * incompleteTimes = [[obj objectForKey:@"workout_schedule_stats"] objectForKey:@"incomplete_times"];
             
             NSMutableArray * futureTimes = [[obj objectForKey:@"workout_schedule_stats"] objectForKey:@"future_times"];
             
             NSCalendar * aCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
             
             
             
             NSDateComponents *todaysDateComponents = [aCalendar components: NSCalendarUnitWeekOfYear  | NSCalendarUnitWeekday fromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
             
             int myWeek = [todaysDateComponents weekOfYear];
             
             NSString *lastWork = [NSString stringWithFormat:@"Never"];
             for (NSString * aString in completeTimes) {
                 
                 int anInt = [aString integerValue];
                 
                 NSDate * aDate = [NSDate dateWithTimeIntervalSince1970:anInt];
                 
                 NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                 [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
                 [dateFormatter setDateStyle:NSDateFormatterShortStyle];
                 
                 lastWork = [dateFormatter stringFromDate:aDate];
                 
                 NSDateComponents *aDateComponent = [aCalendar components: NSCalendarUnitWeekOfYear  | NSCalendarUnitWeekday fromDate:aDate];
                 
                 int completedWeek = [aDateComponent weekOfYear];
                 int completedDay = [aDateComponent weekday];
                 
                 int weekIndex = -1;
                 int dayIndex;
                 
                 if (completedWeek == (myWeek - 2) ) {
                     
                     weekIndex = 0;
                     dayIndex = completedDay - 1;
                     
                 } else if (completedWeek == (myWeek - 1)) {
                     
                     weekIndex = 1;
                     dayIndex = completedDay - 1;
                     
                 } else if (completedWeek == myWeek) {
                     
                     weekIndex = 2;
                     dayIndex = completedDay - 1;
                     
                 }
                 
                 if (weekIndex != -1) {
                     
                     
                     NSString * s = [theTrainee workoutArray][weekIndex][dayIndex];
                     s = [s stringByAppendingString:@"complete!"];
                     [theTrainee workoutArray][weekIndex][dayIndex] = s;
                     
                 }
                 
                 
                 
                 
             }
             
             [theTrainee setLastWorkout:lastWork];
             //NSLog(@"LST: %@", lastWork);
             
             for (NSString * aString in incompleteTimes) {
                 
                 int anInt = [aString integerValue];
                 
                 NSDate * aDate = [NSDate dateWithTimeIntervalSince1970:anInt];
                 
                 NSDateComponents *aDateComponent = [aCalendar components: NSCalendarUnitWeekOfYear  | NSCalendarUnitWeekday fromDate:aDate];
                 
                 int incompletedWeek = [aDateComponent weekOfYear];
                 int incompletedDay = [aDateComponent weekday];
                 
                 int weekIndex = -1;
                 int dayIndex;
                 
                 if (incompletedWeek == (myWeek - 2) ) {
                     
                     weekIndex = 0;
                     dayIndex = incompletedDay - 1;
                     
                 } else if (incompletedWeek == (myWeek - 1)) {
                     
                     weekIndex = 1;
                     dayIndex = incompletedDay - 1;
                     
                 } else if (incompletedWeek == myWeek) {
                     
                     weekIndex = 2;
                     dayIndex = incompletedDay - 1;
                     
                 }
                 
                 if (weekIndex != -1) {
                     
                     NSString * s = [theTrainee workoutArray][weekIndex][dayIndex];
                     s = [s stringByAppendingString:@"incomplete!"];
                     [theTrainee workoutArray][weekIndex][dayIndex] = s;
                     
                 }
                 
                 
                 
                 
             }
             
             for (NSString * aString in futureTimes) {
                 
                 int anInt = [aString integerValue];
                 
                 NSDate * aDate = [NSDate dateWithTimeIntervalSince1970:anInt];
                 
                 NSDateComponents *aDateComponent = [aCalendar components:NSCalendarUnitWeekOfYear  | NSCalendarUnitWeekday fromDate:aDate];
                 
                 
                 int futureWeek = [aDateComponent weekOfYear];
                 int futureDay = [aDateComponent weekday];
                 
                 int weekIndex = -1;
                 int dayIndex = -1;
                 
                 if (futureWeek == (myWeek - 2) ) {
                     
                     weekIndex = 0;
                     dayIndex = futureDay - 1;
                     
                 } else if (futureWeek == (myWeek - 1)) {
                     
                     weekIndex = 1;
                     dayIndex = futureDay - 1;
                     
                 } else if (futureWeek == myWeek) {
                     
                     weekIndex = 2;
                     dayIndex = futureDay - 1;
                     
                 }
                 
                 
                 //NSLog(@"Future week is %d, my week is %d", futureWeek, myWeek);
                 //NSLog(@"Week Index is %d, day index is %d", weekIndex, dayIndex);
                 
                 if (weekIndex != -1) {
                     NSString * s = [theTrainee workoutArray][weekIndex][dayIndex];
                     s = [s stringByAppendingString:@"scheduled!"];
                     [theTrainee workoutArray][weekIndex][dayIndex] = s;
                     
                 }
                 
                 
                 
                 
             }
             
             for (NSString * aString in markedCompleteTimes) {
                 
                 int anInt = [aString integerValue];
                 
                 NSDate * aDate = [NSDate dateWithTimeIntervalSince1970:anInt];
                 
                 NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                 [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
                 [dateFormatter setDateStyle:NSDateFormatterShortStyle];
                 
                 lastWork = [dateFormatter stringFromDate:aDate];
                 
                 NSDateComponents *aDateComponent = [aCalendar components: NSCalendarUnitWeekOfYear  | NSCalendarUnitWeekday fromDate:aDate];
                 
                 int markedCompletedWeek = [aDateComponent weekOfYear];
                 int markedCompletedDay = [aDateComponent weekday];
                 
                 int weekIndex = -1;
                 int dayIndex;
                 
                 if (markedCompletedWeek == (myWeek - 2) ) {
                     
                     weekIndex = 0;
                     dayIndex = markedCompletedDay - 1;
                     
                 } else if (markedCompletedWeek == (myWeek - 1)) {
                     
                     weekIndex = 1;
                     dayIndex = markedCompletedDay - 1;
                     
                 } else if (markedCompletedWeek == myWeek) {
                     
                     weekIndex = 2;
                     dayIndex = markedCompletedDay - 1;
                     
                 }
                 
                 if (weekIndex != -1) {
                     
                     
                     NSString * s = [theTrainee workoutArray][weekIndex][dayIndex];
                     s = [s stringByAppendingString:@"markedComplete!"];
                     [theTrainee workoutArray][weekIndex][dayIndex] = s;
                     
                 }
                 
                 
                 
                 
             }

             
             
             [self.clients addObject:theTrainee];
             
             //NSLog(@"%@ %@",obj,key);
             
             //NSLog(@"Trainee %@'s Workouts : %@", [theTrainee name], [theTrainee workoutArray]);
             
         }];
         
         
         
         [aTarget performSelector:aSelector];
         
         
         
         
         
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         
         [aTarget performSelector:errorSelector withObject:error];
         
         
     }];
    
}



@end