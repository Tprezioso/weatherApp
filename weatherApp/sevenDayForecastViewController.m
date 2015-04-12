//
//  SecondViewController.m
//  weatherApp
//
//  Created by Thomas Prezioso on 4/8/15.
//  Copyright (c) 2015 Tom Prezioso. All rights reserved.
//

#import "sevenDayForecastViewController.h"
#import "CurrentWeatherViewController.h"
#import "CZWeatherKit.h"
#import "SwipeBetweenViews.h"
#import <MBProgressHUD.h>
#import "SearchNewLocationTableViewController.h"
#import "SevenDayDetailViewController.h"


@interface sevenDayForecastViewController ()<UITableViewDelegate, UITableViewDataSource,searchLocation>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *forecastArray;
@property(strong,nonatomic) sevenDayForecastViewController *sevenDayView;
@property (weak, nonatomic) IBOutlet UILabel *citySevenDayLabel;
@end

@implementation sevenDayForecastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self requestTenDayForecast];
    if (self.condition) {
        [self requestTenDayForecast];
    } else {
        [self searchWithCityName:@"New York" andState:@"NY"];
    }

    
//    SwipeBetweenViews *testing = [[SwipeBetweenViews alloc] init];
//    [testing swipingInGeneral:self];
    
//    SwipeBetweenViews *swipeRight = [[SwipeBetweenViews alloc]init];
//    SwipeBetweenViews *swipeLeft = [[SwipeBetweenViews alloc]init];
//    
//    [swipeRight addSwipedRightGesture:self];
//    [swipeLeft addSwipedLeftGesture:self];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWeather:) name:@"weatherSearch" object:nil];
self.citySevenDayLabel.text = @"7 day Forecast";
self.navigationItem.title = @"New York";

}
-(void)updateWeather:(NSNotification *)weatherNotification {
    
    NSString *city = (NSString*)[weatherNotification.userInfo objectForKey:@"city"];
    NSString *state = (NSString*)[weatherNotification.userInfo objectForKey:@"state"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZForecastRequestType];
    request.location = [CZWeatherLocation locationWithCity:city state:state];
    request.service = [CZOpenWeatherMapService serviceWithKey:@"71058b76658e6873dd5a4aca0d5aa161"];
    request.detailLevel = CZWeatherRequestFullDetail;
    [request performRequestWithHandler:^(id data, NSError *error) {
        if (data) {
            self.forecastArray = (NSArray *)data;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.navigationItem.title = city;
                
                [self.tableView reloadData];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }];
        }
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.forecastArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZWeatherCondition *condition = self.forecastArray[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"defaultCell"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormat stringFromDate:condition.date];

    cell.textLabel.text = dateString;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.f°",condition.highTemperature.f];
    cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"detailSevenView"]) {
        
    SevenDayDetailViewController *detailVC = segue.destinationViewController;
    
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    
    
    detailVC.condition = self.forecastArray[selectedIndexPath.row];

        
    }
    
    
   }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CZWeatherCondition *condition = self.forecastArray[indexPath.row];
//    CurrentWeatherViewController *currentWeatherVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"currentWeatherVC"];
//    currentWeatherVC.condition = condition;
//
//    
//    [self.navigationController pushViewController:currentWeatherVC animated:YES];

  //  CZWeatherCondition *condition = [self.forecastArray objectAtIndex:indexPath.row];
    
[self performSegueWithIdentifier:@"detailSevenView" sender:self];


}

- (void)searchWithCityName:(NSString *)city andState:(NSString *)state
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZForecastRequestType];
    request.location = [CZWeatherLocation locationWithCity:city state:state];
    request.service = [CZOpenWeatherMapService serviceWithKey:@"71058b76658e6873dd5a4aca0d5aa161"];
    request.detailLevel = CZWeatherRequestFullDetail;
    [request performRequestWithHandler:^(id data, NSError *error) {
        if (data) {
            self.forecastArray = (NSArray *)data;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadData];
        
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            }];
        }
    }];
}

- (void)requestTenDayForecast
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZForecastRequestType];
    request.location = [CZWeatherLocation locationWithCity:@"New York" state:@"NY"];
    request.service = [CZOpenWeatherMapService serviceWithKey:@"71058b76658e6873dd5a4aca0d5aa161"];
    request.detailLevel = CZWeatherRequestFullDetail;
    [request performRequestWithHandler:^(id data, NSError *error) {
        if (data) {
            self.forecastArray = (NSArray *)data;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadData];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }];
        }
    }];
}



@end
