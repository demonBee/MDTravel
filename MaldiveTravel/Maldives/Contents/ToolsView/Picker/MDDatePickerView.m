//
//  MDDatePickerView.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/16.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDDatePickerView.h"

@implementation MDDatePickerView

- (void)saveAvtion{
    self.saveBlock(self.date);
    [UserSession instance].birthday = self.date;
    [self removeFromSuperview];
}

//获取uidatepickerview数据
- (void)dateViewAction:(id)sender
{
    UIDatePicker * picker = (UIDatePicker *)sender;
    [self getSelectedDateWithDate:picker.date];
}
- (void)getSelectedDateWithDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.date = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
}
- (void)makePickerView{
    self.pickerView = [[UIDatePicker alloc]initWithFrame:CGRectMake(0.f, KScreenHeight - 180.f, KScreenWidth, 180.f)];
    self.pickerView.datePickerMode = UIDatePickerModeDate;//选择器模式
    self.pickerView.backgroundColor = [UIColor whiteColor];
    [self.pickerView addTarget:self action:@selector(dateViewAction:) forControlEvents:UIControlEventValueChanged];
    //国家年月选择，此处中国
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    self.pickerView.locale = locale;
    [self clearSeparatorWithView:self.pickerView];
    
    [self getSelectedDateWithDate:[NSDate date]];
    [self addSubview:self.pickerView];
}

@end
