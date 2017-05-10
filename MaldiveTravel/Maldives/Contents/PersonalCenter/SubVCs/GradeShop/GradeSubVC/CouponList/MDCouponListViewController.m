//
//  MDCouponListViewController.m
//  Maldives
//
//  Created by TianWei You on 17/1/9.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDCouponListViewController.h"
#import "MDCouponDetailTableViewCell.h"

@interface MDCouponListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *nullShowBtn;

@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,copy)NSString * pagen;


@end

@implementation MDCouponListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的兑换";
    [self registerCellAndTableViewSet];
    [self setupRefresh];
    [self headerRereshing];
}

- (void)registerCellAndTableViewSet{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.pagen = @"10";
    [self.tableView registerNib:[UINib nibWithNibName:@"MDCouponDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"MDCouponDetailTableViewCell"];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.tableView fd_heightForCellWithIdentifier:@"MDCouponDetailTableViewCell" cacheByIndexPath:indexPath configuration:^(MDCouponDetailTableViewCell * cell) {
        cell.model = self.dataArr[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MDCouponDetailModel * model = self.dataArr[indexPath.row];
        [self requestUseCouponWithID:model.mem_coupon_id withIDX:indexPath.row];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认使用此奖品?" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:cancelAction];
    [alertVC addAction:OKAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.nullShowBtn.hidden = self.dataArr.count == 0?NO:YES;
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MDCouponDetailTableViewCell * couponCell = [tableView dequeueReusableCellWithIdentifier:@"MDCouponDetailTableViewCell"];
    couponCell.selectionStyle = UITableViewCellSelectionStyleNone;
    couponCell.model = self.dataArr[indexPath.row];
    return couponCell;
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
    NSDictionary * pragram = @{@"uid":[UserSession instance].token,@"pagen":self.pagen,@"pages":[NSString stringWithFormat:@"%zi",page]};
    [[HttpObject manager]getDataWithType:MaldivesType_GRAGE_POINT_COUPONLIST withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        if (page == 0) {//下拉刷新
            [self.tableView headerEndRefreshing];
            [self.dataArr removeAllObjects];
        }else{//上拉刷新
            [self.tableView footerEndRefreshing];
        }
        NSArray * data = responsObj[@"data"];
        for (int i = 0; i<data.count; i++) {
            MDCouponDetailModel * model = [MDCouponDetailModel yy_modelWithDictionary:data[i]];
            if ([model.is_used integerValue]<1||[model.use_time integerValue]<1){
                [self.dataArr addObject:model];
            }
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

- (void)requestUseCouponWithID:(NSString *)couponID withIDX:(NSInteger)idx{
    NSDictionary * pragram = @{@"uid":[UserSession instance].token,@"mem_coupon_id":couponID};
    [[HttpObject manager]getDataWithType:MaldivesType_GRAGE_POINT_COUPONUSE withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        [self.dataArr removeObjectAtIndex:idx];
        [self.tableView reloadData];
        [self showHUDWithStr:@"使用成功" withSuccess:YES];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
        [self showHUDWithStr:@"使用失败" withSuccess:NO];
    }];
}


@end
