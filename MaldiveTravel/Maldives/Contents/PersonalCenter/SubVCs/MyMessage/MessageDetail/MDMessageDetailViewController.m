//
//  MDMessageDetailViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/16.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDMessageDetailViewController.h"

@interface MDMessageDetailViewController ()
@property (nonatomic,strong) UITextView *textView;

@end

@implementation MDMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息详情";
    [self makeUI];
    [self requestMessageData];
}
- (void)makeUI{
    self.textView=[[UITextView alloc]initWithFrame:CGRectMake(10.f, 10.f + 64.f, KScreenWidth - 20.f, KScreenHeight - 10.f - 64.f)];
    self.textView.font=[UIFont systemFontOfSize:15.f];
    self.textView.editable = NO;
    self.textView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.textView];
    if (self.model.problem) {
        NSMutableAttributedString * quest = [NSString stringWithFirstStr:@"问:" withFont:[UIFont systemFontOfSize:15.f] withColor:[UIColor colorWithHexString:@"#ffc106"] withSecondtStr:self.model.problem withFont:[UIFont systemFontOfSize:15.f] withColor:[UIColor blackColor]];
        NSMutableAttributedString * answer = [NSString stringWithFirstStr:@"\n答:" withFont:[UIFont systemFontOfSize:15.f] withColor:[UIColor colorWithHexString:@"#3CE5B8"] withSecondtStr:self.model.con withFont:[UIFont systemFontOfSize:15.f] withColor:[UIColor blackColor]];
        [quest appendAttributedString:answer];
        self.textView.attributedText = quest;
    }else{
        self.textView.text = self.model.con;
    }
}

#pragma mark - HTTP
- (void)requestMessageData{
    //已读
    NSDictionary * pragram = @{@"zts":self.zt,@"uid":[UserSession instance].token,@"confirm":@"confirm",@"id":self.model.messageID};
    [[HttpObject manager]getDataWithType:MaldivesType_MESSAGE withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        if([self.model.iflook isEqualToString:@"0"]){
            [UserSession newInfoDown];
        }
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
    }];
    
}



@end
