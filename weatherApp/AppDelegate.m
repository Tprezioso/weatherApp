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
#import <AFNetworking/AFNetworking.h>
#import "ForcastAPIClient.h"

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
//    CurrentWeatherViewController *currentWeatherVC = [[CurrentWeatherViewController alloc] init];
//    [currentWeatherVC backgroundRefresh];
# pragma mark FIX ME
// add custom api call to do background refresh
    NSString *currenttemp = [[NSString alloc] init];
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];

    CLLocationCoordinate2D userCoordinate = locationManager.location.coordinate;
//    CZWeatherRequest *request = [CZOpenWeatherMapRequest newCurrentRequest];
//    request.location = [CZWeatherLocation locationFromCoordinate:userCoordinate];
//    request.key = @"71058b76658e6873dd5a4aca0d5aa161";
//    [NSOperationQueue mainQueue];
//    [request sendWithCompletion:^(CZWeatherData *data, NSError *error) {
//        NSString *temp = @"";
//        if (data) {
//            
//            CZWeatherCurrentCondition *condition = data.current;
//           temp = [NSString stringWithFormat:@"%0.f°",condition.temperature.f];
//            [currenttemp isEqualToString:temp];
//            completionHandler(UIBackgroundFetchResultNewData);
//        }
//        if (error) {
//            NSLog(@"%@", error.localizedDescription);
//            completionHandler(UIBackgroundFetchResultNoData);
//        }
//
//    }];
//    NSString *lat = [[NSString alloc] initWithFormat:@"%g", userCoordinate.latitude];
//    NSString *lon = [[NSString alloc] initWithFormat:@"%g", userCoordinate.longitude];
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSString *url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&APPID=71058b76658e6873dd5a4aca0d5aa161",lat, lon];
//    
//    [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) { completionHandler
//        (responseObject[@"daily"][@"data"]);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"ERROR: %@",error.localizedDescription);
//    }];
//
//    NSURLConnection *currentConnection;
//    NSMutableArray *weatherArray = [[NSMutableArray alloc] init];
//
//     NSString *weatherString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&APPID=71058b76658e6873dd5a4aca0d5aa161", lat ,lon];
//  
//    NSURL *weatherURL = [NSURL URLWithString:weatherString];
//    NSURLRequest *URLRequest = [NSURLRequest requestWithURL:weatherURL];
//    currentConnection = [[NSURLConnection alloc] initWithRequest:URLRequest delegate:self];
//    NSURLRequest *weatherRequest = [[NSURLRequest alloc] initWithURL:weatherURL];
    [ForcastAPIClient getForecastForCoordinateCompletion:^(NSArray *currentForcast) {
        NSDictionary *currentWeather = currentForcast[1];
        NSString *temperature = [NSString stringWithFormat:@"%@", currentWeather[@"temperature"]];
        [currenttemp isEqualToString:temperature];
    }];
    
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];

    localNotification.applicationIconBadgeNumber = [currenttemp integerValue];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
