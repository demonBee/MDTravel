//
//  MDQuestViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/9.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDQuestViewController.h"
#import "MDTextView.h"

@interface MDQuestViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet MDTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;


@end

@implementation MDQuestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学堂";
    [self makeUI];
}

- (void)makeUI{
    self.textView.layer.cornerRadius = 3.f;
    self.textView.layer.masksToBounds = YES;
    self.textView.placeholder = @"请写下你的疑惑吧，我们将尽快替您解答。";
    [self.textView becomeFirstResponder];
    self.textView.placeholderColor = [UIColor lightGrayColor];
    self.sendBtn.layer.cornerRadius = 3.f;
    self.sendBtn.layer.masksToBounds = YES;
}

- (IBAction)sendBtnAction:(id)sender {
    [self requestQuest];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self requestQuest];
    }
    
    return YES;
}

#pragma mark - HTTP
- (void)requestQuest{
    if ([self.textView.text isEqualToString:@"请写下你的疑惑吧，我们将尽快替您解答。"]||[self.textView.text isEqualToString:@""]) {
        [self showHUDWithStr:@"请输入问题" withSuccess:NO];
        return;
    }
    NSDictionary * pragram = @{@"uid":[UserSession instance].token,@"problem":self.textView.text};
    [[HttpObject manager]getDataWithType:MaldivesType_CLASS_QUEST withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        [self showHUDWithStr:@"Success" withSuccess:YES];
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
