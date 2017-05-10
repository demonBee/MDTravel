//
//  MDSexPickerView.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/16.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDPickerView.h"

@interface MDSexPickerView : MDPickerView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong)UIPickerView * picker;
@property (nonatomic,copy)NSString * sex;
@property (nonatomic,strong)NSArray * sexArr;

@end
