//
//  MDRegisterViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/11.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDRegisterViewController.h"
#import "MDRegisterSuccessViewController.h"

@interface MDRegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *BGView;

@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *securityCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passoordTextField;

@property (weak, nonatomic) IBOutlet UIButton *getSecurityCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *wrongShowLabel;

@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,assign)NSInteger time;


@end

@implementation MDRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.time = 60;
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
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.automaticallyAdjustsScrollViewInsets = YES;
    //去掉背景图片
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    //去掉底部线条
    [self.navigationController.navigationBar setShadowImage:nil];
    if (self.timer.isValid) {
        [self.timer invalidate];
    }
    self.timer=nil;
}
- (void)makeUI{
    self.passoordTextField.secureTextEntry = YES;
    
    self.loginBtn.layer.cornerRadius = 5.f;
    self.loginBtn.layer.masksToBounds = YES;
    self.getSecurityCodeBtn.layer.cornerRadius = 5.f;
    self.getSecurityCodeBtn.layer.masksToBounds = YES;
    self.getSecurityCodeBtn.backgroundColor = [UIColor colorWithHexString:@"ffc106"];
    
    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    colorLayer.frame = CGRectMake(0.f, 0.f, KScreenWidth, KScreenHeight);
    [self.BGView.layer addSublayer:colorLayer];
    colorLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#4199fe"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#3de6b8"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#72e4e2"].CGColor];// 颜色分配
    colorLayer.locations  = @[@(0.02), @(0.5), @(0.98)];// 颜色分割线
    colorLayer.startPoint = CGPointMake(0, 0);
    colorLayer.endPoint = CGPointMake(0, 1);
}

- (void)wrongLableTextSetWithWrong:(NSString *)wrong{
    self.wrongShowLabel.text = wrong;
    self.time = 0;
    [self securityCodeBtnTextSet];
}

- (void)securityCodeBtnTextSet{
    if (self.time <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.time = 60;
        [self.getSecurityCodeBtn setTitle:[NSString stringWithFormat:@"重新获取验证码"] forState:UIControlStateNormal];
        self.getSecurityCodeBtn.backgroundColor = [UIColor colorWithHexString:@"ffc106"];
        [self.getSecurityCodeBtn setUserInteractionEnabled:YES];
        return;
    }
    [self.getSecurityCodeBtn setTitle:[NSString stringWithFormat:@"获取中(%zi)s",self.time] forState:UIControlStateNormal];
    self.time--;
}
#pragma mark - ButtonAction
- (IBAction)getSecurityCodeBtnAction:(UIButton *)sender {
    if (![JWTools checkTelNumber:self.mobileTextField.text]) {
        [self showHUDWithStr:@"请输入正确的手机号" withSuccess:NO];
        return;
    }
    [self registerCodeSend];
}
- (IBAction)hiddenPasswordBtnAction:(id)sender {
    self.passoordTextField.secureTextEntry = !self.passoordTextField.secureTextEntry;
}
- (IBAction)loginBtnAction:(id)sender {
    [self registerSend];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        [self registerSend];
    }
    return YES;
}

#pragma mark - HTTP
- (void)registerCodeSend{
    NSDictionary * pragram = @{@"tel":self.mobileTextField.text};
    [[HttpObject manager]getDataWithType:(kMaldivesType)MaldivesType_ComfireCode withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        [self.getSecurityCodeBtn setUserInteractionEnabled:NO];
        self.getSecurityCodeBtn.backgroundColor = [UIColor colorWithHexString:@"#D6D6D6"];
        [self securityCodeBtnTextSet];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(securityCodeBtnTextSet) userInfo:nil repeats:YES];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
        [self wrongLableTextSetWithWrong:responsObj[@"errorMessage"]];
    }];
}
- (void)registerSend{
    if (![JWTools checkTelNumber:self.mobileTextField.text]) {
        [self showHUDWithStr:@"请输入正确手机号" withSuccess:NO];
        return;
    }else if (![JWTools isRightPassWordWithStr:self.passoordTextField.text]) {
        [self showHUDWithStr:@"请输入密码" withSuccess:NO];
        return;
    }else if (![JWTools isComfireCodeWithStr:self.securityCodeTextField.text]){
        [self showHUDWithStr:@"请输入验证码" withSuccess:NO];
        return;
    }
    NSDictionary * pragram = @{@"tel":self.mobileTextField.text,@"pwd":self.passoordTextField.text,@"code":self.securityCodeTextField.text};
    [[HttpObject manager]getDataWithType:(kMaldivesType)MaldivesType_Register withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter pragram is %@",pragram);
        MyLog(@"Regieter is %@",responsObj);
        [UserSession saveUserLoginWithAccount:self.mobileTextField.text withPassword:self.passoordTextField.text];
        [self showHUDWithStr:@"注册成功" withSuccess:YES];
        [self.view setUserInteractionEnabled:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MDRegisterSuccessViewController * vc = [[MDRegisterSuccessViewController alloc]init];
            [self.view setUserInteractionEnabled:YES];
            [self.navigationController pushViewController:vc animated:YES];
        });
        
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
        MyLog(@"Regieter Code error is %@",error);
        [self.view setUserInteractionEnabled:YES];
    }];
}




@end
