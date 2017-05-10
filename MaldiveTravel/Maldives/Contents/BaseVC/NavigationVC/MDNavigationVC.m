//
//  MDNavigationVC.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDNavigationVC.h"
#import "MDSearchViewController.h"

@interface MDNavigationVC ()

@end

@implementation MDNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar * navBar = [[UINavigationBar alloc]init];
    navBar.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    navBar.barTintColor = [UIColor colorWithHexString:@"#ffffff"];
    [self setValue:navBar forKey:@"navigationBar"];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        if (![viewController isKindOfClass:[MDSearchViewController class]]) {
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];//调位置
            negativeSpacer.width = -10.f;
            viewController.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, [UIBarButtonItem barItemWithImageName:@"btn-back" withSelectImage:@"btn-back" withHorizontalAlignment:UIControlContentHorizontalAlignmentLeft withTittle:@"" withTittleColor:[UIColor blackColor] withTarget:self action:@selector(backBarButtonAction) forControlEvents:UIControlEventTouchUpInside  withWidth:30.f], nil];
        }
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - ButtonAction
- (void)backBarButtonAction{
    [self popViewControllerAnimated:YES];
}

@end
