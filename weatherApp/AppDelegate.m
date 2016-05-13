//
//  AppDelegate.m
//  weatherApp
//
//  Created by Daniel Barabander on 4/8/15.
//  Copyright (c) 2015 Tom Prezioso. All rights reserved.
//

#import "AppDelegate.h"
#import "CurrentWeatherViewController.h"
#import <CZWeatherKit/CZWeatherKit.h>

@interface AppDelegate () <NSURLConnectionDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    self.tabBarController = (UITabBarController *)self.window.rootViewController;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    return true;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    CLLocationCoordinate2D userCoordinate = locationManager.location.coordinate;
    userCoordinate.longitude = [[NSUserDefaults standardUserDefaults] floatForKey:@"lon"];
    userCoordinate.latitude = [[NSUserDefaults standardUserDefaults] floatForKey:@"lat"];
    CZWeatherRequest *request = [CZOpenWeatherMapRequest newCurrentRequest];
    request.location = [CZWeatherLocation locationFromCoordinate:userCoordinate];
    request.key = @"71058b76658e6873dd5a4aca0d5aa161";
    [request sendWithCompletion:^(CZWeatherData *data, NSError *error) {
      if (data) {
          CZWeatherCurrentCondition *condition = data.current;
          [UIApplication sharedApplication].applicationIconBadgeNumber = [[NSString stringWithFormat:@"%f°",condition.temperature.f] integerValue];
        }
        completionHandler(UIBackgroundFetchResultNewData);
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
