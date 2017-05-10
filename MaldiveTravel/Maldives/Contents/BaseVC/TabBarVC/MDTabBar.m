//
//  MDTabBar.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDTabBar.h"

@implementation MDTabBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat endgeWidth = ACTUAL_WIDTH(18.f);
    CGFloat tabBarWidth = (self.width - endgeWidth*2)/5;
    CGFloat tabBarY = self.height/2;
    NSInteger index = 0;
    for (UIView * subView in self.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            subView.centerPoint = CGPointMake(endgeWidth + tabBarWidth/2 + index * tabBarWidth, tabBarY);
            index++;
        }
    }
    
    
}

@end
