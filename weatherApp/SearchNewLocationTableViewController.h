//
//  SearchNewLocationTableViewController.h
//  weatherApp
//
//  Created by Daniel Barabander on 4/8/15.
//  Copyright (c) 2015 Tom Prezioso. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol searchLocation <NSObject>
- (void)searchWithCityName:(NSString *)city andState:(NSString *)state;
@end

@interface SearchNewLocationTableViewController : UITableViewController
@property (nonatomic, weak) id<searchLocation>delegate;
@end
