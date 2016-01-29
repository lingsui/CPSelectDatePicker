//
//  CPPickerView.m
//  yjtim
//
//  Created by caoping on 15/12/17.
//  Copyright © 2015年 caoping. All rights reserved.
//

#import "CPPickerView.h"


#define kWinH self.view.frame.size.height
#define kWinW self.view.frame.size.width

//pickerView H
#define kSPVH (kWinH * 0.35 > 230 ? 230 : (kWinH * 0.35 < 200 ? 200 : kWinH *0.35))


@interface CPPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) UIView *view;
@property (nonatomic,strong) UIButton *bgButton;
@property (nonatomic,strong) UIView *selectDatePickerView;
@property (nonatomic,strong) UIButton *hideButton;
@property (nonatomic,strong) UIButton *confirmButton;

@property (nonatomic,strong) UIView *searaptorLineView1;
@property (nonatomic,strong) UIView *searaptorLineView2;
//自定义
@property (nonatomic,strong) UIPickerView *customPicker;

@property (nonatomic,strong) selectedBlock selectBlock;
@property (nonatomic,assign) NSInteger selectedIndex;

@end

@implementation CPPickerView


- (instancetype)init{
    if (self == [super init]) {
        
//        _data = [NSArray array];
        
        _view = [self getTopViewController].view;
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
        _searaptorLineView1 = [[UIView alloc]initWithFrame:CGRectMake(kWinW / 2, 0, 1, 40)];
        _searaptorLineView1.backgroundColor = [UIColor grayColor];
        [_selectDatePickerView addSubview:_searaptorLineView1];
        
        //确认按钮
        _confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(kWinW / 2, 5, kWinW / 2, 30)];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        [_selectDatePickerView addSubview:_confirmButton];
        
        //分隔线
        _searaptorLineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, kWinW, 1)];
        _searaptorLineView2.backgroundColor = [UIColor grayColor];
        [_selectDatePickerView addSubview:_searaptorLineView2];
        
        //选择器控件
        _customPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, kWinW, kSPVH - 40)];
        _customPicker.dataSource = self;
        _customPicker.delegate= self;
        [_selectDatePickerView addSubview:_customPicker];
        
        //默认选中
        _selectedIndex = 0;
        
        //动画从下往上弹出界面
        [self cp_showSelectDatePicker];
    }
    
    
    return self;
}

-(instancetype)initWithData:(NSArray *)data{
    _data = data;
    return [self init];
}

#pragma mark - Properties

-(void)setButtonColor:(UIColor *)buttonColor{
    
    [_hideButton setTitleColor:buttonColor forState:UIControlStateNormal];
    [_confirmButton setTitleColor:buttonColor forState:UIControlStateNormal];
}

- (void)setSearaptorLineColor:(UIColor *)searaptorLineColor{
    _searaptorLineView1.backgroundColor = searaptorLineColor;
    _searaptorLineView2.backgroundColor = searaptorLineColor;
}

-(void)setData:(NSArray *)data{
    [_customPicker reloadAllComponents];
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
        _selectBlock(_selectedIndex);
    }
    [self cp_dismissSelectDatePicker];
}


#pragma mark - UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _data.count;
}



#pragma mark - UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return _data[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _selectedIndex = row;
}

#pragma mark - public method
-(void)didFinishSelected:(selectedBlock)block{
    
    _selectBlock = block;
}


#pragma mark - private

-(UIViewController *)getTopViewController{
    UIViewController *topVC = [[[UIApplication sharedApplication].windows objectAtIndex:0] rootViewController];
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    if([topVC isKindOfClass:[UINavigationController class]]){
        UINavigationController *nav = (UINavigationController *)topVC;
        topVC = [nav.viewControllers lastObject];
    }
    if ([topVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabVC = (UITabBarController *)topVC;
        topVC = tabVC.selectedViewController;
    }
    return topVC;
}



@end
