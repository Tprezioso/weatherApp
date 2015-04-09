//
//  SwipeBetweenViews.h
//  weatherApp
//
//  Created by Thomas Prezioso on 4/8/15.
//  Copyright (c) 2015 Tom Prezioso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "SwipeProtocol.h"


@interface SwipeBetweenViews : NSObject<SwipeProtocol>

@property (nonatomic) AppDelegate *appDelegate;

- (void)addSwipedRightGesture:(UIViewController *)viewcontroller;
- (void)addSwipedLeftGesture:(UIViewController *)viewcontroller;

//- (void)swipingInGeneral:(UIViewController *)thing;
//- (void)swipedLeftGesture;
//- (void)swipedRightGesture;

@end
