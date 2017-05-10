//
//  MDMyMessageViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/12.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDMyMessageViewController.h"
#import "MDMessageDetailViewController.h"
#import "MDMessageModel.h"
#import "MDMessageTableViewCell.h"

#import "YJSegmentedControl.h"
#define MESSAGECELL @"MDMessageTableViewCell"
@interface MDMyMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *nullShowBtn;

@property (nonatomic,assign)NSInteger status;
@property (nonatomic,strong)YJSegmentedControl * segmentControl;
@property (nonatomic,strong)NSMutableArray * allDataArr;
@property (nonatomic,strong)NSArray * imgArr;
@property (nonatomic,strong)NSArray * conArr;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,copy)NSString * pagen;

@end

@implementation MDMyMessageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的消息";
    [self makeUI];
    [self registerCellAndTableViewSet];
    [self setupRefresh];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView headerBeginRefreshing];
}

- (void)makeUI{
    //选择器
    self.segmentControl = [YJSegmentedControl segmentedControlFrame:CGRectMake(0.f, NavigationHeight, KScreenWidth, 30.f) titleDataSource:@[@"系统通知",@"物流消息",@"留言"] backgroundColor:[UIColor whiteColor] titleColor:[UIColor colorWithHexString:@"#666666"] titleFont:[UIFont boldSystemFontOfSize:17.f] selectColor:[UIColor colorWithHexString:@"#666666"] buttonDownColor:[UIColor colorWithHexString:@"519bf4"] Delegate:self withBtnDownWidth:64.f];
    
    [self.view addSubview:self.segmentControl];
}
- (void)registerCellAndTableViewSet{
    self.allDataArr = [NSMutableArray arrayWithCapacity:0];//0系统通知1物流消息2留言
    for (int i = 0; i < 3; i++) {
        [self.allDataArr addObject:[NSMutableArray arrayWithCapacity:0]];
    }
    
    self.imgArr = @[@"System-notification",@"icon-Logistics-information",@"icon-Leaving-a-message"];
    self.conArr = @[@"系统通知",@"交易物流消息",@"客服回复"];
    self.pagen = @"10";
    
    [self.tableView registerNib:[UINib nibWithNibName:MESSAGECELL bundle:nil] forCellReuseIdentifier:MESSAGECELL];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MDMessageDetailViewController * vc = [[MDMessageDetailViewController alloc]init];
    vc.model = self.allDataArr[self.status][indexPath.row];
    vc.zt = [NSString stringWithFormat:@"%zi",self.status + 1];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray * arr = self.allDataArr[self.status];
    self.nullShowBtn.hidden = arr.count == 0?NO:YES;
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MDMessageTableViewCell * messageCell = [tableView dequeueReusableCellWithIdentifier:MESSAGECELL];
    
    messageCell.imageView.image = [UIImage imageNamed:self.imgArr[self.status]];
    messageCell.textLabel.text = self.conArr[self.status];
    messageCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MDMessageModel * model = self.allDataArr[self.status][indexPath.row];
    messageCell.timeLabel.text = model.create_time;
    messageCell.detailTextLabel.text = model.problem?model.problem:model.con;
    messageCell.isFlook = model.iflook;
    
    return messageCell;
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
    [self requestDataWithPage:0];
}
- (void)footerRereshing
{
    self.pages++;
    [self requestDataWithPage:self.pages];
}

#pragma mark - YJSegmentedControlDelegate
- (void)segumentSelectionChange:(NSInteger)selection{
    self.status = selection;
    [self.tableView headerBeginRefreshing];
}

#pragma mark - HTTP
- (void)requestDataWithPage:(NSInteger)page{
    NSDictionary * pragram = @{@"uid":[UserSession instance].token,@"zt":[NSString stringWithFormat:@"%zi",self.status + 1],@"pagen":self.pagen,@"pages":[NSString stringWithFormat:@"%zi",page]};
    [[HttpObject manager]getDataWithType:MaldivesType_MESSAGE withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        NSMutableArray * dataArr = self.allDataArr[self.status];
        if (page == 0) {
            //下拉刷新
            [self.tableView headerEndRefreshing];
            [dataArr removeAllObjects];
        }else{
            //上拉刷新
            [self.tableView footerEndRefreshing];
        }
        NSArray * data = responsObj[@"data"];
        for (NSDictionary * dataDic in data) {
            [dataArr addObject:[MDMessageModel yy_modelWithDictionary:dataDic]];
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
