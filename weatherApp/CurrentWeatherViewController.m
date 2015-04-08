//
//  FirstViewController.m
//  weatherApp
//
//  Created by Daniel Barabander on 4/8/15.
//  Copyright (c) 2015 Tom Prezioso. All rights reserved.
//

#import "CurrentWeatherViewController.h"
#import "CZWeatherKit.h"

@interface CurrentWeatherViewController ()
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
    [self requestCurrentConditions];
}

- (void)requestCurrentConditions
{
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.location = [CZWeatherLocation locationWithCity:@"New York" state:@"NY"];
    request.service = [CZOpenWeatherMapService serviceWithKey:@"71058b76658e6873dd5a4aca0d5aa161"];
    [request performRequestWithHandler:^(id data, NSError *error) {
        if (data) {
            CZWeatherCondition *current = (CZWeatherCondition *)data;
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateStyle:NSDateFormatterShortStyle];
            NSString *dateString = [dateFormat stringFromDate:current.date];
            
            self.currentDate.text = dateString;
            self.forecastDescription.text = current.summary;
            self.icon.text = [NSString stringWithFormat:@"%c", current.climaconCharacter];
            self.tempeature.text = [NSString stringWithFormat:@"%f",current.temperature.c];
            self.humidity.text = [NSString stringWithFormat:@"%f",current.humidity];
            self.speed.text = [NSString stringWithFormat:@"%f",current.windSpeed.mph];
        }
    }];

}
@end
