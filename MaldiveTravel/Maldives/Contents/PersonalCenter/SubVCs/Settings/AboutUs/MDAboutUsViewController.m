//
//  MDAboutUsViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/12.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDAboutUsViewController.h"

@interface MDAboutUsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation MDAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    [self makeUI];
    [self requestAboutUs];
}
- (void)makeUI{
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KScreenWidth, 10.f)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10.f, CGRectGetMaxY(topView.frame) + 10.f, KScreenWidth - 20.f, 21.f)];
    label.text = @"    海洋国旅-马尔代夫哪里最好玩-实地考察。精选高端酒店。马尔代夫哪里最好玩品质岛屿列表。专业马尔代夫哪里最好玩选岛，马尔代夫高端代理，精选马尔代夫哪里最好玩适合蜜月旅行。是你旅游度假的不二选择，去马尔代夫，享受天堂般的生活。";
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.height = [JWTools labelHeightWithLabel:label];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10.f, CGRectGetMaxY(label.frame) + 5.f, KScreenWidth - 20.f, ACTUAL_WIDTH(200.f))];
    imageView.image =[UIImage imageNamed:@"Product-details-pic"];
    
    if (CGRectGetMaxY(imageView.frame) > KScreenHeight - 64.f) {
        self.scrollView.contentSize = CGSizeMake(KScreenWidth, CGRectGetMaxY(imageView.frame));
    }
    
    [self.scrollView addSubview:topView];
    [self.scrollView addSubview:label];
    [self.scrollView addSubview:imageView];
    
}

#pragma mark - HTTP
- (void)requestAboutUs{
    [[HttpObject manager]getDataWithType:MaldivesType_ABOUTUS withPragram:@{} success:^(id responsObj) {
        MyLog(@"Data is %@",responsObj);
        UILabel * conLabel = (UILabel *)self.scrollView.subviews[self.scrollView.subviews.count - 2];
        conLabel.text = responsObj[@"data"][@"con"];
        conLabel.height = [JWTools labelHeightWithLabel:conLabel];
        UIImageView * conImageView = (UIImageView *)[self.scrollView.subviews lastObject];
        conImageView.y = CGRectGetMaxY(conLabel.frame) + 5.f;
        [conImageView sd_setImageWithURL:[NSURL URLWithString:responsObj[@"data"][@"pic"]] placeholderImage:[UIImage imageNamed:@"Product-details-pic"] completed:nil];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
    }];
}

@end
