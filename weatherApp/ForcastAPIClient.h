//
//  ForcastAPIClient.h
//  weatherApp
//
//  Created by Thomas Prezioso on 2/12/16.
//  Copyright © 2016 Tom Prezioso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ForcastAPIClient : NSObject

+ (void)getForecastForCoordinateCompletion:(void (^)(NSArray *))completion;

@end
