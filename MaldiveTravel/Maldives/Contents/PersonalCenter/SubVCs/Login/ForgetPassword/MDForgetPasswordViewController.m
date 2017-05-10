//
//  MDForgetPasswordViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/11.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDForgetPasswordViewController.h"
#import "MDReSetPasswordViewController.h"

@interface MDForgetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation MDForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"密码重置";
    [self makeUI];
}
- (void)makeUI{
    self.nextBtn.layer.cornerRadius = 5.f;
    self.nextBtn.layer.masksToBounds = YES;
}

- (IBAction)nextBtnAction:(id)sender {
    if ([JWTools checkTelNumber:self.mobileTextField.text]) {
        [self requestComfireMobile];
    }else{
        [self showHUDWithStr:@"请输入正确的手机号" withSuccess:NO];
    }
}

#pragma mark - Http
- (void)requestComfireMobile{
    NSDictionary * pragram = @{@"tel":self.mobileTextField.text};
    [[HttpObject manager]getDataWithType:MaldivesType_Forget_MobileComfire withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        MDReSetPasswordViewController * vc = [[MDReSetPasswordViewController alloc]init];
        vc.mobile = self.mobileTextField.text;
        [self.navigationController pushViewController:vc animated:YES];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",responsObj);
        MyLog(@"Error is %@",error);
        [self showHUDWithStr:responsObj[@"errorMessage"] withSuccess:NO];
    }];
}


@end
