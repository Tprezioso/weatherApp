//
//  SevenDayDetailViewController.m
//  weatherApp
//
//  Created by Thomas Prezioso on 4/11/15.
//  Copyright (c) 2015 Tom Prezioso. All rights reserved.
//

#import "SevenDayDetailViewController.h"
#import "sevenDayForecastViewController.h"
#import <UIColor+MLPFlatColors.h>

@interface SevenDayDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *climaconLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempertureLabel;
@property (weak, nonatomic) IBOutlet UILabel *humitityLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowTempLabel;

@end

@implementation SevenDayDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLabel];
}

- (void)setLabel
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:kCFDateFormatterFullStyle];
    NSString *dateString = [dateFormat stringFromDate:self.condition.date];
    self.tempertureLabel.text = [NSString stringWithFormat:@"%0.f°", self.condition.highTemperature.f];
    self.lowTempLabel.text = [NSString stringWithFormat:@"%0.f°", self.condition.lowTemperature.f];
    self.summaryLabel.text = self.condition.summary;
    self.dateLabel.text = dateString;
    self.climaconLabel.font =  [UIFont fontWithName:@"Climacons-Font" size:100];
    self.climaconLabel.text = [NSString stringWithFormat:@"%c", self.condition.climacon];
    self.humitityLabel.text = [NSString stringWithFormat:@"%0.f",self.condition.humidity];
    self.windSpeedLabel.text = @"N/A";
    [self loadBackgroundColor];
}

- (void)loadBackgroundColor
{
    NSNumber *number = @([self.tempertureLabel.text intValue]);
    if (number >= @75 ) {
        self.view.backgroundColor = [UIColor flatRedColor];
    } else if (number < @60) {
        self.view.backgroundColor = [UIColor flatBlueColor];
    } else {
        self.view.backgroundColor = [UIColor flatGreenColor];
    }
}

@end
