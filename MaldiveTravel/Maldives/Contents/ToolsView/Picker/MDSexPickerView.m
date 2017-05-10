//
//  MDSexPickerView.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/16.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDSexPickerView.h"

@implementation MDSexPickerView

- (void)saveAvtion{
    self.saveBlock(self.sex);
    [UserSession instance].sex = self.sex;
    [self removeFromSuperview];
}

- (void)makePickerView{
    self.picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0.f, KScreenHeight - 180.f, KScreenWidth, 180.f)];
    self.picker.delegate = self;
    self.picker.dataSource = self;
    self.picker.backgroundColor = [UIColor whiteColor];
    self.sex = @"0";
    self.sexArr = @[@"0",@"1"];
    [self addSubview:self.picker];
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.sex = self.sexArr[row];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;//列数
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.sexArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{// 中指定列和列表项的标题文本
    return [[self.sexArr objectAtIndex:row]isEqualToString:@"0"]?@"男":@"女";
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.font=[UIFont systemFontOfSize:24];
        pickerLabel.textColor=[UIColor blackColor];
        pickerLabel.textAlignment= NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    //在该代理方法里添加以下两行代码删掉上下的黑线
    [[pickerView.subviews objectAtIndex:1] setHidden:TRUE];
    [[pickerView.subviews objectAtIndex:2] setHidden:TRUE];
    return pickerLabel;
}

@end
