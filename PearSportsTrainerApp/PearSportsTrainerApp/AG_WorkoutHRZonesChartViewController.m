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
  NSMutableArray *mutableChartData = [NSMutableArray array];
  for (int i=0; i < 5; i++)
  {
    NSInteger delta = (5 - abs((5 - i) - i)) + 2;
    [mutableChartData addObject:[NSNumber numberWithFloat:MAX((delta * kJBBarChartViewControllerMinBarHeight), arc4random() % (delta * kJBBarChartViewControllerMaxBarHeight))]];
  }
  
  //  NSInteger hr1_low, hr1_high, hr2_low, hr2_high, hr3_low, hr3_high, hr4_low, hr4_high, hr5_low, hr5_high;

  NSLog(@"LOW: %@", [[workout.hrZones objectAtIndex:0] objectForKey:@"low"]);
  
  
  
  
  
  
  _chartData = [NSArray arrayWithArray:mutableChartData];
}

#pragma mark - JBCharts

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSUInteger)index
{
  int count = (int)[[[API sharedInstance] getTraineeInfo].workoutArray count] - 1;
  int week = count - (int)index;
  
  if (week >= [[[API sharedInstance] getTraineeInfo].workoutArray count]) {
    return 0;
  } else {
    
    
    int count = 0;
    
    for (NSString *dayWorkStatus in [[[API sharedInstance] getTraineeInfo].workoutArray objectAtIndex:week]) {
      if ([dayWorkStatus isEqualToString:@"complete"]) {
        count++;
      }
    }
    
    return count;
  }
  
}

- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
  return [[[API sharedInstance] getTraineeInfo].workoutArray count];
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
  
  int count = (int)[[[API sharedInstance] getTraineeInfo].workoutArray count] - 1;
  int week = count - (int)index;
  if (week >= [[[API sharedInstance] getTraineeInfo].workoutArray count]) {
    [self.informationView setValueText:[NSString stringWithFormat:@"0 workouts"] unitText:nil];
  } else {
    
    int count = 0;
    
    for (NSString *dayWorkStatus in [[[API sharedInstance] getTraineeInfo].workoutArray objectAtIndex:week]) {
      if ([dayWorkStatus isEqualToString:@"complete"]) {
        count++;
      }
    }
    
    [self.informationView setValueText:[NSString stringWithFormat:@"%d workouts", count] unitText:nil];
  }
  
  NSDate *today = [NSDate date];
  NSCalendar *gregorian = [NSCalendar currentCalendar];
  
  // Get the weekday component of the current date
  NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:today];
  /*
   Create a date components to represent the number of days to subtract
   from the current date.
   The weekday value for Sunday in the Gregorian calendar is 1, so
   subtract 1 from the number
   of days to subtract from the date in question.  (If today's Sunday,
   subtract 0 days.)
   */
  NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
  /* Substract [gregorian firstWeekday] to handle first day of the week being something else than Sunday */
  [componentsToSubtract setDay: - ([weekdayComponents weekday] - [gregorian firstWeekday])];
  NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:today options:0];
  
  /*
   Optional step:
   beginningOfWeek now has the same hour, minute, and second as the
   original date (today).
   To normalize to midnight, extract the year, month, and day components
   and create a new date from those components.
   */
  NSDateComponents *components = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                              fromDate: beginningOfWeek];
  
  [components setDay:([components day] - week*7)];
  beginningOfWeek = [gregorian dateFromComponents: components];
  
  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
  [dateFormatter setDateStyle:NSDateFormatterShortStyle];
  NSString *weekDate = [dateFormatter stringFromDate:beginningOfWeek];
  
  NSString *weeksAgo = @"This Week";
  if (week == 1) {
    weeksAgo = [NSString stringWithFormat:@"1 week ago"];
  }
  if (week > 1) {
    weeksAgo = [NSString stringWithFormat:@"%d weeks ago", week];
  }
  
  
  
  [self.informationView setTitleText:[NSString stringWithFormat:@"%@ (%@)",weeksAgo, weekDate]];
  [self.informationView setHidden:NO animated:YES];
}

- (void)didUnselectBarChartView:(JBBarChartView *)barChartView
{
  [self.informationView setHidden:YES animated:YES];
}


@end
