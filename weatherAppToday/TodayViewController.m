//
//  TodayViewController.m
//  weatherAppToday
//
//  Created by Thomas Prezioso on 8/8/15.
//  Copyright (c) 2015 Tom Prezioso. All rights reserved.
//

#import "TodayViewController.h"
//<<<<<<< HEAD
//=======
//#import "CurrentWeatherViewController.h"
//>>>>>>> bd7113df8cb443f8ba3bb473f658fe655a1742ea
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

//<<<<<<< HEAD
//=======
//@property (strong, nonatomic) IBOutlet UILabel *tempLabel;

//>>>>>>> bd7113df8cb443f8ba3bb473f658fe655a1742ea
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//<<<<<<< HEAD
//=======
   
//    CurrentWeatherViewController *currentWeather = currentWeather;
//    self.tempLabel.text = currentWeather;
//>>>>>>> bd7113df8cb443f8ba3bb473f658fe655a1742ea
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
