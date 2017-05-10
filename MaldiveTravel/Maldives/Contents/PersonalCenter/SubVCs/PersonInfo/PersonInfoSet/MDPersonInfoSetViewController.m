//
//  MDPersonInfoSetViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/16.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDPersonInfoSetViewController.h"
#import "MDEmailComfireViewController.h"

@interface MDPersonInfoSetViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)NSArray * tittleArr;//0用户名,1邮箱,2姓名,3城市
@property (nonatomic,strong)NSArray * placeholderArr;
@property (nonatomic,strong)NSArray * requestKeyArr;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *fillinTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (nonatomic,assign)NSInteger stateTag;

@end

@implementation MDPersonInfoSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataSet];
    [self makeUI];
}
- (void)dataSet{
    self.tittleArr = @[@"  用户名",@"  邮箱地址",@"  姓名",@"  所在城市"];
    self.placeholderArr = @[@"请输入用户名",@"请输入您的邮箱地址",@"请输入您的姓名",@"您所在的城市"];
    self.requestKeyArr = @[@"user",@"email",@"name",@"city"];
}
- (void)makeUI{
    switch (self.status) {
        case MaldivesType_InfoChange_UserNmae:
            self.stateTag = 0;
            break;
        case MaldivesType_InfoChange_Email:
            self.stateTag = 1;
            break;
        case MaldivesType_InfoChange_RealName:
            self.stateTag = 2;
            break;
        case MaldivesType_InfoChange_City:
            self.stateTag = 3;
            break;
        default:
            break;
    }
    
    NSString * title = self.tittleArr[self.stateTag];
    self.title = [title substringFromIndex:2];
    
    if (self.status == MaldivesType_InfoChange_Email) {
        [self.saveBtn setTitle:@"发送验证邮件" forState:UIControlStateNormal];
    }
    self.saveBtn.layer.cornerRadius = 5.f;
    self.saveBtn.layer.masksToBounds = YES;
    
    self.nameLabel.text = self.tittleArr[self.stateTag];
    self.fillinTextField.placeholder = self.placeholderArr[self.stateTag];
    [self.fillinTextField becomeFirstResponder];
}
- (void)saveInfo{
    if ([self.fillinTextField.text isEqualToString:@""]) {
        [self showHUDWithStr:self.placeholderArr[self.stateTag] withSuccess:NO];
        return;
    }
    if (self.status == MaldivesType_InfoChange_Email){
        if (![JWTools isEmailWithStr:self.fillinTextField.text]) {
            [self showHUDWithStr:self.placeholderArr[1] withSuccess:NO];
            return;
        }
        [self requestSendEmail];
        return;
    }
    NSDictionary * requestDic = @{self.requestKeyArr[self.stateTag]:self.fillinTextField.text};;
    [self requestChangeInfoWithType:self.status withStr:requestDic];
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
- (void)requestChangeInfoWithType:(kMaldivesType)type withStr:(NSDictionary *)infoDic{
    __block NSMutableDictionary * pragram = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":[UserSession instance].token}];
    [infoDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString *  _Nonnull info, BOOL * _Nonnull stop) {
        [pragram setObject:info forKey:key];
    }];
    [[HttpObject manager]getDataWithType:(kMaldivesType)type withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        [self saveInfoSuccess];
        [self.navigationController popViewControllerAnimated:YES];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",responsObj);
        MyLog(@"Error is %@",error);
    }];
}

- (void)saveInfoSuccess{
    switch (self.status) {
        case MaldivesType_InfoChange_UserNmae:
            [UserSession instance].name = self.fillinTextField.text;
            break;
        case MaldivesType_InfoChange_RealName:
            [UserSession instance].realName = self.fillinTextField.text;
            break;
        case MaldivesType_InfoChange_City:
            [UserSession instance].city = self.fillinTextField.text;
            break;
            
        default:
            break;
    }
}

- (void)requestSendEmail{
    NSDictionary * pragram = @{@"email":self.fillinTextField.text,@"uid":[UserSession instance].token};
    [[HttpObject manager]getDataWithType:MaldivesType_InfoChange_Email withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        MDEmailComfireViewController * vc = [[MDEmailComfireViewController alloc]init];
        vc.email = self.fillinTextField.text;
        [self.navigationController pushViewController:vc animated:YES];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
    }];
}


@end
