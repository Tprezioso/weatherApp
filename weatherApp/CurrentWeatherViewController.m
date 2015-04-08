//
//  FirstViewController.m
//  weatherApp
//
//  Created by Daniel Barabander on 4/8/15.
//  Copyright (c) 2015 Tom Prezioso. All rights reserved.
//

#import "CurrentWeatherViewController.h"
#import "SearchNewLocationTableViewController.h"

@interface CurrentWeatherViewController ()<searchLocation>
@property (weak, nonatomic) IBOutlet UILabel *currentDate;
@property (weak, nonatomic) IBOutlet UILabel *forecastDescription;
@property (weak, nonatomic) IBOutlet UILabel *icon;
@property (weak, nonatomic) IBOutlet UILabel *tempeature;
@property (weak, nonatomic) IBOutlet UILabel *humidity;
@property (weak, nonatomic) IBOutlet UILabel *speed;

@end

@implementation CurrentWeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.condition) {
        [self convertConditionToLabelsForCondition:self.condition];
    } else {
        [self searchWithCityName:@"New York" andState:@"NY"];
    }
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
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.location = [CZWeatherLocation locationWithCity:city state:state];
    request.service = [CZOpenWeatherMapService serviceWithKey:@"71058b76658e6873dd5a4aca0d5aa161"];
    [request performRequestWithHandler:^(id data, NSError *error) {
        if (data) {
            CZWeatherCondition *current = (CZWeatherCondition *)data;
            [self convertConditionToLabelsForCondition:current];
        }
    }];
}

- (void)convertConditionToLabelsForCondition:(CZWeatherCondition *)condition
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormat stringFromDate:condition.date];
    
    if (self.condition) {
        self.tempeature.text = [NSString stringWithFormat:@"%f",condition.highTemperature.f];
    } else {
        self.tempeature.text = [NSString stringWithFormat:@"%f",condition.temperature.f];
    }
    self.currentDate.text = dateString;
    self.forecastDescription.text = condition.summary;
   
    self.icon.font =  [UIFont fontWithName:@"Climacons-Font" size:100];
    self.icon.text = [NSString stringWithFormat:@"%c", condition.climaconCharacter];
    
    
    self.humidity.text = [NSString stringWithFormat:@"%f",condition.humidity];
    self.speed.text = [NSString stringWithFormat:@"%f",condition.windSpeed.mph];
}

@end
