//
//  MDRegisterSuccessViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/11.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDRegisterSuccessViewController.h"
#import "MDTabBarViewController.h"

@interface MDRegisterSuccessViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backBtn;


@end

@implementation MDRegisterSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册成功";
    [self makeUI];
    [self requestLogin];
}
- (void)makeUI{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    self.backBtn.layer.cornerRadius = 5.f;
    self.backBtn.layer.masksToBounds = YES;
}

- (IBAction)backToRoot:(id)sender {
    MDTabBarViewController * tabBarVC = (MDTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBarVC.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)requestLogin{
    NSDictionary * pragram = @{@"tel":[UserSession instance].account,@"pwd":[UserSession instance].password};
    [self.view setUserInteractionEnabled:NO];
    
    [[HttpObject manager]getNoHudWithType:(kMaldivesType)MaldivesType_Login withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        
        [self.view setUserInteractionEnabled:YES];
        [UserSession saveUserInfoWithDic:responsObj[@"data"]];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",responsObj);
        MyLog(@"Error is %@",error);
        
        [self.view setUserInteractionEnabled:YES];
        [self showHUDWithStr:responsObj[@"errorMessage"] withSuccess:NO];
    }];
}


@end
