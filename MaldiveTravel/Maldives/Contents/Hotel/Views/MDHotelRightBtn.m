//
//  MDHotelRightBtn.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDHotelRightBtn.h"

@implementation MDHotelRightBtn

- (void)awakeFromNib{
    
}

- (void)setIsPhoto:(NSString *)isPhoto{
    if (!isPhoto)return;
    _isPhoto = isPhoto;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
    if ([_isPhoto isEqualToString:@"1"]) {
        self.tittleLabel.text = self.photoType == 0?@"房型":self.photoType == 1? @"餐厅":@"其他";
        [tap addTarget:self action:@selector(tapPhotoAction)];
    }else{
        [tap addTarget:self action:@selector(tapAction)];
    }
    
    [self addGestureRecognizer:tap];
}

- (void)tapAction{
    //酒店界面
    self.isOn = !self.isOn;
    if (self.isOn) {
        //开启
        self.imgView.image = [UIImage imageNamed:@"icon-Upward-triangle"];
        if (!self.typeTableV) {
            self.typeTableV = [[[NSBundle mainBundle]loadNibNamed:@"MDHotelChooseTypeTableVC" owner:nil options:nil]firstObject];
            WEAKSELF;
            self.typeTableV.choosedTypeBlock = ^(NSString * index,NSString *chooseStr){
                weakSelf.chooseTypeBlock(index);
                weakSelf.tittleLabel.text = chooseStr;
                [weakSelf tapAction];
            };
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
            [tap addTarget:self action:@selector(tapAction)];
            self.typeView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 328.f, KScreenWidth, KScreenHeight - 328.f)];
            self.typeView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.4f];
            [self.typeView addGestureRecognizer:tap];
        }
        [[UIApplication sharedApplication].keyWindow addSubview:self.typeTableV];
        [[UIApplication sharedApplication].keyWindow addSubview:self.typeView];
    }else{
        self.imgView.image = [UIImage imageNamed:@"icon-Downward-expansion"];
        [self.typeTableV removeFromSuperview];
        [self.typeView removeFromSuperview];
    }
}

- (void)tapPhotoAction{
    //相册界面
    if (!self.photoTypeArr){
        self.imgView.image = [UIImage imageNamed:@"icon-Downward-expansion"];
        self.tittleLabel.text = @"房型";
        return;
    }
    
    self.isOn = !self.isOn;
    if (self.isOn) {
        //开启
        self.imgView.image = [UIImage imageNamed:@"icon-Upward-triangle"];
        if (!self.typePhotoV) {
            self.typePhotoV = [[[NSBundle mainBundle]loadNibNamed:@"MDHotelPhotoTableView" owner:nil options:nil]firstObject];
            self.typePhotoV.selectTypeIndex = self.photoType;
            self.typePhotoV.dataArr = self.photoTypeArr;
            WEAKSELF;
            self.typePhotoV.choosedTypeBlock = ^(NSInteger status,NSInteger type,NSString *chooseStr){
                weakSelf.choosePhotoTypeBlock(status,type);
                weakSelf.tittleLabel.text = chooseStr;
                [weakSelf tapPhotoAction];
            };
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
            [tap addTarget:self action:@selector(tapPhotoAction)];
            self.typeView = [[UIView alloc]initWithFrame:CGRectMake(0.f,NavigationHeight + self.typePhotoV.height, KScreenWidth, KScreenHeight - self.typePhotoV.height)];
            self.typeView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.4f];
            [self.typeView addGestureRecognizer:tap];
        }
        [[UIApplication sharedApplication].keyWindow addSubview:self.typePhotoV];
        [[UIApplication sharedApplication].keyWindow addSubview:self.typeView];
    }else{
        self.imgView.image = [UIImage imageNamed:@"icon-Downward-expansion"];
        [self.typePhotoV removeFromSuperview];
        [self.typeView removeFromSuperview];
    }
}

@end
