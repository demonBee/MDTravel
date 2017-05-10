//
//  MDGuideView.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDGuideView.h"

@implementation MDGuideView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame=[UIScreen mainScreen].bounds;
        self.backgroundColor=[UIColor redColor];
        
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backButton)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)backButton {
    [self removeFromSuperview];
}

@end
