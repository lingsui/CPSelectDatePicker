//
//  CPPickerView.h
//  yjtim
//
//  Created by caoping on 15/12/17.
//  Copyright © 2015年 caoping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^selectedBlock)(NSInteger row);

@interface CPPickerView : NSObject

@property(nonatomic,strong) UIColor *buttonColor;// 取消和确认 按钮颜色
@property(nonatomic,strong) UIColor *searaptorLineColor;// 分割线 按钮颜色
@property(nonatomic,strong) NSArray *data;

- (instancetype)initWithData:(NSArray *)data;

-(void)didFinishSelected:(selectedBlock)block;



@end
