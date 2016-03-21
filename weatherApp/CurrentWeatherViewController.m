//
//  FirstViewController.m
//  weatherApp
//
//  Created by Thomas Prezioso on 4/8/15.
//  Copyright (c) 2015 Tom Prezioso. All rights reserved.
//

#import "CurrentWeatherViewController.h"
#import "SearchNewLocationTableViewController.h"
#import <MBProgressHUD.h>
#import <UIColor+MLPFlatColors.h>
#import <CZWeatherLocation.h>
#import <CoreLocation/CoreLocation.h>

@interface CurrentWeatherViewController () <searchLocation>

@property (weak, nonatomic) IBOutlet UILabel *currentDate;
@property (weak, nonatomic) IBOutlet UILabel *forecastDescription;
@property (weak, nonatomic) IBOutlet UILabel *icon;
@property (weak, nonatomic) IBOutlet UILabel *tempeature;
@property (weak, nonatomic) IBOutlet UILabel *humidity;
@property (weak, nonatomic) IBOutlet UILabel *speed;
@property (weak, nonatomic) IBOutlet UILabel *currentWeatherLabel;
@property (strong, nonatomic) CurrentWeatherViewController *currentWeatherView;
@property (strong,nonatomic) NSString *cityLocation;
@property (strong, nonatomic) NSString *stateLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
- (IBAction)refreshCurrentLocation:(id)sender;

@end

@implementation CurrentWeatherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    self.currentWeatherLabel.text = @"Current Weather";
    self.navigationItem.title = @"Current Location";
    [self updateWeatherWithCurrentLocation];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)loadBackgroundColor
{
    NSNumber *number = @([self.tempeature.text intValue]);
    if ([number integerValue] >= [@75 integerValue]) {
        self.view.backgroundColor = [UIColor flatRedColor];
    } else if ([number integerValue] < [@60 integerValue]){
        self.view.backgroundColor = [UIColor flatBlueColor];
    } else {
        self.view.backgroundColor = [UIColor flatGreenColor];
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

#pragma mark FIX ME: Need to refactor all API calls into class
- (void)updateWeatherWithCurrentLocation
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   CLLocationCoordinate2D userCoordinate = self.locationManager.location.coordinate;
    [[NSUserDefaults standardUserDefaults] setFloat:userCoordinate.latitude forKey:@"lat"];
    [[NSUserDefaults standardUserDefaults] setFloat:userCoordinate.longitude forKey:@"lon"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    CZWeatherRequest *request = [CZOpenWeatherMapRequest newCurrentRequest];
    request.location = [CZWeatherLocation locationFromCoordinate:userCoordinate];
    request.key = @"71058b76658e6873dd5a4aca0d5aa161";
        [request sendWithCompletion:^(CZWeatherData *data, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                CZWeatherCurrentCondition *condition = data.current;
                [self convertConditionToLabelsForCondition:condition];
            }
            if (error) {
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Error"
                                                      message:@"No Internet Connection"
                                                      preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            });
        }];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)searchWithCityName:(NSString *)city andState:(NSString *)state
{
    CZWeatherRequest *request = [CZOpenWeatherMapRequest newCurrentRequest];
    request.location = [CZWeatherLocation locationFromCity:city state:state];
    request.key = @"71058b76658e6873dd5a4aca0d5aa161";
    [request sendWithCompletion:^(CZWeatherData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
        if (data) {
            CZWeatherCurrentCondition *current = data.current;
            [self convertConditionToLabelsForCondition:current];
            self.navigationItem.title = city;
            self.cityLocation = city;
            self.stateLocation = state;
        }
        if (error) {
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Error"
                                                  message:@"No Internet Connection"
                                                  preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        });
    }];
}

//- (void)updateWeather:(NSNotification *)weatherNotification
//{
//    NSString *city = (NSString*)[weatherNotification.userInfo objectForKey:@"city"];
//    NSString *state = (NSString*)[weatherNotification.userInfo objectForKey:@"state"];
//    CZWeatherRequest *request = [CZOpenWeatherMapRequest newCurrentRequest];
//    request.location = [CZWeatherLocation locationFromCity:city state:state];
//    request.key = @"71058b76658e6873dd5a4aca0d5aa161";
//    [request sendWithCompletion:^(CZWeatherData *data, NSError *error) {
//         dispatch_async(dispatch_get_main_queue(), ^{
//        if (data) {
//            CZWeatherCurrentCondition *current = data.current;
//            [self convertConditionToLabelsForCondition:current];
//            self.navigationItem.title = city;
//            self.cityLocation = city;
//            self.stateLocation = state;
//            if (error) {
//                UIAlertController *alertController = [UIAlertController
//                                                      alertControllerWithTitle:@"Error"
//                                                      message:@"No Internet Connection"
//                                                      preferredStyle:UIAlertControllerStyleAlert];
//                [self presentViewController:alertController animated:YES completion:nil];
//            }
//        }
//         });
//    }];
//}

- (void)convertConditionToLabelsForCondition:(CZWeatherCurrentCondition *)condition
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterFullStyle];
    NSString *dateString = [dateFormat stringFromDate:condition.date];
    if (self.condition) {
        self.tempeature.text = [NSString stringWithFormat:@"%0.f°",condition.temperature.f];
        [self loadBackgroundColor];
    } else {
        self.tempeature.text = [NSString stringWithFormat:@"%0.f°",condition.temperature.f];
        [self loadBackgroundColor];
        [UIApplication sharedApplication].applicationIconBadgeNumber = [[NSString stringWithFormat:@"%0.f°",condition.temperature.f] integerValue];
    }
    self.currentTemp = [NSString stringWithFormat:@"%0.f°", condition.temperature.f];
    self.currentDate.text = dateString;
    self.forecastDescription.text = condition.summary;
    self.icon.font =  [UIFont fontWithName:@"Climacons-Font" size:100];
    self.icon.text = [NSString stringWithFormat:@"%c", condition.climacon];
    self.humidity.text = [NSString stringWithFormat:@"%0.f",condition.humidity];
    self.speed.text = [NSString stringWithFormat:@"%0.f mph",condition.windSpeed.mph];
}

- (IBAction)refreshCurrentLocation:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self updateWeatherWithCurrentLocation];
    self.navigationItem.title = @"Current Location";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTableView" object:nil userInfo:nil];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
