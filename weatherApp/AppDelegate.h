//
//  AppDelegate.h
//  weatherApp
//
//  Created by Daniel Barabander on 4/8/15.
//  Copyright (c) 2015 Tom Prezioso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
