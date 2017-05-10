//
//  MDChangePassWordViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/16.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDChangePassWordViewController.h"

@interface MDChangePassWordViewController ()
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordNewTextField;
@property (weak, nonatomic) IBOutlet UITextField *rePasswordNewTextField;



@end

@implementation MDChangePassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
}
- (void)makeUI{
    self.saveBtn.layer.cornerRadius = 5.f;
    self.saveBtn.layer.masksToBounds = YES;
    
}
- (void)saveInfo{
    if (![JWTools isRightPassWordWithStr:self.passwordTextField.text]||![self.passwordTextField.text isEqualToString:[UserSession instance].password]) {
        [self showHUDWithStr:@"当前密码错误" withSuccess:NO];
        return;
    }else if (![JWTools isRightPassWordWithStr:self.passwordNewTextField.text]) {
        [self showHUDWithStr:@"新密码错误" withSuccess:NO];
        return;
    }else if (![self.rePasswordNewTextField.text isEqualToString:self.passwordNewTextField.text]) {
        [self showHUDWithStr:@"新密码不一致" withSuccess:NO];
        return;
    }
    
    [self requestChangeData];
}
- (IBAction)saveBtnAction:(id)sender {
    [self saveInfo];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        [self saveInfo];
    }
    return YES;
}

#pragma mark - HTTP
- (void)requestChangeData{
    NSDictionary * pragram = @{@"pwd":self.passwordTextField.text,@"npwd":self.passwordNewTextField.text,@"uid":[UserSession instance].token};
    [[HttpObject manager]getDataWithType:(kMaldivesType)MaldivesType_InfoChange_Password withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        
        [UserSession instance].password = self.passwordNewTextField.text;
        [KUSERDEFAULT setValue:self.passwordNewTextField.text forKey:AUTOLOGINCODE];
        [self.navigationController popViewControllerAnimated:YES];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",responsObj);
        MyLog(@"Error is %@",error);
        [self showHUDWithStr:responsObj[@"errorMessage"] withSuccess:NO];
    }];
}


@end
