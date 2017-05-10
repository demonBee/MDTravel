//
//  MDEmailComfireViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/22.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDEmailComfireViewController.h"

@interface MDEmailComfireViewController ()


@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation MDEmailComfireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邮箱验证";
    [self makeUI];
}

- (void)makeUI{
    self.saveBtn.layer.cornerRadius = 5.f;
    self.saveBtn.layer.masksToBounds = YES;
    
    [self.textField becomeFirstResponder];
}

- (IBAction)saveBtnAction:(id)sender {
    [self requestChangeEmail];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        [self requestChangeEmail];
    }
    return YES;
}

#pragma mark - HTTP
- (void)requestChangeEmail{
    if ([self.textField.text isEqualToString:@""]) {
        [self showHUDWithStr:@"请输入验证码" withSuccess:NO];
        return;
    }
    NSDictionary * pragram = @{@"uid":[UserSession instance].token,@"email":self.email,@"code":self.textField.text};
    [[HttpObject manager]getDataWithType:MaldivesType_InfoChange_Email_Comfire withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        [UserSession instance].email = self.email;
        
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",responsObj);
        MyLog(@"Error is %@",error);
        [self showHUDWithStr:responsObj[@"errorMessage"] withSuccess:NO];
    }];
}


@end
