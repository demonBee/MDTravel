//
//  MDPointShopDetailViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/15.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDPointShopDetailViewController.h"
#import "MDAddAddressViewController.h"

#import "MDPointShopDetailTableViewCell.h"

#define POINT_SHOP_DETAIL_CELL @"MDPointShopDetailTableViewCell"
@interface MDPointShopDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)UIImageView * headerImageView;
@property (nonatomic,strong)MDPointShopDetailModel * detailModel;
@property (nonatomic,copy)NSString * payNumber;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation MDPointShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    self.payNumber = @"1";
    [self makeUI];
    [self setupRefresh];
    [self headerRereshing];
}

- (void)makeUI{
    self.submitBtn.layer.cornerRadius = 5.f;
    self.submitBtn.layer.masksToBounds = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:POINT_SHOP_DETAIL_CELL bundle:nil] forCellReuseIdentifier:POINT_SHOP_DETAIL_CELL];
}

- (IBAction)submitBtnAction:(id)sender {
     [self requestPayTest];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.tableView fd_heightForCellWithIdentifier:POINT_SHOP_DETAIL_CELL cacheByIndexPath:indexPath configuration:^(MDPointShopDetailTableViewCell * cell) {
        if (self.detailModel)cell.model = self.detailModel;
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ACTUAL_WIDTH(210.f);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!self.headerImageView) {
        self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.f, 0.f, KScreenWidth, ACTUAL_WIDTH(210.f))];
    }
    if (self.detailModel) {
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.detailModel.pic] placeholderImage:[UIImage imageNamed:@"Product-details-pic"] completed:nil];
    }
    return self.headerImageView;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MDPointShopDetailTableViewCell * detailCell = [tableView dequeueReusableCellWithIdentifier:POINT_SHOP_DETAIL_CELL];
    detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    detailCell.model = self.detailModel;
    detailCell.payNumberGetBlock = ^(NSString * payNumber){
        self.payNumber = payNumber;
    };
    return detailCell;
}
#pragma mark - TableView Refresh
- (void)setupRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
}
- (void)headerRereshing
{
    [self requestDetailData];
}

#pragma mark - HTTP
- (void)requestDetailData{
    NSDictionary * pragram = @{@"id":self.idd};
    [[HttpObject manager]getDataWithType:MaldivesType_POINT_SHOP_DETAIL withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        [self.tableView headerEndRefreshing];
        self.detailModel = [MDPointShopDetailModel yy_modelWithDictionary:responsObj[@"data"]];
        [self.tableView reloadData];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
        [self.tableView headerEndRefreshing];
    }];
}

- (void)requestPayTest{
    NSDictionary * pragram = @{@"uid":[UserSession instance].token,@"id":self.idd,@"num":self.payNumber};
    [[HttpObject manager]getDataWithType:MaldivesType_POINT_SHOP_CANPAY withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        MDAddAddressViewController * vc = [[MDAddAddressViewController alloc]init];
        vc.idd = self.idd;
        vc.payNumber = self.payNumber;
        vc.cost = self.detailModel.points;
        [self.navigationController pushViewController:vc animated:YES];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
        [self showHUDWithStr:errorData[@"errorMessage"] withSuccess:NO];
    }];
}



@end
