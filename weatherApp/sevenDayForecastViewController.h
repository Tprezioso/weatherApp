//
//  SecondViewController.h
//  weatherApp
//
//  Created by Thomas Prezioso on 4/8/15.
//  Copyright (c) 2015 Tom Prezioso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CZWeatherKit.h>

@interface sevenDayForecastViewController : UIViewController

@property (nonatomic) CZWeatherCurrentCondition *condition;
@property (strong, nonatomic)NSDictionary *cityStateForload;

@end

