//
//  AppDelegate+DBDefault.m
//  Maldives
//
//  Created by 黄佳峰 on 2017/3/13.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "AppDelegate+DBDefault.h"
#import "MDGuideView.h"   //引导页



@implementation AppDelegate (DBDefault)

/**
 *  初始化UIWindow并赋予根视图
 *
 *  @param rootViewController UIWindow的根视图
 *
 *  @return 自定义的UIWindow
 */
+ (UIWindow *)windowInitWithRootViewController:(UIViewController *)rootViewController{
    UIWindow * window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [window makeKeyAndVisible];
    window.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    window.rootViewController = rootViewController;
    return window;
}



/**
版本不一样 就显示引导页
 */
+ (void)isFirstOPen{
    NSString * key = @"CFBundleShortVersionString";
    
    NSString * versionStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:key];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString * version = [userDefault objectForKey:key];
    
    if (![versionStr isEqualToString:version]){
        //引导页的view
        MDGuideView * guideView = [[MDGuideView alloc]init];  //这里要给frame 
        [[UIApplication sharedApplication].keyWindow addSubview:guideView];
//        [self.window.rootViewController.view addSubview:guideView];
        [userDefault setObject:versionStr forKey:key];
    }
}



@end
