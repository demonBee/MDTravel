//
//  PayNumberView.h
//  Vipxox
//
//  Created by Tian Wei You on 16/8/2.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol PayNumberViewDelegate;


@interface PayNumberView : UIView



@property (strong, nonatomic) UIButton *jianBtn;
@property (strong, nonatomic) UIButton *addBtn;
@property (strong, nonatomic) UILabel *numberLab;

@property (nonatomic,copy) NSString *numberString;

@property (nonatomic,assign) id<PayNumberViewDelegate> delegate;

@end


@protocol PayNumberViewDelegate <NSObject>

@optional


- (void)deleteBtnAction:(UIButton *)sender addNumberView:(PayNumberView *)view;

- (void)addBtnAction:(UIButton *)sender addNumberView:(PayNumberView *)view;



@end