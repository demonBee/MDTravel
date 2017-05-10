//
//  MDShipDetailViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/15.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDShipDetailViewController.h"
#import "MDShipTableViewCell.h"
#import "MDShipDetailTableViewCell.h"

#define SHIPCELL @"MDShipTableViewCell"
#define SHIPDETAILCELL @"MDShipDetailTableViewCell"
@interface MDShipDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)MDShipModel * shipModel;

@end

@implementation MDShipDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"物流详情";
    [self dataSet];
    [self setupRefresh];
    [self headerRereshing];
}

- (void)dataSet{
    [self.tableView registerNib:[UINib nibWithNibName:SHIPCELL bundle:nil] forCellReuseIdentifier:SHIPCELL];
    [self.tableView registerNib:[UINib nibWithNibName:SHIPDETAILCELL bundle:nil] forCellReuseIdentifier:SHIPDETAILCELL];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 90.f;
    }
    return 60.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 15.f;
    }
    return 10.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.shipModel?self.shipModel.logs.count:0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MDShipTableViewCell * shipCell = [tableView dequeueReusableCellWithIdentifier:SHIPCELL];
        shipCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.shipModel)shipCell.model = self.shipModel;
        return shipCell;
    }else{
        MDShipDetailTableViewCell * shipDetailCell =[tableView dequeueReusableCellWithIdentifier:SHIPDETAILCELL];
        shipDetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.shipModel) {
            MDShipDetailModel * detailModel = self.shipModel.logs[indexPath.row];
            shipDetailCell.model = detailModel;
        }
        if (self.shipModel.logs.count == 1) {
            //status:0最新1刚刚开始2只有一个
            shipDetailCell.status = 2;
        }else{
            if (indexPath.row == 0) {
                shipDetailCell.status = 0;
            }else if (indexPath.row == self.shipModel.logs.count - 1){
                shipDetailCell.status = 1;
            }
        }
        
        return shipDetailCell;
    }
}

#pragma mark - TableView Refresh
- (void)setupRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
}
- (void)headerRereshing
{
    [self requsetData];
}

#pragma mark - Http
- (void)requsetData{
    if (self.shipModel) {
        [self.tableView headerEndRefreshing];
        return;
    }
    NSDictionary * pragram = @{@"uid":[UserSession instance].token,@"order":self.orderID};
    [[HttpObject manager]getDataWithType:MaldivesType_POINT_ORDER_DETAIL withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        [self.tableView headerEndRefreshing];
        self.shipModel = [MDShipModel yy_modelWithDictionary:responsObj[@"data"]];
        [self.tableView reloadData];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
        [self.tableView headerEndRefreshing];
    }];
}


@end
