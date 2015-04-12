//
//  SevenDayDetailViewController.m
//  weatherApp
//
//  Created by Thomas Prezioso on 4/11/15.
//  Copyright (c) 2015 Tom Prezioso. All rights reserved.
//

#import "SevenDayDetailViewController.h"
#import "sevenDayForecastViewController.h"

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLabel];
    
}
-(void)setLabel{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormat stringFromDate:self.condition.date];
    
    self.tempertureLabel.text = [NSString stringWithFormat:@"%0.f°",self.condition.highTemperature.f];
    self.lowTempLabel.text = [NSString stringWithFormat:@"%0.f°", self.condition.lowTemperature.f];
    
    self.summaryLabel.text = self.condition.summary;
    self.dateLabel.text = dateString;
   
    self.climaconLabel.font =  [UIFont fontWithName:@"Climacons-Font" size:100];
    self.climaconLabel.text = [NSString stringWithFormat:@"%c", self.condition.climaconCharacter];
    
    self.humitityLabel.text = [NSString stringWithFormat:@"%0.f",self.condition.humidity];
    self.windSpeedLabel.text = [NSString stringWithFormat:@"%0.f mph",self.condition.windSpeed.mph];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
