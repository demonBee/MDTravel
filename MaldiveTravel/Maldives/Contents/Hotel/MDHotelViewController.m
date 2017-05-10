//
//  MDHotelViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDHotelViewController.h"
#import "MDHotelTableViewCell.h"
#import "MDHotelDetailVCViewController.h"

#import "MDHotelRightBtn.h"

#define HOTELCELL @"MDHotelTableViewCell"
@interface MDHotelViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy)NSString * status;//排序种类
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,copy)NSString * pagen;

@end

@implementation MDHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"酒店";
    [self makeNavi];
    [self dataSet];
    [self setupRefresh];
    [self headerRereshing];
}
- (void)dataSet{
    self.status = @"0";
    self.pagen = @"6";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    [self.tableView registerNib:[UINib nibWithNibName:HOTELCELL bundle:nil] forCellReuseIdentifier:HOTELCELL];
}

- (void)makeNavi{
    MDHotelRightBtn * rightBarBtn = [[[NSBundle mainBundle]loadNibNamed:@"MDHotelRightBtn" owner:nil options:nil]firstObject];
    rightBarBtn.isPhoto = @"0";
    rightBarBtn.frame = CGRectMake(0.f, 0.f, 120.f, 24.f);
    rightBarBtn.chooseTypeBlock = ^(NSString * chooseType){
      //选择排序种类
        self.status = chooseType;
        [self.tableView headerBeginRefreshing];
    };
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];//调位置
    negativeSpacer.width = -5.f;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, [[UIBarButtonItem alloc]initWithCustomView:rightBarBtn], nil];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ACTUAL_WIDTH(160.f) + 73.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MDHotelTableViewCell * hotelCell = [tableView dequeueReusableCellWithIdentifier:HOTELCELL];
    hotelCell.selectionStyle = UITableViewCellSelectionStyleNone;
    hotelCell.model = self.dataArr[indexPath.row];
    return hotelCell;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MDHotelDetailVCViewController * vc = [[MDHotelDetailVCViewController alloc]init];
    MDHotelModel * model = self.dataArr[indexPath.row];
    vc.idd = model.hotelID;
    [self.navigationController pushViewController:vc animated:YES];
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
    NSArray * ztArr = @[@"0",@"star",@"price",@"uprice",@"comment",@"grade"];
    NSDictionary * pragram = @{@"pagen":self.pagen,@"pages":[NSString stringWithFormat:@"%zi",page],@"zt":ztArr[[self.status integerValue]]};
    [[HttpObject manager] getDataWithType:MaldivesType_HOTEL_LIST withPragram:pragram success:^(id responsObj) {
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
            [self.dataArr addObject:[MDHotelModel yy_modelWithDictionary:dataDic]];
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
