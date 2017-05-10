//
//  MDPersonCenterViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDPersonCenterViewController.h"
#import "MDSettingViewController.h"
#import "MDLoginViewController.h"
#import "MDMyCollectionViewController.h"
#import "MDPersonInfoViewController.h"
#import "MDMyMessageViewController.h"
#import "MDPointsShopViewController.h"
#import "MDMyPointsViewController.h"
#import "MDCustomerServiceViewController.h"
#import "MDGradeShopViewController.h"
#import "MDGradeViewController.h"

#import "MDPersonCenterHeaderView.h"
#import "MDPersonBGView.h"

#define PERSON_BGIMG_HEIGHT ACTUAL_WIDTH(240.f)
@interface MDPersonCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray * imgArr;
@property (nonatomic,strong)NSMutableArray * contentArr;
@property (nonatomic,strong)NSArray * subVCClassArr;

@property (nonatomic,strong)UIBarButtonItem * rightBarBtn;
@property (nonatomic,strong)MDPersonBGView * headerBGView;
@property (nonatomic,strong)MDPersonCenterHeaderView * headerView;
@property (nonatomic,assign)CGFloat scale;

@end

@implementation MDPersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.alwaysBounceVertical = YES;
    [self dataSet];
    [self makeUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.backgroundColor=[UIColor clearColor];
    [self isLogin];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.automaticallyAdjustsScrollViewInsets = YES;
    //去掉背景图片
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    //去掉底部线条
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)makeUI{
    self.rightBarBtn = [UIBarButtonItem barItemWithImageName:@"nav_edit" withSelectImage:@"nav_edit" withHorizontalAlignment:UIControlContentHorizontalAlignmentCenter withTittle:@"编辑" withTittleColor:[UIColor whiteColor] withTarget:self action:@selector(editBtnAction) forControlEvents:UIControlEventTouchUpInside withWidth:68.f withBorderColor:[UIColor whiteColor]];
    
    self.headerBGView =[[MDPersonBGView alloc]initWithFrame:CGRectMake(0.f, 0.f, KScreenWidth, ACTUAL_WIDTH(240.f))];
    
    self.headerView = [[[NSBundle mainBundle]loadNibNamed:@"MDPersonCenterHeaderView" owner:nil options:nil] firstObject];
    WEAKSELF;
    self.headerView.loginBlock = ^(){
        MDLoginViewController * vc = [[MDLoginViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    [self.headerBGView addSubview:self.headerView];
}

- (void)viewDidLayoutSubviews{
    self.headerView.frame = CGRectMake(0.f, ACTUAL_WIDTH(68.f), KScreenWidth, 125.f);
}

- (void)isLogin{
    if ([UserSession instance].isLogin){
        self.navigationItem.rightBarButtonItem = self.rightBarBtn;
        self.contentArr = [NSMutableArray arrayWithArray:@[@[[NSString stringWithFormat:@"我的消息(%@)",[UserSession instance].newinfo]],@[[NSString stringWithFormat:@"我的收藏(%@)",[UserSession instance].collection],@"客服咨询"],@[[NSString stringWithFormat:@"我的积分(%@)",[UserSession instance].point],@"积分商城"],@[@"我的积点",@"积点商城"],@[@"设置"]]];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
        //未登录重置
        self.contentArr = [NSMutableArray arrayWithArray:@[@[@"我的消息"],@[@"我的收藏",@"客服咨询"],@[@"我的积分",@"积分商城"],@[@"我的积点",@"积点商城"],@[@"设置"]]];
    }
    [self.tableView reloadData];
    [self.headerView isLogin];
}

- (void)dataSet{
    self.scale = 1.f;
    self.imgArr = @[@[@"icon-my-news"],@[@"icon-collection-0",@"icon-Customer-service-consulting"],@[@"jia",@"icon-Integral-mall"],@[@"jia",@"icon-Integral-mall"],@[@"icon-set"]];
    self.subVCClassArr = @[@[[MDMyMessageViewController class]],@[[MDMyCollectionViewController class],[MDCustomerServiceViewController class]],@[[MDMyPointsViewController class],[MDPointsShopViewController class]],@[[MDGradeViewController class],[MDGradeShopViewController class]],@[[MDSettingViewController class]]];
    self.contentArr = [NSMutableArray arrayWithArray:@[@[@"我的消息"],@[@"我的收藏",@"客服咨询"],@[@"我的积分",@"积分商城"],@[@"我的积点",@"积点商城"],@[@"设置"]]];
}

- (void)editBtnAction{
    MDPersonInfoViewController * vc = [[MDPersonInfoViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return ACTUAL_WIDTH(240.f) + 10.f;
    }
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) return self.headerBGView;
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Class vcClass = (Class)self.subVCClassArr[indexPath.section][indexPath.row];
    if (![UserSession instance].isLogin) {
        vcClass = [MDLoginViewController class];
    }
    UIViewController * vc = [[vcClass alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.contentArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * arr = self.contentArr[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * personCell = [tableView dequeueReusableCellWithIdentifier:@"personCell"];
    if (!personCell) {
        personCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"personCell"];
    }
    personCell.imageView.image = [UIImage imageNamed:self.imgArr[indexPath.section][indexPath.row]];
    personCell.textLabel.text = self.contentArr[indexPath.section][indexPath.row];
    personCell.selectionStyle = UITableViewCellSelectionStyleNone;
    personCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row >= 1) {
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KScreenWidth, 1.f)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#d6d6d6"];
        [personCell addSubview:lineView];
    }
    return personCell;
}

@end
