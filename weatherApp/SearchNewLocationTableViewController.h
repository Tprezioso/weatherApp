//
//  SearchNewLocationTableViewController.h
//  weatherApp
//
//  Created by Thomas Prezioso on 4/8/15.
//  Copyright (c) 2015 Tom Prezioso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sevenDayForecastViewController.h"

@protocol searchLocation <NSObject>

- (void)searchWithCityName:(NSString *)city andState:(NSString *)state;

@end

@interface SearchNewLocationTableViewController : UITableViewController

@property (nonatomic, weak) id <searchLocation> delegate;
@property (nonatomic) BOOL didSevenDayOneTime;


@end
