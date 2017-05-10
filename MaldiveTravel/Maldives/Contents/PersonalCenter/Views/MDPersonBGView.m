//
//  MDPersonBGView.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/11.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDPersonBGView.h"

@implementation MDPersonBGView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.colorLayer = [CAGradientLayer layer];
        self.colorLayer.frame    = self.frame;
        [self.layer addSublayer:self.colorLayer];
        // 颜色分配
        self.colorLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#4199fe"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#3de6b8"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#72e4e2"].CGColor];
        // 颜色分割线
        self.colorLayer.locations  = @[@(0.02), @(0.5), @(0.98)];
        // 起始点
        self.colorLayer.startPoint = CGPointMake(0, 0);
        // 结束点
        self.colorLayer.endPoint   = CGPointMake(0, 1);
    }
    return self;
}

@end
