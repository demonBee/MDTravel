//
//  MDDiscoverViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDDiscoverViewController.h"
#import "MDHotelDetailVCViewController.h"

#import "MDEventTableViewCell.h"

#define EVENTCELL @"MDEventTableViewCell"
@interface MDDiscoverViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,copy)NSString * pagen;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MDDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"活动";
    [self dataSet];
    [self setupRefresh];
    [self headerRereshing];
}
- (void)dataSet{
    self.pagen = @"6";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    [self.tableView registerNib:[UINib nibWithNibName:EVENTCELL bundle:nil] forCellReuseIdentifier:EVENTCELL];
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MDHotelDetailVCViewController * vc = [[MDHotelDetailVCViewController alloc]init];
    MDEventModel * model = self.dataArr[indexPath.row];
    vc.idd = model.eventID;
    vc.isEvent = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ACTUAL_WIDTH(170.f) + 55.f;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MDEventTableViewCell * eventCell = [tableView dequeueReusableCellWithIdentifier:EVENTCELL];
    eventCell.selectionStyle = UITableViewCellSelectionStyleNone;
    eventCell.model = self.dataArr[indexPath.row];
    return eventCell;
}

#pragma mark - TableView Refresh
- (void)setupRefresh
{
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}
- (void)headerRereshing{
    self.pages = 0;
    [self requestDataWithPages:0];
}
- (void)footerRereshing{
    self.pages++;
    [self requestDataWithPages:self.pages];
}
#pragma mark - HTTP
- (void)requestDataWithPages:(NSInteger)page{
    NSDictionary * pragram = @{@"pagen":self.pagen,@"pages":[NSString stringWithFormat:@"%zi",page]};
    [[HttpObject manager] getDataWithType:MaldivesType_EVENT_LIST withPragram:pragram success:^(id responsObj) {
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
            [self.dataArr addObject:[MDEventModel yy_modelWithDictionary:dataDic]];
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
