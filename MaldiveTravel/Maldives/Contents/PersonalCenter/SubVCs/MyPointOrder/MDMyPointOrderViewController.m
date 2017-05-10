//
//  MDMyPointOrderViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/12.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDMyPointOrderViewController.h"
#import "MDPointShopDetailViewController.h"
#import "MDShipDetailViewController.h"

#import "MDOrderTableViewCell.h"

#define ORDERCELL @"MDOrderTableViewCell"
@interface MDMyPointOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,copy)NSString * pagen;

@property (weak, nonatomic) IBOutlet UIButton *nullShowBtn;


@end

@implementation MDMyPointOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    [self makeNavi];
    [self dataSet];
    [self setupRefresh];
    [self headerRereshing];
}

- (void)makeNavi{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];//调位置
    negativeSpacer.width = -10.f;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, [UIBarButtonItem barItemWithImageName:@"btn-back" withSelectImage:@"btn-back" withHorizontalAlignment:UIControlContentHorizontalAlignmentLeft withTittle:@"" withTittleColor:[UIColor blackColor] withTarget:self action:@selector(backBarButtonAction) forControlEvents:UIControlEventTouchUpInside  withWidth:30.f], nil];
}

- (void)dataSet{
    self.pagen = @"10";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    [self.tableView registerNib:[UINib nibWithNibName:ORDERCELL bundle:nil] forCellReuseIdentifier:ORDERCELL];
}

- (void)backBarButtonAction{
    if (!self.isOrderJust) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 196.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.nullShowBtn.hidden = self.dataArr.count== 0?NO:YES;
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MDOrderTableViewCell * orderCell = [tableView dequeueReusableCellWithIdentifier:ORDERCELL];
    orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    orderCell.model = self.dataArr[indexPath.row];
    orderCell.sureBlock = ^(){
        [self requestFinishOrderWithIndex:indexPath.row];
    };
    orderCell.showBlock = ^(NSString * status){
        //多个状态下显示不同0取消1物流详情2重新购买3物流详情
        MDOrderModel * model = self.dataArr[indexPath.row];
        if ([status isEqualToString:@"0"]) {
            [self requestDeleteOrderWithIndex:indexPath.row];
        }else if ([status isEqualToString:@"2"]){
            MDPointShopDetailViewController * vc = [[MDPointShopDetailViewController alloc]init];
            vc.idd = model.product_id;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            MDShipDetailViewController * vc = [[MDShipDetailViewController alloc]init];
            vc.orderID = model.order_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    
    return orderCell;
}

#pragma mark - TableView Refresh
- (void)setupRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}
- (void)headerRereshing
{
    self.pages = 0;
    [self requestDataWithPages:0];
}
- (void)footerRereshing
{
    self.pages++;
    [self requestDataWithPages:self.pages];
}
#pragma mark - HTTP
- (void)requestDataWithPages:(NSInteger)page{
    NSDictionary * pragram = @{@"uid":[UserSession instance].token,@"pagen":self.pagen,@"pages":[NSString stringWithFormat:@"%zi",page]};
    [[HttpObject manager]getDataWithType:MaldivesType_POINT_ORDER_LIST withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        if (page == 0) {
            //下拉刷新
            [self.tableView headerEndRefreshing];
            [self.dataArr removeAllObjects];
        }else{
            //上拉刷新
            [self.tableView footerEndRefreshing];
        }
        NSArray * data = responsObj[@"data"];
        for (NSDictionary * dataDic in data) {
            [self.dataArr addObject:[MDOrderModel yy_modelWithDictionary:dataDic]];
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

- (void)requestDeleteOrderWithIndex:(NSInteger)index{
    MDOrderModel * model = self.dataArr[index];
    NSDictionary * pragram = @{@"uid":[UserSession instance].token,@"id":model.orderID,@"status":@"cancel"};
    [[HttpObject manager]getDataWithType:MaldivesType_POINT_ORDER_CANCEL withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        [self showHUDWithStr:@"Success" withSuccess:YES];
        model.status = @"3";
        [self.tableView reloadData];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
    }];
}

- (void)requestFinishOrderWithIndex:(NSInteger)index{
    MDOrderModel * model = self.dataArr[index];
    NSDictionary * pragram = @{@"uid":[UserSession instance].token,@"id":model.orderID,@"status":@"complete"};
    [[HttpObject manager]getDataWithType:MaldivesType_POINT_ORDER_FINISH withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        [self showHUDWithStr:@"Success" withSuccess:YES];
        [self.tableView headerBeginRefreshing];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
    }];
}

@end
