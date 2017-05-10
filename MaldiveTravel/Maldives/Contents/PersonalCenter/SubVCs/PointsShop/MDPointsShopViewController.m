//
//  MDPointsShopViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/12.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDPointsShopViewController.h"
#import "MDPointShopCollectionViewCell.h"
#import "MDPointShopReusableHeaderView.h"
#import "GrabVelopeViewController.h"

#import "MDMyPointsViewController.h"
#import "MDMyPointOrderViewController.h"
#import "MDPointShopDetailViewController.h"
#import "MDPointGuideViewController.h"

#define POINTSHOPHEADER @"MDPointShopReusableHeaderView"
#define POINTSHOPCELL @"MDPointShopCollectionViewCell"
@interface MDPointsShopViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,copy)NSString * pagen;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;

@property (nonatomic,strong)UIButton * awardBtn;

@end

@implementation MDPointsShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"积分商城";
    [self makeUI];
    [self dataSet];
    [self setupRefresh];
    [self headerRereshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.pointLabel.text = [NSString stringWithFormat:@"%@积分",[UserSession instance].point];
}

- (void)dataSet{
    self.pointLabel.text = [NSString stringWithFormat:@"%@积分",[UserSession instance].point];
    
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.pagen = @"10";
    
    [self.collectionView registerNib:[UINib nibWithNibName:POINTSHOPCELL bundle:nil] forCellWithReuseIdentifier:POINTSHOPCELL];
    [self.collectionView registerNib:[UINib nibWithNibName:POINTSHOPHEADER bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:POINTSHOPHEADER];
}

- (void)makeUI{
    self.awardBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 60.f, KScreenHeight - NavigationHeight - 130.f, 50.f, 50.f)];
    self.awardBtn.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    [self.awardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.awardBtn setTitle:@"抽奖" forState:UIControlStateNormal];
    self.awardBtn.layer.cornerRadius = 25.f;
    self.awardBtn.layer.masksToBounds = YES;
    self.awardBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self.awardBtn addGestureRecognizer:pan];
    [self.awardBtn addTarget:self action:@selector(awardBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.awardBtn];
}

//移动提问按钮
- (void)panAction:(UIPanGestureRecognizer *)pan{
    CGPoint point = [pan translationInView:self.awardBtn];
    self.awardBtn.transform = CGAffineTransformTranslate(self.awardBtn.transform, point.x, point.y);
    [pan setTranslation:CGPointZero inView:self.awardBtn];
}
//提问按钮跳转界面
- (void)awardBtnAction:(UIButton *)sender{
    //消除快速点击
    [sender setUserInteractionEnabled:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sender setUserInteractionEnabled:YES];
    });
    GrabVelopeViewController * vc = [[GrabVelopeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)myPointBtnAction:(id)sender {
    MDMyPointsViewController * vc =[[MDMyPointsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)myOrderBtnAction:(id)sender {
    MDMyPointOrderViewController * vc =[[MDMyPointOrderViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)guideBtnAction:(id)sender {
    MDPointGuideViewController * vc = [[MDPointGuideViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MDPointShopCollectionViewCell * pointShopCell = [collectionView dequeueReusableCellWithReuseIdentifier:POINTSHOPCELL forIndexPath:indexPath];
    pointShopCell.model = self.dataArr[indexPath.row];
    return pointShopCell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MDPointShopReusableHeaderView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:POINTSHOPHEADER forIndexPath:indexPath];
        return header;
    }
    return nil;
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellWidth = (KScreenWidth - 30.f)/2;
    return CGSizeMake(cellWidth, cellWidth + 45.f);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MDPointShopDetailViewController * vc = [[MDPointShopDetailViewController alloc]init];
    MDPointShopModel * model = self.dataArr[indexPath.row];
    vc.idd = model.pointID;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - TableView Refresh
- (void)setupRefresh{
    [self.collectionView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [self.collectionView addFooterWithTarget:self action:@selector(footerRereshing)];
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
    [[HttpObject manager]getDataWithType:MaldivesType_POINT_SHOP_LIST withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        if (page == 0) {
            [self.collectionView headerEndRefreshing];
            [self.dataArr removeAllObjects];
        }else{
            [self.collectionView footerEndRefreshing];
        }
        NSArray * data = responsObj[@"data"];
        for (NSDictionary * dataDic in data) {
            [self.dataArr addObject:[MDPointShopModel yy_modelWithDictionary:dataDic]];
        }
        [self.collectionView reloadData];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
        if (page == 0) {
            [self.collectionView headerEndRefreshing];
        }else{
            [self.collectionView footerEndRefreshing];
        }
    }];
}

- (void)showHUDWithStr:(NSString *)showHud{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = showHud;
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.2];
}


@end
