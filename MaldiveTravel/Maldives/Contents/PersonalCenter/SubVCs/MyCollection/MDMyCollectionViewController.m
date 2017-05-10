//
//  MDMyCollectionViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/11.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDMyCollectionViewController.h"
#import "YJSegmentedControl.h"
#import "MDHotelDetailVCViewController.h"

#import "MDClassTableViewCell.h"
#import "MDGuideTableViewCell.h"
#import "MDHotelListTableViewCell.h"

#define HOTELLISTCELL @"MDHotelListTableViewCell"
#define GUIDECELL @"MDGuideTableViewCell"
#define CLASSCELL @"MDClassTableViewCell"

@interface MDMyCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *nullShowBtn;

@property (nonatomic,assign)NSInteger status;
@property (nonatomic,strong)YJSegmentedControl * segmentControl;
@property (nonatomic,strong)NSMutableArray * allDataArr;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,copy)NSString * pagen;
@property (nonatomic,strong)NSArray * ztArr;//接口参数

@end

@implementation MDMyCollectionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    [self makeUI];
    [self registerCellAndTableViewSet];
    [self setupRefresh];
    [self headerRereshing];
}
- (void)makeUI{
    //选择器
    self.segmentControl = [YJSegmentedControl segmentedControlFrame:CGRectMake(0.f, NavigationHeight, KScreenWidth, 30.f) titleDataSource:@[@"酒店",@"学堂",@"攻略",@"活动"] backgroundColor:[UIColor whiteColor] titleColor:[UIColor colorWithHexString:@"#666666"] titleFont:[UIFont boldSystemFontOfSize:17.f] selectColor:[UIColor colorWithHexString:@"#666666"] buttonDownColor:[UIColor colorWithHexString:@"519bf4"] Delegate:self withBtnDownWidth:64.f];
    
    [self.view addSubview:self.segmentControl];
}
- (void)registerCellAndTableViewSet{
    self.allDataArr = [NSMutableArray arrayWithCapacity:0];//0hotel,1Class,2Guide,3event
    for (int i = 0; i < 4; i++) {
        [self.allDataArr addObject:[NSMutableArray arrayWithCapacity:0]];
    }
    self.ztArr = @[@"jd",@"xt",@"gl",@"hd"];
    self.pagen = @"10";
    [self.tableView registerNib:[UINib nibWithNibName:HOTELLISTCELL bundle:nil] forCellReuseIdentifier:HOTELLISTCELL];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:GUIDECELL bundle:nil] forCellReuseIdentifier:GUIDECELL];
    [self.tableView registerNib:[UINib nibWithNibName:CLASSCELL bundle:nil] forCellReuseIdentifier:CLASSCELL];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.status == 0 ||self.status == 3) {
        return 120.f;
    }
    if (self.status == 1) {
        return [self.tableView fd_heightForCellWithIdentifier:CLASSCELL configuration:^(MDClassTableViewCell * cell) {
            cell.model = self.allDataArr[self.status][indexPath.row];
        }];
    }else{
        return 141.f;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.status == 0 || self.status == 3) {
        MDHotelDetailVCViewController * vc = [[MDHotelDetailVCViewController alloc]init];
        MDHotelModel * model = self.allDataArr[self.status][indexPath.row];
        vc.idd = model.hotelID;
        vc.isEvent = self.status == 3?YES:NO;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.status == 1){
        MDClassDetailViewController * vc = [[MDClassDetailViewController alloc]init];
        vc.model = self.allDataArr[self.status][indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        MDGuideDetailViewController * vc = [[MDGuideDetailViewController alloc]init];
        MDGuideModel * model = self.allDataArr[self.status][indexPath.row];
        vc.idd = model.guideID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString * delID;
        if (self.status == 0) {
            MDHotelModel * model = self.allDataArr[self.status][indexPath.row];
            delID = model.hotelID;
        }else if (self.status == 1){
            MDClassModel * model = self.allDataArr[self.status][indexPath.row];
            delID = model.classID;
        }else if (self.status == 2){
            MDGuideModel * model = self.allDataArr[self.status][indexPath.row];
            delID = model.guideID;
        }else{
            MDEventModel * model = self.allDataArr[self.status][indexPath.row];
            delID = model.eventID;
        }
        NSArray * ztArr = @[@"jd",@"xt",@"gl",@"hd"];
        NSMutableArray * arr = self.allDataArr[self.status];
        [arr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self requestCollectionDelWithID:delID withZT:ztArr[self.status]];
        if (arr.count <= 0) {
            self.nullShowBtn.hidden = NO;
        }
    }
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray * arr = self.allDataArr[self.status];
    self.nullShowBtn.hidden = arr.count == 0?NO:YES;
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.status == 0||self.status == 3) {//酒店、活动
        MDHotelListTableViewCell * hotelCell = [tableView dequeueReusableCellWithIdentifier:HOTELLISTCELL];
        hotelCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.status == 3) {
            hotelCell.eventModel = self.allDataArr[self.status][indexPath.row];
        }else{
            hotelCell.model = self.allDataArr[self.status][indexPath.row];
        }
        return hotelCell;
    }
    if (self.status == 1) {//学堂
        MDClassTableViewCell * clasCell = [tableView dequeueReusableCellWithIdentifier:CLASSCELL];
        clasCell.selectionStyle = UITableViewCellSelectionStyleNone;
        clasCell.model = self.allDataArr[self.status][indexPath.row];
        return clasCell;
    }else{//攻略
        MDGuideTableViewCell * guidCell = [tableView dequeueReusableCellWithIdentifier:GUIDECELL];
        guidCell.selectionStyle = UITableViewCellSelectionStyleNone;
        guidCell.model = self.allDataArr[self.status][indexPath.row];
        return guidCell;
    }
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
    self.nullShowBtn.hidden = YES;
    [self.tableView headerBeginRefreshing];
}

#pragma mark - HTTP
- (void)requestDataWithPage:(NSInteger)page{
    NSDictionary * pragram = @{@"uid":[UserSession instance].token,@"pagen":self.pagen,@"pages":[NSString stringWithFormat:@"%zi",page],@"zt":self.ztArr[self.status]};
    [[HttpObject manager]getDataWithType:MaldivesType_COLLECTION_LIST withPragram:pragram success:^(id responsObj) {
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
        Class modelClass;
        switch (self.status) {
            case 0:
                modelClass = [MDHotelModel class];
                break;
            case 1:
                modelClass = [MDClassModel class];
                break;
            case 2:
                modelClass = [MDGuideModel class];
                break;
            case 3:
                modelClass = [MDEventModel class];
                break;
                
            default:
                break;
        }
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
