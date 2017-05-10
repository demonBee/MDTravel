//
//  MDHomeViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDHomeViewController.h"
#import "MDSearchView.h"
#import "SDCycleScrollView.h"

#import "MDHotelDetailVCViewController.h"
#import "MDLoginViewController.h"
#import "MDMyMessageViewController.h"
#import "MDSearchViewController.h"

#import "MDHomeBannerModel.h"
#import "MDHotelTableViewCell.h"

#define HOTELCELL @"MDHotelTableViewCell"
@interface MDHomeViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *messageCountBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;

@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSMutableArray * bannerArr;
@property (nonatomic,strong)SDCycleScrollView * bannerView;
@property (nonatomic,strong)MDSearchView *searchView;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,copy)NSString * pagen;

@property (nonatomic,strong)UIView * headerView;

@end

@implementation MDHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self dataSet];
    [self makeSearchBar];
    [self setupRefresh];
    [self headerRereshing];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    
    [self.searchView setUserInteractionEnabled:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.searchView setUserInteractionEnabled:YES];
        //加载完用户单例
        if (![[UserSession instance].newinfo isEqualToString:@"0"]&&[UserSession instance].newinfo) {
            self.messageCountBtn.hidden = NO;
            [self.messageCountBtn setTitle:[UserSession instance].newinfo forState:UIControlStateNormal];
        }else{
            self.messageCountBtn.hidden = YES;
        }
    });
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = YES;
}

-(void)viewDidLayoutSubviews{
    self.searchView.frame = CGRectMake(20.f, 28.f, KScreenWidth - 80.f, 28.f);
}

- (void)dataSet{
    self.pagen = @"4";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.bannerArr = [NSMutableArray arrayWithCapacity:0];
    [self.tableView registerNib:[UINib nibWithNibName:HOTELCELL bundle:nil] forCellReuseIdentifier:HOTELCELL];
    
}

- (void)makeSearchBar{
    self.searchView = [[[NSBundle mainBundle]loadNibNamed:@"MDSearchView" owner:nil options:nil] firstObject];
    WEAKSELF;
    self.searchView.searchClik = ^(){
        MDSearchViewController * vc = [[MDSearchViewController alloc]init];
        vc.states = 0;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [self.view addSubview:self.searchView];
}

- (IBAction)messageBtnAction:(id)sender {
    //通知
    if ([UserSession instance].isLogin) {
        MDMyMessageViewController * vc = [[MDMyMessageViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        MDLoginViewController * vc = [[MDLoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //滑动隐藏
    if (scrollView.contentOffset.y <0) {
        self.searchView.hidden = YES;
    }else{
        if (scrollView.contentOffset.y <= 162.f&&scrollView.contentOffset.y >0) {
            CGFloat scale =  0.8f - scrollView.contentOffset.y/200.f;
            self.searchView.alpha = scale;
            CGFloat btnScale =  1.f - scrollView.contentOffset.y/160.f;
            self.messageCountBtn.alpha = btnScale;
            self.messageBtn.alpha = btnScale;
        }
        self.searchView.hidden = scrollView.contentOffset.y > 162.f ? YES:NO;
    }
    self.messageBtn.hidden = self.searchView.hidden;
    if (![[UserSession instance].newinfo isEqualToString:@"0"]&&[UserSession instance].newinfo){
        self.messageCountBtn.hidden = self.searchView.hidden;
        [self.messageCountBtn setTitle:[UserSession instance].newinfo forState:UIControlStateNormal];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ACTUAL_WIDTH(160.f) + 73.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ACTUAL_WIDTH(227.f) + 5.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!self.headerView) {
        self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KScreenWidth, ACTUAL_WIDTH(227.f) + 5.f)];
        self.headerView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    }
    if (self.bannerArr.count > 0 && !self.bannerView) {
        NSMutableArray * picArr = [NSMutableArray arrayWithCapacity:0];
        for (MDHomeBannerModel * model in self.bannerArr) {
            [picArr addObject:model.picName];
        }
        self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0.f, 0.f, KScreenWidth, ACTUAL_WIDTH(227.f)) imagesGroup:picArr andPlaceholder:@"home-banner"];
        self.bannerView.autoScrollTimeInterval = 5.0f;
        self.bannerView.delegate = self;
        [self.headerView addSubview:self.bannerView];
    }
    return self.headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MDHotelDetailVCViewController * vc = [[MDHotelDetailVCViewController alloc]init];
    MDHotelModel * model = self.dataArr[indexPath.row];
    vc.idd = model.hotelID;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MDHotelTableViewCell * hotelCell = [tableView dequeueReusableCellWithIdentifier:HOTELCELL];
    hotelCell.selectionStyle = UITableViewCellSelectionStyleNone;
    hotelCell.model = self.dataArr[indexPath.row];
    return hotelCell;
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
    NSDictionary * pragram = @{@"pagen":self.pagen,@"pages":[NSString stringWithFormat:@"%zi",page]};
    [[HttpObject manager] getDataWithType:MaldivesType_Home withPragram:pragram success:^(id responsObj) {
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
        if (self.bannerArr.count <= 0) {
            NSArray * bannerArr = responsObj[@"data"][@"gg"];
            for (NSDictionary * bannerDic in bannerArr) {
                [self.bannerArr addObject:[MDHomeBannerModel yy_modelWithDictionary:bannerDic]];
            }
        }
        NSArray * data = responsObj[@"data"][@"jd"];
        for (NSDictionary * dataDic in data) {
            [self.dataArr addObject:[MDHotelModel yy_modelWithDictionary:dataDic]];
        }
        [self.tableView reloadData];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",responsObj);
        MyLog(@"Error is %@",error);
        if (page == 0) {
            [self.tableView headerEndRefreshing];
        }else{
            [self.tableView footerEndRefreshing];
        }
    }];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    MDGuideDetailViewController * vc = [[MDGuideDetailViewController alloc]init];
    MDHomeBannerModel * model = self.bannerArr[index];
    vc.idd = model.bannerID;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
