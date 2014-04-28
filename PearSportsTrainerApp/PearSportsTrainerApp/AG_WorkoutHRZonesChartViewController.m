//
//  AG_WorkoutHRZonesChartViewController.m
//  PearSportsTrainerApp
//
//  Created by Alfonso Garza on 4/23/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "AG_WorkoutHRZonesChartViewController.h"
#import "AG_ClientSummaryChartInformationView.h"
#import "AG_ClientSummaryChartHeaderView.h"
#import "JBBarChartView.h"
#import "API.h"
#import "AG_JBConstants.h"

// Numerics
CGFloat const kJBBarChartViewControllerChartHeight = 250.0f;
CGFloat const kJBBarChartViewControllerChartPadding = 10.0f;
CGFloat const kJBBarChartViewControllerChartHeaderHeight = 80.0f;
CGFloat const kJBBarChartViewControllerChartHeaderPadding = 10.0f;
CGFloat const kJBBarChartViewControllerChartFooterHeight = 25.0f;
CGFloat const kJBBarChartViewControllerChartFooterPadding = 5.0f;
CGFloat const kJBBarChartViewControllerBarPadding = 1;
NSInteger const kJBBarChartViewControllerNumBars = sizeof([[API sharedInstance] getTraineeInfo].workoutArray);
NSInteger const kJBBarChartViewControllerMaxBarHeight = 10;
NSInteger const kJBBarChartViewControllerMinBarHeight = 0;

@interface AG_WorkoutHRZonesChartViewController () <JBBarChartViewDelegate, JBBarChartViewDataSource>

@property (nonatomic, strong) JBBarChartView *barChartView;
@property (nonatomic, strong) AG_ClientSummaryChartInformationView *informationView;
@property (nonatomic, strong) NSArray *chartData;
@property (nonatomic, strong) NSArray *weekDates;

@end

@implementation AG_WorkoutHRZonesChartViewController

@synthesize workout;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      [self initData];
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initData];
  
  self.view.backgroundColor = kJBColorBarChartControllerBackground;
  
  self.barChartView = [[JBBarChartView alloc] init];
  self.barChartView.frame = CGRectMake(kJBBarChartViewControllerChartPadding, kJBBarChartViewControllerChartPadding, self.view.bounds.size.width - (kJBBarChartViewControllerChartPadding * 2), kJBBarChartViewControllerChartHeight);
  self.barChartView.delegate = self;
  self.barChartView.dataSource = self;
  self.barChartView.headerPadding = kJBBarChartViewControllerChartHeaderPadding;
  self.barChartView.backgroundColor = kJBColorBarChartBackground;
  
  
  AG_ClientSummaryChartHeaderView *headerView = [[AG_ClientSummaryChartHeaderView alloc] initWithFrame:CGRectMake(kJBBarChartViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBBarChartViewControllerChartHeaderHeight * 0.5), self.view.bounds.size.width - (kJBBarChartViewControllerChartPadding * 2), kJBBarChartViewControllerChartHeaderHeight)];
  headerView.titleLabel.text = [@"Heart Rate Zones" uppercaseString];
  headerView.separatorColor = kJBColorBarChartHeaderSeparatorColor;
  self.barChartView.headerView = headerView;
  
  
  self.informationView = [[AG_ClientSummaryChartInformationView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, CGRectGetMaxY(self.barChartView.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.barChartView.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
  [self.view addSubview:self.informationView];
  
  [self.view addSubview:self.barChartView];
  [self.barChartView reloadData];
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark - Date

- (void)initData
{
  
  NSString *url = workout.hrDataURL;
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
  NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET"
                                                                    URLString:url
                                                                   parameters:nil
                                                                        error:nil];
  
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  [operation setResponseSerializer:[AFJSONResponseSerializer alloc]];
  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSLog(@"Success loading hr data stats.");
    NSMutableArray *metrics = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"metrics"]];
    
    NSMutableArray *hrData = [[NSMutableArray alloc] init];

    // Add Empty Zones
    [hrData addObject:[NSNumber numberWithInt:0]];
    [hrData addObject:[NSNumber numberWithInt:0]];
    [hrData addObject:[NSNumber numberWithInt:0]];
    [hrData addObject:[NSNumber numberWithInt:0]];
    [hrData addObject:[NSNumber numberWithInt:0]];
    
    
    NSNumber *hr1_low = [[workout.hrZones objectAtIndex:0] objectForKey:@"low"];
    NSNumber *hr1_high = [[workout.hrZones objectAtIndex:0] objectForKey:@"high"];
    
    NSNumber *hr2_low = [[workout.hrZones objectAtIndex:1] objectForKey:@"low"];
    NSNumber *hr2_high = [[workout.hrZones objectAtIndex:1] objectForKey:@"high"];
    
    NSNumber *hr3_low = [[workout.hrZones objectAtIndex:2] objectForKey:@"low"];
    NSNumber *hr3_high = [[workout.hrZones objectAtIndex:2] objectForKey:@"high"];
    
    NSNumber *hr4_low = [[workout.hrZones objectAtIndex:3] objectForKey:@"low"];
    NSNumber *hr4_high = [[workout.hrZones objectAtIndex:3] objectForKey:@"high"];
    
    NSNumber *hr5_low = [[workout.hrZones objectAtIndex:4] objectForKey:@"low"];
    NSNumber *hr5_high = [[workout.hrZones objectAtIndex:4] objectForKey:@"high"];
    NSNumber *time_elapsed = @(0);
    
    for (NSArray *metric in metrics) {
      
      NSNumber *current_time = [metric objectAtIndex:0];
      NSNumber *heart_rate = [metric objectAtIndex:1];
      int zone = -1;
      
      if (heart_rate >= hr1_low && heart_rate <= hr1_high)
        zone = 1;
      else if (heart_rate >= hr2_low && heart_rate <= hr2_high)
        zone = 2;
      else if (heart_rate >= hr3_low && heart_rate <= hr3_high)
        zone = 3;
      else if (heart_rate >= hr4_low && heart_rate <= hr4_high)
        zone = 4;
      else if (heart_rate >= hr5_low && heart_rate <= hr5_high)
        zone = 5;
      
      // Add time to the zone
      if (zone > 0) {
        int new = [[hrData objectAtIndex:(zone - 1)] intValue] + ([current_time intValue] - [time_elapsed intValue]);
        [hrData replaceObjectAtIndex:(zone - 1) withObject:[NSNumber numberWithInteger:new]];
      }
      
      // Update Time Elapsed
      time_elapsed = current_time;
      
    }
    
    // Set Data
    workout.hrZonesData =  hrData;
    
    [self.barChartView reloadData];
    
    int total = 0;
    for (NSNumber *time in workout.hrZonesData) {
      total += [time intValue];
    }
    
    int time_in_zone = [[workout.hrZonesData objectAtIndex:0] intValue];
    float percentage = ((float)time_in_zone/(float)total)*100;
    int minutes = (int) time_in_zone / 60;
    int seconds = (int) time_in_zone - (minutes*60);
    
    [self.informationView setValueText:[NSString stringWithFormat:@"%d:%d (%.02f%%) ", minutes, seconds, percentage] unitText:nil];
    
    
    [self.informationView setTitleText:@"Zone 1"];
    [self.informationView setHidden:NO animated:YES];
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Couldn't load HR Data.");
  }];
  
  [manager.operationQueue addOperation:operation];
  
  
}

#pragma mark - JBCharts

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSUInteger)index
{
  
  int total = 0;
  for (NSNumber *time in workout.hrZonesData) {
    total += [time intValue];
  }
  
  int time_in_zone = [[workout.hrZonesData objectAtIndex:index] intValue];
  float percentage = ((float)time_in_zone/(float)total)*100;
  
  return percentage;
}

- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
  return [workout.hrZonesData count];
}

- (NSUInteger)barPaddingForBarChartView:(JBBarChartView *)barChartView
{
  return kJBBarChartViewControllerBarPadding;
}

- (UIView *)barChartView:(JBBarChartView *)barChartView barViewAtIndex:(NSUInteger)index
{
  UIView *barView = [[UIView alloc] init];
  barView.backgroundColor = (index % 2 == 0) ? kJBColorBarChartBarBlue : kJBColorBarChartBarGreen;
  return barView;
}

- (UIColor *)barSelectionColorForBarChartView:(JBBarChartView *)barChartView
{
  return [UIColor whiteColor];
}

- (void)barChartView:(JBBarChartView *)barChartView didSelectBarAtIndex:(NSUInteger)index touchPoint:(CGPoint)touchPoint
{
  int total = 0;
  for (NSNumber *time in workout.hrZonesData) {
    total += [time intValue];
  }
  
  int time_in_zone = [[workout.hrZonesData objectAtIndex:index] intValue];
  float percentage = ((float)time_in_zone/(float)total)*100;
  int minutes = (int) time_in_zone / 60;
  int seconds = (int) time_in_zone - (minutes*60);
  
  [self.informationView setValueText:[NSString stringWithFormat:@"%d:%d (%.02f%%) ", minutes, seconds, percentage] unitText:nil];
  
  
  [self.informationView setTitleText:[NSString stringWithFormat:@"Zone %lu", (unsigned long)index+1]];
  [self.informationView setHidden:NO animated:YES];
}

- (void)didUnselectBarChartView:(JBBarChartView *)barChartView
{
//  [self.informationView setHidden:YES animated:YES];
}


@end
