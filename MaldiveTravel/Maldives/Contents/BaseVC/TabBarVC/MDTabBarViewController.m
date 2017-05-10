//
//  MDTabBarViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDTabBarViewController.h"
#import "MDNavigationVC.h"

#import "MDHomeViewController.h"
#import "MDHotelViewController.h"
#import "MDClassRoomViewController.h"
#import "MDDiscoverViewController.h"
#import "MDPersonCenterViewController.h"

#import "MDTabBar.h"

@interface MDTabBarViewController ()

@end

@implementation MDTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray * vcArr = @[@{@"vc":[[MDHomeViewController alloc]init],@"tittle":@"首页",@"image":@"home-page",@"selectImage":@"home-page--pre"},@{@"vc":[[MDHotelViewController alloc]init],@"tittle":@"酒店",@"image":@"home-hotel",@"selectImage":@"home-hotel--pre"},@{@"vc":[[MDClassRoomViewController alloc]init],@"tittle":@"学堂",@"image":@"home-class",@"selectImage":@"home-class--pre"},@{@"vc":[[MDDiscoverViewController alloc]init],@"tittle":@"发现",@"image":@"home-find",@"selectImage":@"home-find--pre"},@{@"vc":[[MDPersonCenterViewController alloc]init],@"tittle":@"我的",@"image":@"home-mine",@"selectImage":@"home-mine--pre"}];
    for (NSDictionary * dic in vcArr) {
        [self addchildViewControllerWithVC:dic[@"vc"] withTittle:dic[@"tittle"] withImageName:dic[@"image"] withSelectesImageName:dic[@"selectImage"]];
    }
    
    [self setValue:[[MDTabBar alloc] init] forKey:@"tabBar"];
}

- (void)addchildViewControllerWithVC:(UIViewController *)vc withTittle:(NSString *)tittleStr withImageName:(NSString *)imageName withSelectesImageName:(NSString *)selectedImageName{
    
    vc.tabBarItem.title = tittleStr;
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    
    MDNavigationVC * navigationVC = [[MDNavigationVC alloc]initWithRootViewController:vc];
    
    [self addChildViewController:navigationVC];
    
}

@end
