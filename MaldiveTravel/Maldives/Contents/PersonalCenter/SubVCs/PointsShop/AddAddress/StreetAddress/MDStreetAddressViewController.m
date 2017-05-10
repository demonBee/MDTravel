//
//  MDStreetAddressViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/15.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDStreetAddressViewController.h"

@interface MDStreetAddressViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation MDStreetAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  =@"街区填写";
    self.sureBtn.layer.cornerRadius = 5.f;
    self.sureBtn.layer.masksToBounds = YES;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

- (IBAction)sureBtnAction:(id)sender {
    if ([self.textField.text isEqualToString:@""]) {
        [self showHUDWithStr:@"请填写街区" withSuccess:NO];
        return;
    }
    self.streetChooseBlock(self.textField.text);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]){
        [textField resignFirstResponder];
        [self sureBtnAction:self.sureBtn];
    }
    
    return YES;
}

@end
