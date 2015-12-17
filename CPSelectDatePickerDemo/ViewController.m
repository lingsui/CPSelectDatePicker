//
//  ViewController.m
//  CPSelectDatePickerDemo
//
//  Created by caoping on 15/12/17.
//  Copyright © 2015年 caoping. All rights reserved.
//

#import "ViewController.h"
#import "CPSelectDatePicker.h"

@interface ViewController ()

@property (nonatomic,strong)CPSelectDatePicker *selectDatePicker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sysStyle1:(id)sender {
    _selectDatePicker = [[CPSelectDatePicker alloc]init];
    _selectDatePicker.selectDatePickerMode = CPSelectDatePickerModeCountDownTimer;
    [_selectDatePicker didFinishSelectedDate:^(NSDate *selectDateTime) {
       
        NSLog(@"---------%@-----------",selectDateTime);
        
    }];
    
}
- (IBAction)sysStyle2:(id)sender {
    _selectDatePicker = [[CPSelectDatePicker alloc]init];
    _selectDatePicker.selectDatePickerMode = CPSelectDatePickerModeDate;
    [_selectDatePicker didFinishSelectedDate:^(NSDate *selectDateTime) {
        
        NSLog(@"---------%@-----------",selectDateTime);
        
    }];
}
- (IBAction)sysStyle3:(id)sender {
    _selectDatePicker = [[CPSelectDatePicker alloc]init];
    _selectDatePicker.selectDatePickerMode = CPSelectDatePickerModeDateAndTime;
    [_selectDatePicker didFinishSelectedDate:^(NSDate *selectDateTime) {
        
        NSLog(@"---------%@-----------",selectDateTime);
        
    }];
}
- (IBAction)sysStyle4:(id)sender {
    _selectDatePicker = [[CPSelectDatePicker alloc]init];
    _selectDatePicker.selectDatePickerMode = CPSelectDatePickerModeTime;
    [_selectDatePicker didFinishSelectedDate:^(NSDate *selectDateTime) {
        
        NSLog(@"---------%@-----------",selectDateTime);
        
    }];
}
- (IBAction)customStyle:(id)sender {
    _selectDatePicker = [[CPSelectDatePicker alloc]init];
    _selectDatePicker.selectDatePickerMode = CPSelectDatePickerModeMonthAndYear;
    [_selectDatePicker selectToday];
    [_selectDatePicker didFinishSelectedDate:^(NSDate *selectDateTime) {
        
        NSLog(@"---------%@-----------",selectDateTime);
        
    }];
}

@end
