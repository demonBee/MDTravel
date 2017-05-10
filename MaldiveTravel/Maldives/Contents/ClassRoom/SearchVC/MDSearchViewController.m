//
//  MDSearchViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/9.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDSearchViewController.h"
#import "MDSearchFillView.h"
#import "MDSearchTagModel.h"

@interface MDSearchViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)MDSearchFillView * searchView;
@property (nonatomic,strong)NSMutableArray * tagArr;

@end

@implementation MDSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.tagArr = [NSMutableArray arrayWithCapacity:0];
    [self requestSearchTag];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self makeNavi];
    [self.searchView.searchTextField becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchView.searchTextField resignFirstResponder];
}
- (void)makeNavi{
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImageName:nil withSelectImage:nil withHorizontalAlignment:UIControlContentHorizontalAlignmentRight withTittle:@"取消" withTittleColor:[UIColor colorWithHexString:@"#85b9f7"] withTarget:self action:@selector(backBarButtonAction) forControlEvents:UIControlEventTouchUpInside  withWidth:40.f];
    
    self.searchView = [[[NSBundle mainBundle]loadNibNamed:@"MDSearchFillView" owner:nil options:nil]firstObject];
    self.searchView.searchTextField.delegate = self;
    WEAKSELF;
    self.searchView.searchBlock = ^(){
        [weakSelf requestSearchWithStr:weakSelf.searchView.searchTextField.text];
    };
    self.navigationItem.titleView = self.searchView;
}

- (void)makeQuickSearchTagWithTagArr:(NSArray *)tagArr{
    UILabel * showLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.f, 74.f, 100.f, 21.f)];
    showLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    showLabel.font = [UIFont systemFontOfSize:14.f];
    showLabel.text = @"热门搜索";
    [self.view addSubview:showLabel];
    
    __block CGFloat btnX = 10.f;
    __block CGFloat btnY = CGRectGetMaxY(showLabel.frame) + 10.f;
    
    NSDictionary * attributes = [NSDictionary dicOfTextAttributeWithFont:[UIFont systemFontOfSize:15.f] withTextColor:[UIColor colorWithHexString:@"#4e4e4e"]];
    [tagArr enumerateObjectsUsingBlock:^(NSString *  _Nonnull tagStr, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect tagRect = [tagStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.f) options:NSStringDrawingUsesFontLeading attributes:attributes context:nil];
        if (btnX + tagRect.size.width + 30.f + 10.f >KScreenWidth) {
            btnX = 10.f;
            btnY += 40.f;
        }
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY, tagRect.size.width + 30.f, 30.f)];
        btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        btn.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
        [btn setTitle:tagStr forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = idx + 100;
        [btn addTarget:self action:@selector(quickSearchAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn.layer.cornerRadius = 15.f;
        btn.layer.masksToBounds = YES;
        btnX += tagRect.size.width + 30.f + 10.f;
    }];
}

- (void)quickSearchAction:(UIButton *)sender{
    //快速搜索，请求接口
    if (self.tagArr.count > 0) {
        NSArray * keyArr = @[@"jd",@"xt",@"gl",@"hd"];
        __block MDSearchTagModel * model = self.tagArr[sender.tag - 100];
        [keyArr enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.searchClass isEqualToString:key]) {
                self.states = idx;
            }
        }];
    }
    [self requestSearchWithStr:sender.titleLabel.text];
}

- (void)requestSearchWithStr:(NSString *)str{
    MDSearchDetailViewController * vc = [[MDSearchDetailViewController alloc]init];
    vc.keyStr = str;
    vc.status = self.states;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        [self requestSearchWithStr:textField.text];
    }
    
    return YES;
}

#pragma mark - HTTP
- (void)requestSearchTag{
    [[HttpObject manager]getDataWithType:MaldivesType_SEARCH_TAG withPragram:@{} success:^(id responsObj) {
        MyLog(@"Data is %@",responsObj);
        NSArray * data = responsObj[@"data"];
        NSMutableArray * tagTittleArr = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary * dataDic in data) {
            [self.tagArr addObject:[MDSearchTagModel yy_modelWithDictionary:dataDic]];
            [tagTittleArr addObject:dataDic[@"keyword"]];
        }
        [self makeQuickSearchTagWithTagArr:tagTittleArr];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
        [self makeQuickSearchTagWithTagArr:@[@"马尔代夫",@"攻略",@"酒店",@"瑞喜敦岛",@"度假村",@"天气"]];
    }];
}


@end
