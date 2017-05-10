//
//  MDClassRoomViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDClassRoomViewController.h"
#import "MDSearchView.h"
#import "YJSegmentedControl.h"

#import "MDSearchViewController.h"
#import "MDQuestViewController.h"

#import "MDClassTableViewCell.h"
#import "MDGuideTableViewCell.h"

#define GUIDECELL @"MDGuideTableViewCell"
#define CLASSCELL @"MDClassTableViewCell"
@interface MDClassRoomViewController ()<UITableViewDelegate,UITableViewDataSource,YJSegmentedControlDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)UIButton * questBtn;
@property (nonatomic,assign)NSInteger status;
@property (nonatomic,strong)YJSegmentedControl * segmentControl;
@property (nonatomic,strong)NSMutableArray * classArr;
@property (nonatomic,strong)NSMutableArray * guideArr;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,copy)NSString * pagen;
@property (nonatomic,strong)MDSearchView *searchView;

@end

@implementation MDClassRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    [self makeUI];
    [self registerCellAndTableViewSet];
    [self setupRefresh];
    [self headerRereshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.searchView setUserInteractionEnabled:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.searchView setUserInteractionEnabled:YES];
    });
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)makeUI{
    //搜索
    self.searchView = [[[NSBundle mainBundle]loadNibNamed:@"MDSearchView" owner:nil options:nil]firstObject];
    self.searchView.alpha = 1.0f;
    self.searchView.layer.borderWidth = 1.f;
    self.searchView.layer.borderColor = [UIColor colorWithHexString:@"85b9f7"].CGColor;
    WEAKSELF;
    self.searchView.searchClik = ^(){
        MDSearchViewController * vc = [[MDSearchViewController alloc]init];
        vc.states = weakSelf.status + 1;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    self.searchView.frame = CGRectMake(0.f, 0.f, KScreenWidth - 20.f, 30.f);
    self.navigationItem.titleView = self.searchView;
    
    //选择器
    self.segmentControl = [YJSegmentedControl segmentedControlFrame:CGRectMake(0.f, NavigationHeight, KScreenWidth, 44.f) titleDataSource:@[@"学堂",@"攻略"] backgroundColor:[UIColor colorWithHexString:@"#f0f0f0"] titleColor:[UIColor colorWithHexString:@"#666666"] titleFont:[UIFont boldSystemFontOfSize:17.f] selectColor:[UIColor colorWithHexString:@"#666666"] buttonDownColor:[UIColor colorWithHexString:@"519bf4"] Delegate:self withBtnDownWidth:64.f];
    [self.view addSubview:self.segmentControl];
    //提问按钮
    self.questBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 60.f, KScreenHeight - NavigationHeight - 130.f, 50.f, 50.f)];
    self.questBtn.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    [self.questBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.questBtn setTitle:@"提问" forState:UIControlStateNormal];
    self.questBtn.layer.cornerRadius = 25.f;
    self.questBtn.layer.masksToBounds = YES;
    self.questBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self.questBtn addGestureRecognizer:pan];
    [self.questBtn addTarget:self action:@selector(questBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.questBtn];
}

//移动提问按钮
- (void)panAction:(UIPanGestureRecognizer *)pan{
    CGPoint point = [pan translationInView:self.questBtn];
    self.questBtn.transform = CGAffineTransformTranslate(self.questBtn.transform, point.x, point.y);
    [pan setTranslation:CGPointZero inView:self.questBtn];
}
//提问按钮跳转界面
- (void)questBtnAction:(UIButton *)sender{
    //消除快速点击
    [sender setUserInteractionEnabled:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sender setUserInteractionEnabled:YES];
    });
    MDQuestViewController * vc = [[MDQuestViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)registerCellAndTableViewSet{
    self.classArr = [NSMutableArray arrayWithCapacity:0];
    self.guideArr = [NSMutableArray arrayWithCapacity:0];
    self.pagen = @"10";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:CLASSCELL bundle:nil] forCellReuseIdentifier:CLASSCELL];
    [self.tableView registerNib:[UINib nibWithNibName:GUIDECELL bundle:nil] forCellReuseIdentifier:GUIDECELL];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.status == 0) {
        return [self.tableView fd_heightForCellWithIdentifier:CLASSCELL configuration:^(MDClassTableViewCell * cell) {
            cell.model = self.classArr[indexPath.row];
        }];
    }else{
        return 141.f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.status == 0){
        MDClassDetailViewController * vc = [[MDClassDetailViewController alloc]init];
        vc.model = self.classArr[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        MDGuideDetailViewController * vc = [[MDGuideDetailViewController alloc]init];
        MDGuideModel * model = self.guideArr[indexPath.row];
        vc.idd = model.guideID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.status == 0?self.classArr.count:self.guideArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.status == 0) {
        MDClassTableViewCell * clasCell = [tableView dequeueReusableCellWithIdentifier:CLASSCELL];
        clasCell.selectionStyle = UITableViewCellSelectionStyleNone;
        clasCell.model = self.classArr[indexPath.row];
        return clasCell;
    }else{
        MDGuideTableViewCell * guidCell = [tableView dequeueReusableCellWithIdentifier:GUIDECELL];
        guidCell.selectionStyle = UITableViewCellSelectionStyleNone;
        guidCell.model = self.guideArr[indexPath.row];
        return guidCell;
    }
}
#pragma mark - TableView Refresh
- (void)setupRefresh
{
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

#pragma mark - YJSegmentedControlDelegate
- (void)segumentSelectionChange:(NSInteger)selection{
    self.status = selection;
    if (selection == 1){
        [self.questBtn removeFromSuperview];
    }else{
        [self.view addSubview:self.questBtn];
    }
    [self.tableView headerBeginRefreshing];
}

#pragma mark - HTTP
- (void)requestDataWithPage:(NSInteger)page{
    NSDictionary * pragram = @{@"pagen":self.pagen,@"pages":[NSString stringWithFormat:@"%zi",page]};
    [[HttpObject manager]getDataWithType:self.status == 0?MaldivesType_CLASS_LIST:MaldivesType_GUIDE_LIST withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        NSMutableArray * dataArr;
        if (self.status == 0) {
            dataArr = self.classArr;
        }else{
            dataArr = self.guideArr;
        }
        if (page == 0) {
            //下拉刷新
            [self.tableView headerEndRefreshing];
            [dataArr removeAllObjects];
        }else{
            //上拉刷新
            [self.tableView footerEndRefreshing];
        }
        Class modelClass;
        if (self.status == 0) {
            modelClass = [MDClassModel class];
        }else{
            modelClass = [MDGuideModel class];
        }
        NSArray * data = responsObj[@"data"];
        for (NSDictionary * dataDic in data) {
            [dataArr addObject:[modelClass yy_modelWithDictionary:dataDic]];
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
