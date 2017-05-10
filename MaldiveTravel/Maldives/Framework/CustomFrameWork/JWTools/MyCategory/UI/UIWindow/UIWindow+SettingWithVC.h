//
//  UIWindow+SettingWithVC.h
//  JW百思
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 蒋威. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (SettingWithVC)

#pragma mark - UIWindow   这里我觉得没有用  完全可以用object 里面创建个方法解决

/**
 *  初始化UIWindow并赋予根视图
 *
 *  @param rootViewController UIWindow的根视图
 *
 *  @return 自定义的UIWindow
 */
+ (UIWindow *)windowInitWithRootViewController:(UIViewController *)rootViewController;

@end
