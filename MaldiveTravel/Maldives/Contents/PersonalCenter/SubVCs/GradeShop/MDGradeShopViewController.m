//
//  MDGradeShopViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/11/29.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDGradeShopViewController.h"
#import "MDGradeShopTableViewCell.h"
#import "MDGradeCDViewController.h"
#import "MDCouponListViewController.h"
#import "MDGradeViewController.h"
#import "MDGradeShopHeaderView.h"

@interface MDGradeShopViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,copy)NSString * pagen;

@property (nonatomic,strong)MDGradeShopHeaderView * headerView;

@end

@implementation MDGradeShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"积点商城";
    [self makeUI];
    [self registerCellAndTableViewSet];
    [self setupRefresh];
    [self headerRereshing];
}

- (void)makeUI{
    self.headerView = [[[NSBundle mainBundle]loadNibNamed:@"MDGradeShopHeaderView" owner:nil options:nil]firstObject];
    WEAKSELF;
    self.headerView.gradeListBlock = ^(){
        MDGradeViewController * vc = [[MDGradeViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    self.headerView.changeListBlock = ^(){
        MDCouponListViewController * vc = [[MDCouponListViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
}
- (void)registerCellAndTableViewSet{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.pagen = @"10";
    [self.tableView registerNib:[UINib nibWithNibName:@"MDGradeShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"MDGradeShopTableViewCell"];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55.f;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MDGradeCDViewController * vc = [[MDGradeCDViewController alloc]init];
    MDGradeShopModel * model = self.dataArr[indexPath.row];
    vc.shopID = model.gradeShopID;
    vc.shopImg = model.pic;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MDGradeShopTableViewCell * gradeShopCell = [tableView dequeueReusableCellWithIdentifier:@"MDGradeShopTableViewCell"];
    gradeShopCell.selectionStyle = UITableViewCellSelectionStyleNone;
    gradeShopCell.model = self.dataArr[indexPath.row];
    return gradeShopCell;
}
#pragma mark - TableView Refresh
- (void)setupRefresh{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}
- (void)headerRereshing{
    self.pages = 0;
    [self requestDataWithPage:0];
}
- (void)footerRereshing{
    self.pages++;
    [self requestDataWithPage:self.pages];
}

#pragma mark - HTTP
- (void)requestDataWithPage:(NSInteger)page{
    NSDictionary * pragram = @{@"pagen":self.pagen,@"pages":[NSString stringWithFormat:@"%zi",page]};
    [[HttpObject manager] getDataWithType:MaldivesType_GRAGE_POINT_SHOPLIST withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        if (page == 0) {
            [self.tableView headerEndRefreshing];
            [self.dataArr removeAllObjects];
        }else{
            [self.tableView footerEndRefreshing];
        }
        NSArray * data = responsObj[@"data"];
        for (NSDictionary * dataDic in data) {
            [self.dataArr addObject:[MDGradeShopModel yy_modelWithDictionary:dataDic]];
        }
        [self.tableView reloadData];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
        if (page == 0) {
            [self.tableView headerEndRefreshing];
        }else{
            [self.tableView footerEndRefreshing];
        }
    }];
}

@end
