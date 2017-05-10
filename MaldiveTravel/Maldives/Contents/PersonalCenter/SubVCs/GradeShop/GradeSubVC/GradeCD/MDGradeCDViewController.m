//
//  MDGradeCDViewController.m
//  Maldives
//
//  Created by TianWei You on 17/1/9.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDGradeCDViewController.h"
#import "MDGradeCDTableViewCell.h"

@interface MDGradeCDViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,copy)NSString * pagen;

@end

@implementation MDGradeCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"积点兑换";
    [self registerCellAndTableViewSet];
    [self setupRefresh];
    [self headerRereshing];
}

- (void)registerCellAndTableViewSet{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.pagen = @"10";
    [self.tableView registerNib:[UINib nibWithNibName:@"MDGradeCDTableViewCell" bundle:nil] forCellReuseIdentifier:@"MDGradeCDTableViewCell"];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MDCouponModel * model = self.dataArr[indexPath.row];
        [self requestExchangeWithID:model.couponID];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认兑换此奖品?" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:cancelAction];
    [alertVC addAction:OKAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MDGradeCDTableViewCell * gradeCDShopCell = [tableView dequeueReusableCellWithIdentifier:@"MDGradeCDTableViewCell"];
    gradeCDShopCell.selectionStyle = UITableViewCellSelectionStyleNone;
    gradeCDShopCell.model = self.dataArr[indexPath.row];
    return gradeCDShopCell;
}
#pragma mark - TableView Refresh
- (void)setupRefresh{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
}
- (void)headerRereshing{
    self.pages = 0;
    [self requestDataWithPage:0];
}

#pragma mark - HTTP
- (void)requestDataWithPage:(NSInteger)page{
    NSDictionary * pragram = @{@"hotel_id":self.shopID};
    [[HttpObject manager]getDataWithType:MaldivesType_GRAGE_POINT_DETAILS withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        if (page == 0) {//下拉刷新
            [self.tableView headerEndRefreshing];
            [self.dataArr removeAllObjects];
        }
        NSArray * data = responsObj[@"data"];
        for (int i = 0; i<data.count; i++) {
            MDCouponModel * model = [MDCouponModel yy_modelWithDictionary:data[i]];
            model.img = self.shopImg;
            model.type = [model.amount floatValue]>0?1:2;
            [self.dataArr addObject:model];
        }
        [self.tableView reloadData];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
        [self.tableView headerEndRefreshing];
    }];
}

- (void)requestExchangeWithID:(NSString *)couponID{
    NSDictionary * pragram = @{@"hotel_id":self.shopID,@"id":couponID,@"uid":[UserSession instance].token};
    [[HttpObject manager]getDataWithType:MaldivesType_GRAGE_POINT_COUPON withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        [self showHUDWithStr:@"兑换成功" withSuccess:YES];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
        [self showHUDWithStr:@"积分不足" withSuccess:NO];
    }];
}

@end
