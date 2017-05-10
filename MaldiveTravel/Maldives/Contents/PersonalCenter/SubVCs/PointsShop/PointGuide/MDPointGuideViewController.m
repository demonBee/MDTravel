//
//  MDPointGuideViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/29.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDPointGuideViewController.h"

@interface MDPointGuideViewController ()


@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation MDPointGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"积分获取说明";
    self.textView.text = @"1.分享成功后获取积分:分享成功获得100积分,每日分享上限3次,超过上限不获取积分;\n\n2.评论获取积分:评论成功获得5积分,游记一次获取25积分,每日获取上限50积分;\n\n3.每日登录获取积分;\n\n4.完善个人信息。";
    [self requestEarnPoints];
}

#pragma mark - HTTP
- (void)requestEarnPoints{
    [[HttpObject manager]getDataWithType:MaldivesType_ABOUTUS_EARN_POINTS withPragram:@{} success:^(id responsObj) {
        MyLog(@"Data is %@",responsObj);
        self.textView.text = responsObj[@"data"];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
    }];
}

@end
