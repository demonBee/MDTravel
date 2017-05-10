//
//  MDPickerView.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/16.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDPickerView.h"

@implementation MDPickerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0.f, 0.f, KScreenWidth, KScreenHeight);
        UIView * BGView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KScreenWidth, KScreenHeight - 230.f)];
        BGView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.2f];
        [self addSubview:BGView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        
        [self makeToolView];
        
        [self makePickerView];
    }
    return self;
}

- (void)tapAction{
    [self removeFromSuperview];
}

- (void)saveAvtion{
    self.saveBlock(@"");
    [self removeFromSuperview];
}

- (void)makeToolView{
    UIView * toolView = [[UIView alloc]initWithFrame:CGRectMake(0.f, KScreenHeight - 230.f, KScreenWidth, 50.f)];
    toolView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    [self addSubview:toolView];
    
    UIButton * cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.f, 0.f, 50.f, 50.f)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#519bf4"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:cancelBtn];
    
    UIButton * sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth -  50.f, 0.f, 50.f, 50.f)];
    [sureBtn setTitle:@"保存" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHexString:@"#519bf4"] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(saveAvtion) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:sureBtn];
}

- (void)makePickerView{
    
}
//去黑线
- (void)clearSeparatorWithView:(UIView * )view{
    if(view.subviews != 0  )
    {
        if(view.bounds.size.height < 5)
        {
            view.backgroundColor = [UIColor clearColor];
        }
        
        [view.subviews enumerateObjectsUsingBlock:^( UIView *  obj, NSUInteger idx, BOOL *  stop) {
            [self clearSeparatorWithView:obj];
        }];
    }
    
}

@end
