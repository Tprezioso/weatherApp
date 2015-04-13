//
//  FirstViewController.m
//  weatherApp
//
//  Created by Thomas Prezioso on 4/8/15.
//  Copyright (c) 2015 Tom Prezioso. All rights reserved.
//

#import "CurrentWeatherViewController.h"
#import "SearchNewLocationTableViewController.h"
#import "SwipeBetweenViews.h"
#import <MBProgressHUD.h>
#import <UIColor+MLPFlatColors.h>

@interface CurrentWeatherViewController ()<searchLocation>
@property (weak, nonatomic) IBOutlet UILabel *currentDate;
@property (weak, nonatomic) IBOutlet UILabel *forecastDescription;
@property (weak, nonatomic) IBOutlet UILabel *icon;
@property (weak, nonatomic) IBOutlet UILabel *tempeature;
@property (weak, nonatomic) IBOutlet UILabel *humidity;
@property (weak, nonatomic) IBOutlet UILabel *speed;
@property (nonatomic) AppDelegate *appDelegate;

@property(strong, nonatomic)CurrentWeatherViewController *currentWeatherView;
@property (weak, nonatomic) IBOutlet UILabel *currentWeatherLabel;
@property (strong,nonatomic) NSString *cityLocation;
@end

@implementation CurrentWeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.condition) {
        [self convertConditionToLabelsForCondition:self.condition];
       
    } else {
        [self searchWithCityName:@"New York" andState:@"NY"];
        
    }

//    SwipeBetweenViews *swipeHelper = [[SwipeBetweenViews alloc]init];
//    
//    self.delegate = swipeHelper;
    
//    [swipeHelper addSwipedLeftGesture:self];
//    [swipeHelper addSwipedRightGesture:self];
    
//    SwipeBetweenViews *test = [[SwipeBetweenViews alloc] init];
//    [test swipingInGeneral:self];

    
    
    self.currentWeatherLabel.text = @"Current Weather";
    self.navigationItem.title = @"New York";
    
}

-(void)loadBackgroundColor{
   
    
    NSNumber *number = @([self.tempeature.text intValue]);
  
    if (number >= @75 ) {
        
        self.view.backgroundColor = [UIColor flatRedColor];
        
    }else if (number < @60){
        
        self.view.backgroundColor = [UIColor flatBlueColor];
        
    }else{
        
        self.view.backgroundColor = [UIColor flatGreenColor];
    }
    
}
- (void)didSwipeRight
{
    [self.delegate swipedRightGesture];
    NSLog(@"right");
    
}

- (void)didSwipeLeft
{
    [self.delegate swipedLeftGesture];
    
    
    NSLog(@"left");

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueToSearchNav"]) {
        UINavigationController *navController = [segue destinationViewController];
        SearchNewLocationTableViewController *searchLocationViewController = (SearchNewLocationTableViewController *)([navController viewControllers][0]);
        searchLocationViewController.delegate = self;
    }
}

- (void)searchWithCityName:(NSString *)city andState:(NSString *)state
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.location = [CZWeatherLocation locationWithCity:city state:state];
    request.service = [CZOpenWeatherMapService serviceWithKey:@"71058b76658e6873dd5a4aca0d5aa161"];
    [request performRequestWithHandler:^(id data, NSError *error) {
        if (data) {
            CZWeatherCondition *current = (CZWeatherCondition *)data;
            [self convertConditionToLabelsForCondition:current];
            self.navigationItem.title = city;
            
            self.cityLocation = city;
        
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (error) {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Error" message:@"No Internet Connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    }];
}

- (void)convertConditionToLabelsForCondition:(CZWeatherCondition *)condition
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormat stringFromDate:condition.date];
    
    if (self.condition) {
        self.tempeature.text = [NSString stringWithFormat:@"%0.f°",condition.highTemperature.f];
        [self loadBackgroundColor];
    } else {
        self.tempeature.text = [NSString stringWithFormat:@"%0.f°",condition.temperature.f];
   [self loadBackgroundColor];
    }
    
    
    
    self.currentDate.text = dateString;
    self.forecastDescription.text = condition.summary;
   
    self.icon.font =  [UIFont fontWithName:@"Climacons-Font" size:100];
    self.icon.text = [NSString stringWithFormat:@"%c", condition.climaconCharacter];
    
    
    self.humidity.text = [NSString stringWithFormat:@"%0.f",condition.humidity];
    self.speed.text = [NSString stringWithFormat:@"%0.f mph",condition.windSpeed.mph];
}

@end
