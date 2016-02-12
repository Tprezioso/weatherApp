//
//  ForcastAPIClient.m
//  weatherApp
//
//  Created by Thomas Prezioso on 2/12/16.
//  Copyright © 2016 Tom Prezioso. All rights reserved.
//

#import "ForcastAPIClient.h"
#import <AFNetworking.h>

@implementation ForcastAPIClient

+ (void)getForecastForCoordinateCompletion:(void (^)(NSArray *))completion
{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    
    CLLocationCoordinate2D userCoordinate = locationManager.location.coordinate;
    NSString *lat = [[NSString alloc] initWithFormat:@"%g", userCoordinate.latitude];
    NSString *lon = [[NSString alloc] initWithFormat:@"%g", userCoordinate.longitude];
    

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"https://api.forecast.io/forecast/12f5147f5379a5fab6339c5d97f21b6b/%@,%@",lat, lon];
    
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(responseObject[@"hourly"][@"data"]);
        NSLog(@"%@@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"ERROR: %@",error.localizedDescription);
    }];
}


@end
