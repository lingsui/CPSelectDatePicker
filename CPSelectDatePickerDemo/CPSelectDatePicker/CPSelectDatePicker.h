//
//  CPSelectDatePicker.h
//  yjtim
//
//  Created by caoping on 15/12/14.
//  Copyright © 2015年 caoping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CPSelectDatePickerMode) {
    CPSelectDatePickerModeTime,
    CPSelectDatePickerModeDate,
    CPSelectDatePickerModeDateAndTime,
    CPSelectDatePickerModeCountDownTimer,
    CPSelectDatePickerModeMonthAndYear,
};

typedef void(^selectDateBlock)(NSDate *selectDateTime);

@interface CPSelectDatePicker : NSObject
@property(nonatomic,strong) UIColor *buttonColor;// 取消和确认 按钮颜色

@property(nonatomic,assign) CPSelectDatePickerMode selectDatePickerMode; //日期选择样式

@property (nonatomic, strong) UIColor *monthSelectedTextColor;
@property (nonatomic, strong) UIColor *monthTextColor;

@property (nonatomic, strong) UIColor *yearSelectedTextColor;
@property (nonatomic, strong) UIColor *yearTextColor;

@property (nonatomic, strong) UIFont *monthSelectedFont;
@property (nonatomic, strong) UIFont *monthFont;

@property (nonatomic, strong) UIFont *yearSelectedFont;
@property (nonatomic, strong) UIFont *yearFont;

@property (nonatomic, assign) NSInteger rowHeight;


-(void)didFinishSelectedDate:(selectDateBlock)selectDateBlock; //确认按钮回调方法

-(void)selectToday;//自定义年月选择控件，默认选择今天
@end
