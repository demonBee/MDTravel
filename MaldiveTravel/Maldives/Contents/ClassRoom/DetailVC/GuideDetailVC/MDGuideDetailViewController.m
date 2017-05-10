//
//  MDGuideDetailViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/10.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDGuideDetailViewController.h"
#import "MDLoginViewController.h"
#import "MDGuideDetailTableViewCell.h"


#define GUIDEDETAILCELL @"MDGuideDetailTableViewCell"
@interface MDGuideDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign)BOOL isLike;
@property (nonatomic,strong)MDGuideModel * model;
@property (nonatomic,assign)NSInteger faildCount;

@end

@implementation MDGuideDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"攻略";
    [self.tableView registerNib:[UINib nibWithNibName:GUIDEDETAILCELL bundle:nil] forCellReuseIdentifier:GUIDEDETAILCELL];
    [self makeNavi];
    [self requestData];
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
    if (self.isLike) {
        [self requestCollectionAddWithID:self.idd withZT:@"gl"];
    }else{
        [self requestCollectionDelWithID:self.idd withZT:@"gl"];
    }
    [self makeNavi];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.tableView fd_heightForCellWithIdentifier:GUIDEDETAILCELL cacheByIndexPath:indexPath configuration:^(MDGuideDetailTableViewCell * cell) {
        cell.model = self.model;
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model?1:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MDGuideDetailTableViewCell * guideCell = [tableView dequeueReusableCellWithIdentifier:GUIDEDETAILCELL];
    guideCell.selectionStyle = UITableViewCellSelectionStyleNone;
    guideCell.model = self.model;
    
    return guideCell;
}

#pragma mark - HTTP
- (void)requestIsCollection{
    NSDictionary * pragram = @{@"zt":@"gl",@"id":self.idd,@"uid":[UserSession instance].token};
    [[HttpObject manager]getDataWithType:MaldivesType_IS_COLLECTION withPragram:pragram success:^(id responsObj){
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

- (void)requestData{
    if (self.faildCount>=2) {
        return;
    }
    NSDictionary * pragram = @{@"id":self.idd};
    [[HttpObject manager]getDataWithType:MaldivesType_GUIDE_DETAIL withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        self.model = [MDGuideModel yy_modelWithDictionary:responsObj[@"data"]];
        [self.tableView reloadData];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
        self.faildCount++;
        [self requestData];
    }];
}

@end
