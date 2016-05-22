//
//  SecondViewController.m
//  weatherApp
//
//  Created by Thomas Prezioso on 4/8/15.
//  Copyright (c) 2015 Tom Prezioso. All rights reserved.
//

#import "sevenDayForecastViewController.h"
#import "SevenDayDetailViewController.h"
#import "CZWeatherKit.h"
#import <MBProgressHUD.h>
#import <UIColor+MLPFlatColors.h>
#import <CoreLocation/CoreLocation.h>

@interface sevenDayForecastViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *forecastArray;
@property (weak, nonatomic) IBOutlet UILabel *citySevenDayLabel;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation sevenDayForecastViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.locationManager = [[CLLocationManager alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWeather:) name:@"weatherSearch" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestTenDayForecast:) name:@"reloadTableView" object:nil];
    [self requestTenDayForecast:nil];
    self.citySevenDayLabel.text = @"7 Day Forecast";
    self.citySevenDayLabel.textColor = [UIColor whiteColor];
    self.navigationItem.title = @"Current Location";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.view.backgroundColor = [UIColor flatWhiteColor];
    self.tableView.backgroundColor = [UIColor flatTealColor];
    self.view.backgroundColor = [UIColor flatDarkTealColor];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)loadCellColor:(UITableViewCell *)cell
{
    NSNumber *number = @([cell.detailTextLabel.text intValue]);
    if ([number doubleValue] >= [@75 doubleValue]) {
        cell.backgroundColor = [UIColor flatRedColor];
    } else if ([number doubleValue] < [@60 doubleValue]){
        cell.backgroundColor = [UIColor flatBlueColor];
    } else {
        cell.backgroundColor = [UIColor flatGreenColor];
    }
}

- (void)updateWeather:(NSNotification *)weatherNotification
{
    NSString *city = (NSString*)[weatherNotification.userInfo objectForKey:@"city"];
    NSString *state = (NSString*)[weatherNotification.userInfo objectForKey:@"state"];
    CZWeatherRequest *request = [CZOpenWeatherMapRequest newDailyForecastRequestForDays:7];
    request.location = [CZWeatherLocation locationFromCity:city state:state];
    request.key = @"71058b76658e6873dd5a4aca0d5aa161";
    [request sendWithCompletion:^(CZWeatherData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                self.forecastArray = (NSArray *)data.dailyForecasts;
                self.navigationItem.title = city;
                [self.tableView reloadData];
            }
            if (error) {
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Error"
                                                                       message:@"No Internet Connection"
                                                                preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *refreshAction = [UIAlertAction
                                                actionWithTitle:@"Retry"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action)
                                                        {
                                                            [self requestTenDayForecast:nil];
                                                        }];

                [alertController addAction:refreshAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        });
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZWeatherForecastCondition *condition = self.forecastArray[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"defaultCell"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterFullStyle];
    NSString *dateString = [dateFormat stringFromDate:condition.date];
    cell.textLabel.text = dateString;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.f°",condition.highTemperature.f];
    cell.detailTextLabel.textColor=[UIColor whiteColor];
    cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self loadCellColor:cell];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailSevenView"]) {
        SevenDayDetailViewController *detailVC = segue.destinationViewController;
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        detailVC.condition = self.forecastArray[selectedIndexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"detailSevenView" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)requestTenDayForecast:(NSNotificationCenter *)notification
{
    CLLocationCoordinate2D userCoordinate = self.locationManager.location.coordinate;
    CZWeatherRequest *request = [CZOpenWeatherMapRequest newDailyForecastRequestForDays:7];
    request.location = [CZWeatherLocation locationFromCoordinate:userCoordinate];
    request.key = @"71058b76658e6873dd5a4aca0d5aa161";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [request sendWithCompletion:^(CZWeatherData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                self.forecastArray = (NSArray *)data.dailyForecasts;
                [self.tableView reloadData];
                self.navigationItem.title = @"Current Location";
                [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
            }
            if (error) {
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Error"
                                                                       message:@"No Internet Connection"
                                                                preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *refreshAction = [UIAlertAction
                                                    actionWithTitle:@"Retry"
                                                    style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action)
                                                    {
                                                        [self requestTenDayForecast:nil];
                                                    }];

                    [alertController addAction:refreshAction];
                    [self presentViewController:alertController animated:YES completion:nil];
            }
            
        });
    }];
   [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
