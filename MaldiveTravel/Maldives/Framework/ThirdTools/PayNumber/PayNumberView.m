//
//  PayNumberView.m
//  Vipxox
//
//  Created by Tian Wei You on 16/8/2.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "PayNumberView.h"

#define IMAGENAMED(NAME)       [UIImage imageNamed:NAME]
#define SYSTEMFONT(FONTSIZE)     [UIFont systemFontOfSize:FONTSIZE]
@implementation PayNumberView

-(instancetype)initWithFrame:(CGRect)frame{
    
    
    self = [super initWithFrame:frame];
    
    if(self){
        [self createSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self createSubViews];
        [self addBorder];
    }
    return self;
}
- (void)addBorder{
    self.numberLab.layer.borderColor  = [UIColor colorWithHexString:@"#d6d6d6"].CGColor;
    self.numberLab.layer.borderWidth  = 1.f;
    
    self.addBtn.layer.borderColor  = [UIColor colorWithHexString:@"#d6d6d6"].CGColor;
    self.addBtn.layer.borderWidth  = 1.f;
    [self.addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.addBtn.titleLabel.font = [UIFont systemFontOfSize:19.f];
    [self.addBtn setTitle:@"+" forState:UIControlStateNormal];
    
    self.jianBtn.layer.borderColor  = [UIColor colorWithHexString:@"#d6d6d6"].CGColor;
    self.jianBtn.layer.borderWidth  = 1.f;
    [self.jianBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.jianBtn.titleLabel.font = [UIFont systemFontOfSize:24.f];
    [self.jianBtn setTitle:@"-" forState:UIControlStateNormal];
}

-(void)createSubViews{
    self.numberLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.numberLab.text = @"1";
    self.numberLab.textAlignment = NSTextAlignmentCenter;
    self.numberLab.textColor = [UIColor darkGrayColor];
    self.numberLab.font = [UIFont systemFontOfSize:17.f];
    [self addSubview:self.numberLab];
    
    self.jianBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.f,0.f, 33.f, self.height)];
    [self.jianBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.jianBtn.tag = 11;
//    [self.jianBtn setImage:IMAGENAMED(@"jian_icon") forState:UIControlStateNormal];
    self.jianBtn.backgroundColor=[UIColor whiteColor];
    [self addSubview:self.jianBtn];
    
    
    self.addBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.width - 33.f,self.jianBtn.y, 33.f, self.height)];
    self.addBtn.tag = 12;
//    [self.addBtn setImage:IMAGENAMED(@"add_icon") forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.addBtn.backgroundColor=[UIColor whiteColor];
    [self addSubview:self.addBtn];
    
    
}

- (void)awakeFromNib {
    
    
}

- (void)deleteBtnAction:(UIButton *)sender {
    if ([self.numberLab.text integerValue] <=1)return;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(deleteBtnAction:addNumberView:)]){
        
        [self.delegate deleteBtnAction:sender addNumberView:self];
    }
    
    
}

- (void)addBtnAction:(UIButton *)sender {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(addBtnAction:addNumberView:)]){
        
        [self.delegate addBtnAction:sender addNumberView:self];
    }
    
}

@end
