//
//  MDSuggestSendViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/12.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDSuggestSendViewController.h"
#import "MDTextView.h"

@interface MDSuggestSendViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet MDTextView *suggestTextView;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (nonatomic,strong)UIWebView* callWebview;
@property (nonatomic,copy)NSString * mobile;

@end

@implementation MDSuggestSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self requestMobile];
    [self makeUI];
}
- (void)makeUI{
    self.suggestTextView.placeholder = @"请输入您的意见建议。(500字以内)";
    self.suggestTextView.placeholderColor = [UIColor lightGrayColor];
    self.suggestTextView.layer.cornerRadius = 5.f;
    self.suggestTextView.layer.masksToBounds = YES;
    self.sendBtn.layer.cornerRadius = 5.f;
    self.sendBtn.layer.masksToBounds = YES;
}

- (IBAction)mobileBtnAction:(id)sender {
    if (!self.mobile) return;
    UIWebView* callWebview =[[UIWebView alloc] init];
    NSURL * telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.mobile]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}

- (IBAction)sendBtnAction:(id)sender {
    [self requestSendSuggest];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"%zi",textView.text.length);
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        [self requestSendSuggest];
    }
    return YES;
}

#pragma mark - HTTP
- (void)requestMobile{
    [[HttpObject manager]getDataWithType:MaldivesType_ABOUTUS_SUGGEST_MOBILE withPragram:@{} success:^(id responsObj) {
        MyLog(@"Data is %@",responsObj);
        self.mobile = responsObj[@"data"];
        self.mobileLabel.text = [NSString stringWithFormat:@"紧急问题请拨打:%@-%@-%@",[self.mobile substringWithRange:NSMakeRange(0, 3)],[self.mobile substringWithRange:NSMakeRange(3, 4)],[self.mobile substringFromIndex:7]];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
    }];
}

- (void)requestSendSuggest{
    if ([self.suggestTextView.text isEqualToString:@""]) {
        [self showHUDWithStr:@"请输入意见" withSuccess:NO];
        return;
    }else if (self.suggestTextView.text.length > 500){
        [self showHUDWithStr:@"超出字数限制" withSuccess:NO];
        return;
    }
    
    NSDictionary * pragram = @{@"uid":[UserSession instance].token,@"con":self.suggestTextView.text};
    [[HttpObject manager]getDataWithType:MaldivesType_SUGGEST_SEND withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        [self showHUDWithStr:@"发送成功" withSuccess:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
        
    }];
    
}


@end
