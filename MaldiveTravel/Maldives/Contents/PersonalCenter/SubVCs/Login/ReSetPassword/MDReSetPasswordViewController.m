//
//  MDReSetPasswordViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/11.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDReSetPasswordViewController.h"

@interface MDReSetPasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *getSecurityCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *wrongShowLabel;
@property (weak, nonatomic) IBOutlet UITextField *securityCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,assign)NSInteger time;

@end

@implementation MDReSetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"密码重置";
    self.time = 60;
    [self makeUI];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.timer.isValid) {
        [self.timer invalidate];
    }
    self.timer=nil;
}
//重置文字
- (void)securityCodeBtnTextSet{
    if (self.time <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.time = 60;
        [self.getSecurityCodeBtn setTitle:[NSString stringWithFormat:@"重新获取验证码"] forState:UIControlStateNormal];
        self.getSecurityCodeBtn.backgroundColor = [UIColor colorWithHexString:@"#ffc106"];
        [self.getSecurityCodeBtn setUserInteractionEnabled:YES];
        return;
    }
    [self.getSecurityCodeBtn setTitle:[NSString stringWithFormat:@"获取中(%zi)s",self.time] forState:UIControlStateNormal];
    self.time--;
}
- (IBAction)getSecurityCodeBtnAction:(UIButton *)sender {
    [self requestSendComfireCode];
}
- (IBAction)loginBtnAction:(id)sender {
    [self requestLoginWithSecurityCode:self.securityCodeTextField.text withPassword:self.passwordTextField.text];
}
- (void)makeUI{
    self.passwordTextField.secureTextEntry = YES;
    self.loginBtn.layer.cornerRadius = 5.f;
    self.loginBtn.layer.masksToBounds = YES;
    self.getSecurityCodeBtn.layer.cornerRadius = 5.f;
    self.getSecurityCodeBtn.layer.masksToBounds = YES;
    
}
- (void)wrongLableTextSetWithWrong:(NSString *)wrong{
    self.wrongShowLabel.text = wrong;
    self.time = 0;
    [self securityCodeBtnTextSet];
}
#pragma mark  - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        [self requestLoginWithSecurityCode:self.securityCodeTextField.text withPassword:textField.text];
    }
    return YES;
}


#pragma mark - HTTP
- (void)requestSendComfireCode{
    NSDictionary * pragram = @{@"tel":self.mobile};
    [[HttpObject manager]getDataWithType:MaldivesType_Forget_SendCode withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        [self.getSecurityCodeBtn setUserInteractionEnabled:NO];
        self.getSecurityCodeBtn.backgroundColor = [UIColor colorWithHexString:@"#d6d6d6"];
        [self securityCodeBtnTextSet];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(securityCodeBtnTextSet) userInfo:nil repeats:YES];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",responsObj);
        MyLog(@"Error is %@",error);
    }];
}
- (void)requestLoginWithSecurityCode:(NSString *)securityCode withPassword:(NSString *)password{
    if ([securityCode isEqualToString:@""]) {
        [self showHUDWithStr:@"请输入验证码" withSuccess:NO];
        return;
    }else if (![JWTools isRightPassWordWithStr:password]) {
        [self showHUDWithStr:@"请输入正确的密码" withSuccess:NO];
        return;
    }
    NSDictionary * pragram = @{@"code":securityCode,@"tel":self.mobile,@"pwd":password};
    [[HttpObject manager]getDataWithType:MaldivesType_Forget_ChangePassword withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        //重置成功时调用
        [UserSession saveUserLoginWithAccount:self.mobile withPassword:password];
        [self showHUDWithStr:@"重置成功" withSuccess:YES];
        [self requestLogin];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",responsObj);
        MyLog(@"Error is %@",error);
        [self wrongLableTextSetWithWrong:responsObj[@"errorMessage"]];
    }];
}

- (void)requestLogin{
    NSDictionary * pragram = @{@"tel":self.mobile,@"pwd":self.passwordTextField.text};
    [[HttpObject manager]getDataWithType:MaldivesType_Login withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        [UserSession saveUserInfoWithDic:responsObj[@"data"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",responsObj);
        MyLog(@"Error is %@",error);
    }];
    
}


@end
