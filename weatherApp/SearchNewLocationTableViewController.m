//
//  SearchNewLocationTableViewController.m
//  weatherApp
//
//  Created by Thomas Prezioso on 4/8/15.
//  Copyright (c) 2015 Tom Prezioso. All rights reserved.
//

#import "SearchNewLocationTableViewController.h"
#import <UIColor+MLPFlatColors.h>

@interface SearchNewLocationTableViewController ()<UIPickerViewDataSource, UIPickerViewAccessibilityDelegate>

@property (nonatomic) UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *cityTextfield;
@property (weak, nonatomic) IBOutlet UITextField *stateTextfield;
@property (nonatomic) NSArray *array;

@end

@implementation SearchNewLocationTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.array = @[@"AL", @"AK", @"AZ", @"AR", @"CA", @"CO", @"CT", @"DE", @"FL", @"GA", @"HI", @"ID", @"IL", @"IN", @"IA", @"KS", @"KY", @"LA", @"ME", @"MD", @"MA", @"MI", @"MN", @"MS", @"MO", @"MT", @"NE", @"NV", @"NH", @"NJ", @"NM", @"NY", @"NC", @"ND", @"OH", @"OK", @"OR", @"PA", @"RI", @"SC", @"SD", @"TN", @"TX", @"UT", @"VT", @"VA", @"WA", @"WV", @"WI", @"WY"];
    self.stateTextfield.inputView = self.pickerView;
    self.view.backgroundColor = [UIColor flatYellowColor];
    self.pickerView.backgroundColor = [UIColor flatDarkYellowColor];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.array.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.array[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.stateTextfield.text = self.array[row];
}

- (IBAction)findWeatherTapped:(id)sender
{
    [self.delegate searchWithCityName:self.cityTextfield.text andState:self.stateTextfield.text];
//    NSMutableDictionary *cityState = [[NSMutableDictionary alloc]init];
//    cityState [@"city"] = self.cityTextfield.text;
//    cityState [@"state"] = self.stateTextfield.text;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"weatherSearch" object:nil userInfo:cityState];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
