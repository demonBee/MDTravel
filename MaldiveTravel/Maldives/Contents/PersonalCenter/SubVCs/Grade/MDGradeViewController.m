//
//  MDGradeViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/11/29.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDGradeViewController.h"
#import "MDGradeViewModel.h"

@interface MDGradeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,copy)NSString * pagen;

@end

@implementation MDGradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的积点";
    self.pagen = @"10";
    [self dataSet];
    [self setupRefresh];
    [self headerRereshing];
}

- (void)dataSet{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * gradeCell = [tableView dequeueReusableCellWithIdentifier:@"personGradesCell"];
    if (!gradeCell) {
        gradeCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"personGradesCell"];
    }
    MDGradeViewModel * model = self.dataArr[indexPath.row];
    gradeCell.textLabel.text = model.note;
    gradeCell.textLabel.font = [UIFont systemFontOfSize:16.f];
    
    gradeCell.detailTextLabel.text = [JWTools stringNumberTurnToDateWithNumber:model.c_time];
    gradeCell.detailTextLabel.textColor = [UIColor lightGrayColor];
    gradeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel * pointLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth - 130.f, 1.f, 120.f, 43.f)];
    pointLabel.textColor = [UIColor lightGrayColor];
    pointLabel.textAlignment = NSTextAlignmentRight;
    pointLabel.text = [model.points floatValue]>=0?[NSString stringWithFormat:@"+%@",model.points]:model.points;
    if ([gradeCell viewWithTag:11]) {
        UILabel * label = [gradeCell viewWithTag:11];
        label = pointLabel;
    }else{
        pointLabel.tag = 11;
        [gradeCell addSubview:pointLabel];
    }
    
    if (indexPath.row >= 1) {
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KScreenWidth, 1.f)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#d6d6d6"];
        [gradeCell addSubview:lineView];
    }
    return gradeCell;
}

#pragma mark - TableView Refresh
- (void)setupRefresh{
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
    NSDictionary * pragram = @{@"uid":[UserSession instance].token,@"pagen":self.pagen,@"pages":[NSString stringWithFormat:@"%zi",page]};
    [[HttpObject manager]getDataWithType:MaldivesType_GRAGE_POINT_LIST withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        if (page == 0) {//下拉刷新
            [self.tableView headerEndRefreshing];
            [self.dataArr removeAllObjects];
        }else{//上拉刷新
            [self.tableView footerEndRefreshing];
        }
        NSArray * data = responsObj[@"data"];
        for (NSDictionary * dataDic in data) {
            [self.dataArr addObject:[MDGradeViewModel yy_modelWithDictionary:dataDic]];
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
