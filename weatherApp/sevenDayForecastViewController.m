//
//  SecondViewController.m
//  weatherApp
//
//  Created by Thomas Prezioso on 4/8/15.
//  Copyright (c) 2015 Tom Prezioso. All rights reserved.
//

#import "sevenDayForecastViewController.h"
#import "SearchNewLocationTableViewController.h"
#import "SevenDayDetailViewController.h"
#import "CZWeatherKit.h"
#import <MBProgressHUD.h>
#import <UIColor+MLPFlatColors.h>
#import <CoreLocation/CoreLocation.h>

@interface sevenDayForecastViewController ()<UITableViewDelegate, UITableViewDataSource,searchLocation>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *forecastArray;
@property (weak, nonatomic) IBOutlet UILabel *citySevenDayLabel;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation sevenDayForecastViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.locationManager = [[CLLocationManager alloc] init];
    [self requestTenDayForecast:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWeather:) name:@"weatherSearch" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestTenDayForecast:) name:@"reloadTableView" object:nil];
    self.citySevenDayLabel.text = @"7 Day Forecast";
    self.navigationItem.title = @"Current Location";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.view.backgroundColor = [UIColor flatWhiteColor];
    self.tableView.backgroundColor = [UIColor flatWhiteColor];
}

- (void)loadCellColor:(UITableViewCell *)cell
{
    NSNumber *number = @([cell.detailTextLabel.text intValue]);
    if (number >= @75 ) {
        cell.backgroundColor = [UIColor flatRedColor];
    } else if (number < @60){
        cell.backgroundColor = [UIColor flatBlueColor];
    } else {
        cell.backgroundColor = [UIColor flatGreenColor];
    }
}

- (void)updateWeather:(NSNotification *)weatherNotification
{
    NSString *city = (NSString*)[weatherNotification.userInfo objectForKey:@"city"];
    NSString *state = (NSString*)[weatherNotification.userInfo objectForKey:@"state"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    CZWeatherRequest *request = [CZOpenWeatherMapRequest newDailyForecastRequestForDays:7];
    request.location = [CZWeatherLocation locationFromCity:city state:state];
    request.key = @"71058b76658e6873dd5a4aca0d5aa161";
    [request sendWithCompletion:^(CZWeatherData *data, NSError *error) {
    if (data) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.forecastArray = (NSArray *)data.dailyForecasts;
        self.navigationItem.title = city;
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (error) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Error"
                                              message:@"No Internet Connection"
                                              preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
    }
        }];
    }
    }];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    [dateFormat setDateStyle:kCFDateFormatterFullStyle];
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

- (void)searchWithCityName:(NSString *)city andState:(NSString *)state
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    CZWeatherRequest *request =[CZOpenWeatherMapRequest newDailyForecastRequestForDays:7];
    request.location = [CZWeatherLocation locationFromCity:city state:state];
    request.key = @"71058b76658e6873dd5a4aca0d5aa161";
    [request sendWithCompletion:^(CZWeatherData *data, NSError *error) {
        if (data) {
            self.forecastArray = (NSArray *)data.dailyForecasts;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
                if (error) {
                    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Error" message:@"No Internet Connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert show];
                }
            }];
        }
    }];
   [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)requestTenDayForecast:(NSNotificationCenter *)notification
{
    CLLocationCoordinate2D userCoordinate = self.locationManager.location.coordinate;
   [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    CZWeatherRequest *request = [CZOpenWeatherMapRequest newDailyForecastRequestForDays:7];
    request.location = [CZWeatherLocation locationFromCoordinate:userCoordinate];
    request.key = @"71058b76658e6873dd5a4aca0d5aa161";
    [request sendWithCompletion:^(CZWeatherData *data, NSError *error) {
        if (data) {
            self.forecastArray = (NSArray *)data.dailyForecasts;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadData];
                self.navigationItem.title = @"Current Location";
                if (error) {
                    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Error" message:@"No Internet Connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert show];
                }
            }];
        }
    }];
   [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
