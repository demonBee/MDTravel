//
//  MDLoginViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/11.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDLoginViewController.h"
#import "MDRegisterViewController.h"
#import "MDForgetPasswordViewController.h"

@interface MDLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel * wrongShowLabel;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordtextField;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIView *BGView;


@end

@implementation MDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.backgroundColor=[UIColor clearColor];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];//调位置
    negativeSpacer.width = -10.f;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, [UIBarButtonItem barItemWithImageName:@"icon-back-white" withSelectImage:@"icon-back-white" withHorizontalAlignment:UIControlContentHorizontalAlignmentLeft withTittle:@"" withTittleColor:[UIColor blackColor] withTarget:self action:@selector(backBarButtonAction) forControlEvents:UIControlEventTouchUpInside  withWidth:30.f], nil];
    self.wrongShowLabel.text = @"";
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.automaticallyAdjustsScrollViewInsets = YES;
    //去掉背景图片
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    //去掉底部线条
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)makeUI{
    self.passwordtextField.secureTextEntry = YES;
    
    self.loginBtn.layer.cornerRadius = 5.f;
    self.loginBtn.layer.masksToBounds = YES;
    self.registerBtn.layer.cornerRadius = 5.f;
    self.registerBtn.layer.masksToBounds = YES;
    self.registerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.registerBtn.layer.borderWidth = 1.5f;
    
    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    colorLayer.frame = CGRectMake(0.f, 0.f, KScreenWidth, KScreenHeight);
    [self.BGView.layer addSublayer:colorLayer];
    colorLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#4199fe"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#3de6b8"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#72e4e2"].CGColor];// 颜色分配
    colorLayer.locations  = @[@(0.02), @(0.5), @(0.98)];// 颜色分割线
    colorLayer.startPoint = CGPointMake(0, 0);
    colorLayer.endPoint   = CGPointMake(0, 1);
}
- (void)wrongLableTextSetWithWrong:(NSString *)wrong{
    self.wrongShowLabel.text = wrong;
}

- (BOOL)canSendRequset{
    if (![JWTools checkTelNumber:self.mobileTextField.text]) {
        [self showHUDWithStr:@"请输入11位手机号" withSuccess:NO];
        return NO;
    }else if (![JWTools isRightPassWordWithStr:self.passwordtextField.text]){
        [self showHUDWithStr:@"请输入6-16位密码" withSuccess:NO];
        return NO;
    }
    return YES;
}
#pragma mark - ButtonAction

- (IBAction)loginBtnAction:(id)sender {
    if ([self canSendRequset]) {
        [self requestLoginWithAccount:self.mobileTextField.text withPassword:self.passwordtextField.text];
    }
}
- (IBAction)registerBtnAction:(id)sender {
    MDRegisterViewController * vc = [[MDRegisterViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)forgetPasswordBtnAction:(id)sender {
    MDForgetPasswordViewController * vc = [[MDForgetPasswordViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark  - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        if ([self canSendRequset]) {
            [self requestLoginWithAccount:self.mobileTextField.text withPassword:self.passwordtextField.text];
        }
    }
    return YES;
}


#pragma mark - HTTP
- (void)requestLoginWithAccount:(NSString *)account withPassword:(NSString *)password{
    NSDictionary * pragram = @{@"tel":account,@"pwd":password};
    [[HttpObject manager]getDataWithType:MaldivesType_Login withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        [UserSession saveUserLoginWithAccount:account withPassword:password];
        [UserSession saveUserInfoWithDic:responsObj[@"data"]];
        [self showHUDWithStr:@"登录成功" withSuccess:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",responsObj);
        MyLog(@"Error is %@",error);
        [self showHUDWithStr:responsObj[@"errorMessage"] withSuccess:NO];
    }];
}



@end
