//
//  SwipeBetweenViews.m
//  weatherApp
//
//  Created by Thomas Prezioso on 4/8/15.
//  Copyright (c) 2015 Tom Prezioso. All rights reserved.
//

#import "SwipeBetweenViews.h"
#import "CurrentWeatherViewController.h"

@interface SwipeBetweenViews()
@end

@implementation SwipeBetweenViews

- (void)addSwipedRightGesture:(CurrentWeatherViewController *)viewcontroller 
{
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:viewcontroller action:@selector(didSwipeRight)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [viewcontroller.view    addGestureRecognizer:swipeRight];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
}

- (void)addSwipedLeftGesture:(CurrentWeatherViewController *)viewcontroller
{
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:viewcontroller action:@selector(didSwipeLeft)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [viewcontroller.view addGestureRecognizer:swipeLeft];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
}

- (void)swipedRightGesture
{
    NSUInteger selectedIndex = [self.appDelegate.tabBarController selectedIndex];
    
    [self.appDelegate.tabBarController setSelectedIndex:selectedIndex + 1];
}

- (void)swipedLeftGesture
{
    NSUInteger selectedIndex = [self.appDelegate.tabBarController selectedIndex];
    
    [self.appDelegate.tabBarController setSelectedIndex:selectedIndex - 1];
}



//- (void)swipingInGeneral:(UIViewController *)thing {
//    
//    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:thing action:@selector(swipedLeftGesture)];
//    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
//    [thing.view addGestureRecognizer:swipeLeft];
//    
//    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:thing action:@selector(swipedLeftGesture)];
//    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
//    [thing.view addGestureRecognizer:swipeRight];
//    self.appDelegate = [[UIApplication sharedApplication] delegate];
//    
//}
//
//- (void)swipedLeftGesture
//{
//    NSUInteger selectedIndex = [self.appDelegate.tabBarController selectedIndex];
//    
//    [self.appDelegate.tabBarController setSelectedIndex:selectedIndex - 1];
//}
//
//- (void)swipedRightGesture
//{
//    NSUInteger selectedIndex = [self.appDelegate.tabBarController selectedIndex];
//    
//    [self.appDelegate.tabBarController setSelectedIndex:selectedIndex + 1];
//}
@end
