//
//  FirstViewController.h
//  weatherApp
//
//  Created by Daniel Barabander on 4/8/15.
//  Copyright (c) 2015 Tom Prezioso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZWeatherKit.h"

@interface CurrentWeatherViewController : UIViewController
@property (nonatomic) CZWeatherCondition *condition;
@end

