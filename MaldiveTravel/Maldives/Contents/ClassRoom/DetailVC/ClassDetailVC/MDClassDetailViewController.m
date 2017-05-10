//
//  MDClassDetailViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/10.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDClassDetailViewController.h"
#import "MDLoginViewController.h"

#import "MDClassTableViewCell.h"

#define CLASSCELL @"MDClassTableViewCell"
@interface MDClassDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign)BOOL isLike;

@end

@implementation MDClassDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学堂";
    [self.tableView registerNib:[UINib nibWithNibName:CLASSCELL bundle:nil] forCellReuseIdentifier:CLASSCELL];
    [self makeNavi];
    [self requestIsCollection];
}
- (void)makeNavi{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImageName:self.isLike?@"icon-like":@"icon-dislike" withSelectImage:nil withHorizontalAlignment:UIControlContentHorizontalAlignmentLeft withTittle:@"" withTittleColor:[UIColor blackColor] withTarget:self action:@selector(collectionBtnAction) forControlEvents:UIControlEventTouchUpInside withWidth:30.f];
    
}

- (void)collectionBtnAction{
    if (![UserSession instance].isLogin) {
        MDLoginViewController * vc = [[MDLoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    self.isLike = !self.isLike;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImageName:self.isLike?@"icon-like":@"icon-dislike" withSelectImage:nil withHorizontalAlignment:UIControlContentHorizontalAlignmentLeft withTittle:@"" withTittleColor:[UIColor blackColor] withTarget:self action:@selector(collectionBtnAction) forControlEvents:UIControlEventTouchUpInside withWidth:30.f];
    if (self.isLike) {
        [self requestCollectionAddWithID:self.model.classID withZT:@"xt"];
    }else{
        [self requestCollectionDelWithID:self.model.classID withZT:@"xt"];
    }
}
    
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.tableView fd_heightForCellWithIdentifier:CLASSCELL cacheByIndexPath:indexPath configuration:^(MDClassTableViewCell * cell) {
        cell.bottomView.hidden = YES;
        cell.model = self.model;
    }];
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KScreenWidth, 10.f)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    return headerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MDClassTableViewCell * clasCell = [tableView dequeueReusableCellWithIdentifier:CLASSCELL];
    clasCell.selectionStyle = UITableViewCellSelectionStyleNone;
    clasCell.bottomView.hidden = YES;
    
    clasCell.model = self.model;
    
    return clasCell;
}

#pragma mark - HTTP
- (void)requestIsCollection{
    NSDictionary * pragram = @{@"zt":@"xt",@"id":self.model.classID,@"uid":[UserSession instance].token};
    [[HttpObject manager]getDataWithType:MaldivesType_IS_COLLECTION withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        self.isLike = [[NSString stringWithFormat:@"%@",responsObj[@"data"][@"is_collec"]] isEqualToString:@"0"]?NO:YES;
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImageName:self.isLike?@"icon-like":@"icon-dislike" withSelectImage:nil withHorizontalAlignment:UIControlContentHorizontalAlignmentLeft withTittle:@"" withTittleColor:[UIColor blackColor] withTarget:self action:@selector(collectionBtnAction) forControlEvents:UIControlEventTouchUpInside withWidth:30.f];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
    }];
    
}


@end
