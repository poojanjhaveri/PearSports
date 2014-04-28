//
//  AG_WorkoutHRLineChartViewController.m
//  PearSportsTrainerApp
//
//  Created by Alfonso Garza on 4/27/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import "AG_WorkoutHRLineChartViewController.h"
#import "JBLineChartView.h"
#import "AG_JBConstants.h"
#import "AG_ClientSummaryChartInformationView.h"
#import "AG_ClientSummaryChartHeaderView.h"
#import "API.h"
#import "GA_Workout.h"

#define ARC4RANDOM_MAX 0x100000000

typedef NS_ENUM(NSInteger, JBLineChartLine){
	JBLineChartLineSolid,
  JBLineChartLineDashed,
  JBLineChartLineCount
};

// Numerics
CGFloat const kJBLineChartViewControllerChartHeight = 250.0f;
CGFloat const kJBLineChartViewControllerChartPadding = 10.0f;
CGFloat const kJBLineChartViewControllerChartHeaderHeight = 75.0f;
CGFloat const kJBLineChartViewControllerChartHeaderPadding = 20.0f;
CGFloat const kJBLineChartViewControllerChartFooterHeight = 20.0f;
CGFloat const kJBLineChartViewControllerChartSolidLineWidth = 6.0f;
CGFloat const kJBLineChartViewControllerChartDashedLineWidth = 2.0f;
NSInteger const kJBLineChartViewControllerMaxNumChartPoints = 7;

// Strings
NSString * const kJBLineChartViewControllerNavButtonViewKey = @"view";


@interface AG_WorkoutHRLineChartViewController () <JBLineChartViewDelegate, JBLineChartViewDataSource>

@property (nonatomic, strong) JBLineChartView *lineChartView;
@property (nonatomic, strong) AG_ClientSummaryChartInformationView *informationView;
@property (nonatomic, strong) NSArray *chartData;
@property (nonatomic, strong) NSArray *daysOfWeek;

// Buttons
- (void)chartToggleButtonPressed:(id)sender;

// Helpers
- (void)initFakeData;
- (NSArray *)largestLineData; // largest collection of fake line data

@end

@implementation AG_WorkoutHRLineChartViewController

@synthesize workout;

#pragma mark - Alloc/Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self)
  {
    [self initFakeData];
  }
  return self;
}

#pragma mark - Data

- (void)initFakeData
{
  NSMutableArray *mutableLineCharts = [NSMutableArray array];
  for (int lineIndex=0; lineIndex<JBLineChartLineCount; lineIndex++)
  {
    NSMutableArray *mutableChartData = [NSMutableArray array];
    for (int i=0; i<kJBLineChartViewControllerMaxNumChartPoints; i++)
    {
      [mutableChartData addObject:[NSNumber numberWithFloat:((double)arc4random() / ARC4RANDOM_MAX)]]; // random number between 0 and 1
    }
    [mutableLineCharts addObject:mutableChartData];
  }
  _chartData = [NSArray arrayWithArray:mutableLineCharts];
  _daysOfWeek = [[[NSDateFormatter alloc] init] shortWeekdaySymbols];
  
  NSString *url = workout.hrDataURL;
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
  NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET"
                                                                    URLString:url
                                                                   parameters:nil
                                                                        error:nil];
  
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  [operation setResponseSerializer:[AFJSONResponseSerializer alloc]];
  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSMutableArray *metrics = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"metrics"]];
    
    // Set Data
    workout.hrRawData =  metrics;
    [self.lineChartView reloadData];
    
    NSNumber *valueNumber = [[workout.hrRawData objectAtIndex:0] objectAtIndex:1];
    
    NSNumber *timeNumber = [[workout.hrRawData objectAtIndex:0] objectAtIndex:0];
    
    [self.informationView setValueText:[NSString stringWithFormat:@"%.0f", [valueNumber floatValue]] unitText:@"bpm"];
    
    int time_in_zone =  [timeNumber intValue];
    int minutes = (int) time_in_zone / 60;
    int seconds = (int) time_in_zone - (minutes*60);
    
    [self.informationView setTitleText:[NSString stringWithFormat:@"Heart Rate at %d:%d", minutes, seconds]];
    [self.informationView setHidden:NO animated:YES];
    
    // SET INITIAL
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Couldn't load HR Data.");
  }];
  
  [manager.operationQueue addOperation:operation];
  
}


- (NSArray *)largestLineData
{
  NSArray *largestLineData = nil;
  for (NSArray *lineData in self.chartData)
  {
    if ([lineData count] > [largestLineData count])
    {
      largestLineData = lineData;
    }
  }
  return largestLineData;
}

#pragma mark - View Lifecycle

- (void)loadView
{
  [super loadView];
  [self initFakeData];
  
  self.view.backgroundColor = kJBColorLineChartControllerBackground;
  
  self.lineChartView = [[JBLineChartView alloc] init];
  self.lineChartView.frame = CGRectMake(kJBLineChartViewControllerChartPadding, kJBLineChartViewControllerChartPadding, self.view.bounds.size.width - (kJBLineChartViewControllerChartPadding * 2), kJBLineChartViewControllerChartHeight);
  self.lineChartView.delegate = self;
  self.lineChartView.dataSource = self;
  self.lineChartView.headerPadding = kJBLineChartViewControllerChartHeaderPadding;
  self.lineChartView.backgroundColor = kJBColorLineChartBackground;
  
  AG_ClientSummaryChartHeaderView *headerView = [[AG_ClientSummaryChartHeaderView alloc] initWithFrame:CGRectMake(kJBLineChartViewControllerChartPadding, ceil(self.view.bounds.size.height * 0.5) - ceil(kJBLineChartViewControllerChartHeaderHeight * 0.5), self.view.bounds.size.width - (kJBLineChartViewControllerChartPadding * 2), kJBLineChartViewControllerChartHeaderHeight)];
  headerView.titleLabel.text = [@"Heart Rate Timeline" uppercaseString];
  headerView.titleLabel.textColor = kJBColorLineChartHeader;
  headerView.titleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
  headerView.titleLabel.shadowOffset = CGSizeMake(0, 1);
  headerView.subtitleLabel.textColor = kJBColorLineChartHeader;
  headerView.subtitleLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
  headerView.subtitleLabel.shadowOffset = CGSizeMake(0, 1);
  headerView.separatorColor = kJBColorLineChartHeaderSeparatorColor;
  self.lineChartView.headerView = headerView;
  
  
  [self.view addSubview:self.lineChartView];
  
  self.informationView = [[AG_ClientSummaryChartInformationView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, CGRectGetMaxY(self.lineChartView.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.lineChartView.frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame))];
  [self.informationView setValueAndUnitTextColor:[UIColor colorWithWhite:1.0 alpha:0.75]];
  [self.informationView setTitleTextColor:kJBColorLineChartHeader];
  [self.informationView setTextShadowColor:nil];
  [self.informationView setSeparatorColor:kJBColorLineChartHeaderSeparatorColor];
  [self.view addSubview:self.informationView];
  
  [self.lineChartView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.lineChartView setState:JBChartViewStateExpanded];
}

#pragma mark - JBLineChartViewDelegate

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
  return [[[workout.hrRawData objectAtIndex:horizontalIndex] objectAtIndex:1] floatValue];
}

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
  NSNumber *valueNumber = [[workout.hrRawData objectAtIndex:horizontalIndex] objectAtIndex:1];
  
  NSNumber *timeNumber = [[workout.hrRawData objectAtIndex:horizontalIndex] objectAtIndex:0];
  
  [self.informationView setValueText:[NSString stringWithFormat:@"%.0f", [valueNumber floatValue]] unitText:@"bpm"];
  
  int time_in_zone =  [timeNumber intValue];
  int minutes = (int) time_in_zone / 60;
  int seconds = (int) time_in_zone - (minutes*60);
  
  [self.informationView setTitleText:[NSString stringWithFormat:@"Heart Rate at %d:%d", minutes, seconds]];
  [self.informationView setHidden:NO animated:YES];
}

- (void)didUnselectLineInLineChartView:(JBLineChartView *)lineChartView
{
//  [self.informationView setHidden:YES animated:YES];
}

#pragma mark - JBLineChartViewDataSource

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
  return 1;
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
  return [workout.hrRawData count];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex
{
  return (lineIndex != JBLineChartLineSolid) ? kJBColorLineChartDefaultSolidLineColor: kJBColorLineChartDefaultDashedLineColor;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
  return (lineIndex != JBLineChartLineSolid) ? kJBColorLineChartDefaultSolidLineColor: kJBColorLineChartDefaultDashedLineColor;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
  return (lineIndex != JBLineChartLineSolid) ? kJBLineChartViewControllerChartSolidLineWidth: kJBLineChartViewControllerChartDashedLineWidth;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView dotRadiusForLineAtLineIndex:(NSUInteger)lineIndex
{
  return (lineIndex != JBLineChartLineSolid) ? 0.0: (kJBLineChartViewControllerChartDashedLineWidth * 4);
}

- (UIColor *)verticalSelectionColorForLineChartView:(JBLineChartView *)lineChartView
{
  return [UIColor whiteColor];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
  return (lineIndex != JBLineChartLineSolid) ? kJBColorLineChartDefaultSolidSelectedLineColor: kJBColorLineChartDefaultDashedSelectedLineColor;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
  return (lineIndex != JBLineChartLineSolid) ? kJBColorLineChartDefaultSolidSelectedLineColor: kJBColorLineChartDefaultDashedSelectedLineColor;
}

- (JBLineChartViewLineStyle)lineChartView:(JBLineChartView *)lineChartView lineStyleForLineAtLineIndex:(NSUInteger)lineIndex
{
  return (lineIndex != JBLineChartLineSolid) ? JBLineChartViewLineStyleSolid : JBLineChartViewLineStyleDashed;
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex
{
  return lineIndex != JBLineChartViewLineStyleDashed;
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex
{
  return lineIndex != JBLineChartViewLineStyleSolid;
}

#pragma mark - Buttons

- (void)chartToggleButtonPressed:(id)sender
{
	UIView *buttonImageView = [self.navigationItem.rightBarButtonItem valueForKey:kJBLineChartViewControllerNavButtonViewKey];
  buttonImageView.userInteractionEnabled = NO;
  
  CGAffineTransform transform = self.lineChartView.state == JBChartViewStateExpanded ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformMakeRotation(0);
  buttonImageView.transform = transform;
  
  [self.lineChartView setState:self.lineChartView.state == JBChartViewStateExpanded ? JBChartViewStateCollapsed : JBChartViewStateExpanded animated:YES callback:^{
    buttonImageView.userInteractionEnabled = YES;
  }];
}

#pragma mark - Overrides

- (JBChartView *)chartView
{
  return self.lineChartView;
}

@end
