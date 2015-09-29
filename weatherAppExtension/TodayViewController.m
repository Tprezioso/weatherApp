//
//  TodayViewController.m
//  weatherAppExtension
//
//  Created by Thomas Prezioso on 8/8/15.
//  Copyright (c) 2015 Tom Prezioso. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "CurrentWeatherViewController.h"


@interface TodayViewController () <NCWidgetProviding>
@property (strong, nonatomic) IBOutlet UILabel *currentTempLabel;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   // self.currentTempLabel.text = [CurrentWeatherViewController ]
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    CurrentWeatherViewController *current = [[CurrentWeatherViewController alloc]init];
    self.currentTempLabel.text = current.currentWeather;
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
