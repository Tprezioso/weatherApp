//
//  SevenDayDetailViewController.h
//  weatherApp
//
//  Created by Thomas Prezioso on 4/11/15.
//  Copyright (c) 2015 Tom Prezioso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CZWeatherKit.h>

@interface SevenDayDetailViewController : UIViewController
@property (nonatomic) CZWeatherCondition *condition;
@end
