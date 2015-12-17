//
//  CPSelectDatePicker.m
//  yjtim
//
//  Created by caoping on 15/12/14.
//  Copyright © 2015年 caoping. All rights reserved.
//

#import "CPSelectDatePicker.h"



#define kWinH self.view.frame.size.height
#define kWinW self.view.frame.size.width

//pickerView H
#define kSPVH (kWinH * 0.35 > 230 ? 230 : (kWinH * 0.35 < 200 ? 200 : kWinH *0.35))

#define YEAR (0)
#define MONTH (1)

#define LABEL_TAG 43

@interface CPSelectDatePicker()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) UIView *view;
@property (nonatomic,strong) UIButton *bgButton;
@property (nonatomic,strong) UIView *selectDatePickerView;
@property (nonatomic,strong) UIButton *hideButton;
@property (nonatomic,strong) UIButton *confirmButton;
//系统
@property (nonatomic,strong) UIDatePicker *datePicker;
//自定义
@property (nonatomic,strong) UIPickerView *customDatePicker;
@property (nonatomic,strong) NSIndexPath *todayIndexPath;
@property (nonatomic,strong) NSArray *months;
@property (nonatomic,strong) NSArray *years;

@property (nonatomic,assign) NSInteger maxYear;
@property (nonatomic,assign) NSInteger minYear;

@property (nonatomic,strong)NSDate *selectDate;
@property (nonatomic,strong)selectDateBlock selectBlock;

@end

@implementation CPSelectDatePicker

const NSInteger bigRowCount = 1000;
const NSInteger numberOfComponents = 2;

- (instancetype)init{
    if (self == [super init]) {
        
        //初始化自定义参数
        [self initDefautsParameters];
        
        _view = [[UIApplication sharedApplication].delegate window].rootViewController.view;
        _view.userInteractionEnabled = YES;
        //背景遮罩层
        _bgButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWinW, kWinH)];
        [_view addSubview:_bgButton];
        [_bgButton addTarget:self action:@selector(cp_dismissSelectDatePicker) forControlEvents:UIControlEventTouchUpInside];
        _bgButton.backgroundColor = [UIColor blackColor];
        _bgButton.alpha = 0.0;
        
        //时间选择View
        _selectDatePickerView = [[UIView alloc]initWithFrame:CGRectMake(0, kWinH, kWinW, kSPVH)];
        [_view addSubview:_selectDatePickerView];
        _selectDatePickerView.userInteractionEnabled = YES;
        _selectDatePickerView.backgroundColor = [UIColor whiteColor];
        
        //取消按钮
        _hideButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, kWinW / 2, 30)];
        [_hideButton setTitle:@"取消" forState:UIControlStateNormal];
        [_hideButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_hideButton addTarget:self action:@selector(cp_dismissSelectDatePicker) forControlEvents:UIControlEventTouchUpInside];
        [_selectDatePickerView addSubview:_hideButton];
        
        //分隔线
        UIView *separatorView1 = [[UIView alloc]initWithFrame:CGRectMake(kWinW / 2, 0, 1, 40)];
        separatorView1.backgroundColor = [UIColor grayColor];
        [_selectDatePickerView addSubview:separatorView1];
        
        //确认按钮
        _confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(kWinW / 2, 5, kWinW / 2, 30)];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        [_selectDatePickerView addSubview:_confirmButton];
        
        //分隔线
        UIView *separatorView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, kWinW, 1)];
        separatorView2.backgroundColor = [UIColor grayColor];
        [_selectDatePickerView addSubview:separatorView2];
        
        //系统时间选择控件
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 40, kWinW, kSPVH - 40)];
        [_datePicker addTarget:self action:@selector(dataPickerValueChange:) forControlEvents:UIControlEventValueChanged];
        _datePicker.date = [NSDate date];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.hidden = YES;
        [_selectDatePickerView addSubview:_datePicker];
        
        //年月日时间选择器控件
        _customDatePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, kWinW, kSPVH - 40)];
        _customDatePicker.dataSource = self;
        _customDatePicker.delegate= self;
        _datePicker.hidden = YES;
        [_selectDatePickerView addSubview:_customDatePicker];
        
        //默认选中日期
        _selectDate = [NSDate date];
        
        //动画从下往上弹出界面
        [self cp_showSelectDatePicker];
    }
    
    
    return self;
}


#pragma mark Properties

- (void)setSelectDatePickerMode:(CPSelectDatePickerMode)selectDatePickerMode{
    
    if (selectDatePickerMode ==  CPSelectDatePickerModeMonthAndYear) {
        _datePicker.hidden = YES;
        _customDatePicker.hidden = NO;
        
    }else{
        _customDatePicker.hidden = YES;
        _datePicker.hidden = NO;
        if (selectDatePickerMode == CPSelectDatePickerModeTime) {
            _datePicker.datePickerMode = UIDatePickerModeTime;
        }else if (selectDatePickerMode == CPSelectDatePickerModeDate){
            _datePicker.datePickerMode = UIDatePickerModeDate;
        }else if (selectDatePickerMode == CPSelectDatePickerModeDateAndTime){
            _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        }else if (selectDatePickerMode == CPSelectDatePickerModeCountDownTimer){
            _datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        }
    }
}

-(void)setButtonColor:(UIColor *)buttonColor{
    
    [_hideButton setTitleColor:buttonColor forState:UIControlStateNormal];
    [_confirmButton setTitleColor:buttonColor forState:UIControlStateNormal];
}



#pragma mark action
- (void)cp_dismissSelectDatePicker{
    
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.bgButton.alpha =  0.0;
        weakSelf.selectDatePickerView.frame = CGRectMake(0, kWinH, kWinW, kSPVH);
        
    } completion:^(BOOL finished) {
        [weakSelf.selectDatePickerView removeFromSuperview];
        [weakSelf.bgButton  removeFromSuperview];
        
    }];
}

-(void)cp_showSelectDatePicker{
    
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bgButton.alpha =  0.2;
        weakSelf.selectDatePickerView.frame = CGRectMake(0, kWinH - kSPVH, kWinW, kSPVH);
    }];
}

-(void)confirm{
    
    if (_selectBlock) {
        _selectBlock(_selectDate);
    }
    [self cp_dismissSelectDatePicker];
}


-(void)dataPickerValueChange:(id)sender{
    _selectDate = [sender date];
}

#pragma mark - data
- (void)initDefautsParameters{
    _minYear = 2008;
    _maxYear = 2030;
    
    self.months = [self nameOfMonths];
    self.years = [self nameOfYears];
    self.todayIndexPath = [self todayPath];
    
    self.rowHeight = 44;
    
    self.monthSelectedTextColor = [UIColor blackColor];
    self.monthTextColor = [UIColor blackColor];
    
    self.yearSelectedTextColor = [UIColor blackColor];
    self.yearTextColor = [UIColor blackColor];
    
    self.monthSelectedFont = [UIFont boldSystemFontOfSize:17];
    self.monthFont = [UIFont boldSystemFontOfSize:17];
    
    self.yearSelectedFont = [UIFont boldSystemFontOfSize:17];
    self.yearFont = [UIFont boldSystemFontOfSize:17];


}


- (NSArray *)nameOfMonths{
    
    return @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
}

-(NSArray *)nameOfYears{
    
    NSMutableArray *years = [NSMutableArray array];
    for (NSInteger year = self.minYear; year <= self.maxYear; year ++) {
        
        NSString *yearStr = [NSString stringWithFormat:@"%li",(long)year];
        [years addObject:yearStr];
    }
    
    return years;
}


-(NSIndexPath *)todayPath{
    CGFloat row = 0.f;
    CGFloat section = 0.f;
    
    NSString *month = [self currentMonthName];
    NSString *year = [self currentYearName];
    
    for (NSString *cellMonth in self.months) {
        if ([cellMonth isEqualToString:month]) {
            
            row = [self.months indexOfObject:cellMonth];
            row = row + [self bigRowMonthCount] / 2;
            break;
        }
    }
    
    for (NSString *cellYear in self.years) {
        if ([cellYear isEqualToString:year]) {
            section = [self.years indexOfObject:cellYear];
            section = section + [self bigRowYearCount] / 2;
            break;
        }
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}


#pragma mark - UIPickerViewDateSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return numberOfComponents;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == YEAR) {
        return [self bigRowYearCount];
    }else{
        return [self bigRowMonthCount];
    }
}

#pragma mark - UIPickerViewDelegate


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{

    return kWinW / numberOfComponents;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    BOOL selected = NO;
    if (component == YEAR) {
        
        NSInteger yearCount = self.years.count;
        NSString *yearName = self.years[row % yearCount];
        NSString *currentYearName = [self currentYearName];
        if ([currentYearName isEqualToString:yearName]) {
            selected = YES;
        }
    }else{
        
        NSInteger monthCount = self.years.count;
        NSString *monthName = self.years[row % monthCount];
        NSString *currentMonthName = [self currentMonthName];
        if ([currentMonthName isEqualToString:monthName]) {
            selected = YES;
        }
        
    }
    UILabel  *returnView = nil;
    if (returnView.tag == LABEL_TAG) {
        returnView = (UILabel *)view;
    }else{
        returnView = [self lableForComponent:component];
    }
    
    returnView.font = selected ? [self selectedFontForComponent:component] : [self fontForComponent:component];
    returnView.textColor = selected ? [self selectedColorForComponent:component] : [self colorForCompoent:component];
    
    returnView.text = [self titleForRw:row forComponent:component];
    return returnView;
}

- (CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 44;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *yearName ;
    NSString *monthName;
    NSDateComponents *compt = [[NSDateComponents alloc]init];
    
    [compt setYear:[self selectYear]];
    [compt setMonth:[self selectMonth]];
    
    if (component ==  YEAR) {
        
        yearName  =    self.years[row % self.years.count];
        [compt setYear:[yearName integerValue]];
    }else{
        
        monthName  =    self.months[row % self.months.count];
        [compt setMonth:[monthName integerValue]];
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [calendar dateFromComponents:compt];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];//获取本地时间，避免时区问题
    NSInteger interval = [zone secondsFromGMTForDate:date];
    _selectDate = [date dateByAddingTimeInterval:interval];

}

#pragma mark - Util

-(NSInteger )selectYear{
    if (_selectDate) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"yyyy"];
        return [[formatter stringFromDate:_selectDate] integerValue];
    }
    return [[self currentYearName]integerValue];
}
-(NSInteger )selectMonth{
    if (_selectDate) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"MM"];
        return [[formatter stringFromDate:_selectDate] integerValue];
    }
    return [[self currentMonthName]integerValue];
}
-(NSString *)currentMonthName{
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MM"];
    return  [formatter stringFromDate:[NSDate date ]];
}
-(NSString *)currentYearName{
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearName = [formatter stringFromDate:[NSDate date ]];
    return yearName;
}


-(NSInteger)bigRowMonthCount
{
    return self.months.count  * bigRowCount;
}

-(NSInteger)bigRowYearCount
{
    return self.years.count  * bigRowCount;
}

- (CGFloat)compoentWidth{
    
    return kWinW / numberOfComponents;
}

-(NSString *)titleForRw:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == YEAR) {
        NSInteger yearCount = self.years.count;
        NSString *yearName = [NSString stringWithFormat:@"%@%@",self.years[row % yearCount],@"年"];
        return yearName;
    }
    
    NSInteger monthCount = self.months.count;
    NSString *monthName = [NSString stringWithFormat:@"%@%@",self.months[row % monthCount],@"月"];
    return monthName;
}


- (UILabel *)lableForComponent:(NSInteger)component{
    CGRect frame = CGRectMake(0, 0, [self compoentWidth], 44);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.userInteractionEnabled = NO;
    
    label.tag = LABEL_TAG;
    
    return label;
}

- (UIColor *)selectedColorForComponent:(NSInteger)component{
    
    if (component == YEAR) {
        return self.yearSelectedTextColor;
    }
    return self.monthSelectedTextColor;
}

-(UIColor *)colorForCompoent:(NSInteger)component{
    if (component == YEAR) {
        return self.yearTextColor;
    }
    return self.monthTextColor;
}


- (UIFont *) selectedFontForComponent:(NSInteger)compoent{
    if (compoent == YEAR) {
        return self.yearSelectedFont;
    }
    return self.monthSelectedFont;
}

- (UIFont *) fontForComponent:(NSInteger)compoent{
    if (compoent == YEAR) {
        return self.yearFont;
    }
    return self.monthFont;
}

#pragma mark - Open  methods
-(void)selectToday{
    
    [_customDatePicker selectRow:self.todayIndexPath.row inComponent:MONTH animated:NO];
    [_customDatePicker selectRow:self.todayIndexPath.section inComponent:YEAR animated:NO];
}

-(void)didFinishSelectedDate:(selectDateBlock)selectDateBlock{
    
    _selectBlock = selectDateBlock;
    
}


@end
