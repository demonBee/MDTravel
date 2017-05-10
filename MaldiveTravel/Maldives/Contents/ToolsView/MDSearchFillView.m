//
//  MDSearchFillView.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/9.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDSearchFillView.h"

@implementation MDSearchFillView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self.searchTextField setValue:[UIColor colorWithHexString:@"#a0a0a0"] forKeyPath:@"_placeholderLabel.textColor"];
        self.layer.cornerRadius = 3.f;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1.f;
        self.layer.borderColor = [UIColor colorWithHexString:@"85b9f7"].CGColor;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
        [tap addTarget:self action:@selector(tapAction)];
        [self.searchImgView addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapAction{
    self.searchBlock();
}

@end
