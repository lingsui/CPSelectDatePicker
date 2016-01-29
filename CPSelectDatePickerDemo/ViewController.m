//
//  ViewController.m
//  CPSelectDatePickerDemo
//
//  Created by caoping on 15/12/17.
//  Copyright © 2015年 caoping. All rights reserved.
//

#import "ViewController.h"
#import "CPSelectDatePicker.h"
#import "CPPickerView.h"

@interface ViewController ()

@property (nonatomic,strong)CPSelectDatePicker *selectDatePicker;
@property (nonatomic,strong) CPPickerView *leaveTypePickerView;

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
- (IBAction)selectArray:(id)sender {
     __block   NSArray *nameAry = @[@"曹操",@"刘备",@"孙权"];
    
    _leaveTypePickerView = [[CPPickerView alloc]initWithData:nameAry];
    [_leaveTypePickerView didFinishSelected:^(NSInteger row) {
        NSLog(@"----------%@----------",nameAry[row]);
    }];
}

@end
