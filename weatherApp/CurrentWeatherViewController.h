//
//  FirstViewController.h
//  weatherApp
//
//  Created by Thomas Prezioso on 4/8/15.
//  Copyright (c) 2015 Tom Prezioso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZWeatherKit.h"
#import "SwipeProtocol.h"


@interface CurrentWeatherViewController : UIViewController
@property (nonatomic) CZWeatherCondition *condition;
@property (nonatomic, weak) id<SwipeProtocol>delegate;


@end

