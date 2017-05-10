//
//  MDHotelDetailVCViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/11.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDHotelDetailVCViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "SDWebImageManager.h"

#import "MDLoginViewController.h"
#import "MDCommentViewController.h"
#import "MDHotelPhotoViewController.h"
#import "MDCommentDetailViewController.h"

#import "MDCommentTableViewCell.h"
#import "MDHotelDetailTableViewCell.h"
#import "MDHotelVideoTableViewCell.h"
#import "MDHotelPicTableViewCell.h"
#import "MDCommentTagTableViewCell.h"

#import "MDHotelHeader.h"
#import "MDEventHeader.h"

#define EVENT_HEADER @"MDEventHeader"
#define HOTEL_HEADER @"MDHotelHeader"

#define COMMENT_TAG_CELL @"MDCommentTagTableViewCell"
#define HOTEL_PIC_CELL @"MDHotelPicTableViewCell"
#define HOTEL_VIDEO_CELL @"MDHotelVideoTableViewCell"
#define HOTEL_DETAIL_CELL @"MDHotelDetailTableViewCell"
#define COMMENTCELL @"MDCommentTableViewCell"
@interface MDHotelDetailVCViewController ()<UITableViewDelegate,UITableViewDataSource,AVPlayerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy)NSString * headerID;
@property (nonatomic,strong)NSMutableArray * commentArr;
@property (nonatomic,strong)NSMutableArray * picArr;
@property (nonatomic,assign)NSInteger showCount;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,copy)NSString * pagen;

@property (nonatomic,assign)NSInteger status;//0详情1评论
@property (nonatomic,assign)BOOL isLike;

@property (nonatomic,strong)UIView * segmentedView;
@property (nonatomic,strong)UIView * addMoreView;
@property (nonatomic,strong)UIButton * commentBtn;

@property (nonatomic,strong)NSArray * tagKeyArr;
@property (nonatomic,strong)NSMutableArray * tagArr;

@property (nonatomic,strong)MDHotelDetailModel * model;

@end

@implementation MDHotelDetailVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
    [self makeCommentBtn];
    [self dataSet];
    [self setupRefresh];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.backgroundColor=[UIColor clearColor];
    [self.tableView headerBeginRefreshing];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.automaticallyAdjustsScrollViewInsets = YES;
    //去掉背景图片
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    //去掉底部线条
    [self.navigationController.navigationBar setShadowImage:nil];
    
    self.navigationController.navigationBar.alpha = 1.f;
}
- (void)dataSet{
    self.pagen = @"6";
    self.showCount = 4;
    self.tagKeyArr = @[@"交通方便",@"服务态度好",@"整洁干净",@"含早餐",@"性价比高",@"设施齐全"];
    self.tagArr = [NSMutableArray arrayWithCapacity:0];
    self.commentArr = [NSMutableArray arrayWithCapacity:0];
    self.picArr = [NSMutableArray arrayWithCapacity:0];
    
    if (self.isEvent) {
        [self.tableView registerNib:[UINib nibWithNibName:EVENT_HEADER bundle:nil] forHeaderFooterViewReuseIdentifier:EVENT_HEADER];
    }else{
        [self.tableView registerNib:[UINib nibWithNibName:HOTEL_HEADER bundle:nil] forHeaderFooterViewReuseIdentifier:HOTEL_HEADER];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:HOTEL_PIC_CELL bundle:nil] forCellReuseIdentifier:HOTEL_PIC_CELL];
    [self.tableView registerNib:[UINib nibWithNibName:HOTEL_VIDEO_CELL bundle:nil] forCellReuseIdentifier:HOTEL_VIDEO_CELL];
    [self.tableView registerNib:[UINib nibWithNibName:HOTEL_DETAIL_CELL bundle:nil] forCellReuseIdentifier:HOTEL_DETAIL_CELL];
    [self.tableView registerNib:[UINib nibWithNibName:COMMENTCELL bundle:nil] forCellReuseIdentifier:COMMENTCELL];
    [self.tableView registerNib:[UINib nibWithNibName:COMMENT_TAG_CELL bundle:nil] forCellReuseIdentifier:COMMENT_TAG_CELL];
}
- (void)makeNavi{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];//调位置
    negativeSpacer.width = -10.f;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, [UIBarButtonItem barItemWithImageName:@"activity-content-btn-back" withSelectImage:@"activity-content-btn-back" withHorizontalAlignment:UIControlContentHorizontalAlignmentLeft withTittle:@"" withTittleColor:[UIColor blackColor] withTarget:self action:@selector(backBarButtonAction) forControlEvents:UIControlEventTouchUpInside  withWidth:30.f], nil];
    
    if (!self.isEvent) {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, [UIBarButtonItem barItemWithImageName:@"activity-content-btn-share" withSelectImage:@"activity-content-btn-share" withHorizontalAlignment:UIControlContentHorizontalAlignmentLeft withTittle:@"" withTittleColor:[UIColor blackColor] withTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside  withWidth:30.f],[UIBarButtonItem barItemWithImageName:self.isLike?@"activity-content-btn-collectioned":@"activity-content-btn-collection" withSelectImage:self.isLike?@"activity-content-btn-collectioned":@"activity-content-btn-collection" withHorizontalAlignment:UIControlContentHorizontalAlignmentLeft withTittle:@"" withTittleColor:[UIColor blackColor] withTarget:self action:@selector(collectionBtnAction) forControlEvents:UIControlEventTouchUpInside  withWidth:30.f], nil];
    }else{
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImageName:self.isLike?@"activity-content-btn-collectioned":@"activity-content-btn-collection" withSelectImage:self.isLike?@"activity-content-btn-collectioned":@"activity-content-btn-collection" withHorizontalAlignment:UIControlContentHorizontalAlignmentLeft withTittle:@"" withTittleColor:[UIColor blackColor] withTarget:self action:@selector(collectionBtnAction) forControlEvents:UIControlEventTouchUpInside  withWidth:30.f];
    }
}
- (UISegmentedControl *)makeSegmentedControl{
    UISegmentedControl * segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"图文详情",@"用户评论"]];
    segmentControl.frame = CGRectMake(10.f, 7.f, KScreenWidth - 20.f, 30.f);
    segmentControl.tintColor = [UIColor colorWithHexString:@"#ffc106"];
    segmentControl.selectedSegmentIndex = 0;
    segmentControl.layer.cornerRadius = 5.f;
    segmentControl.layer.masksToBounds = YES;
    segmentControl.layer.borderColor = [UIColor colorWithHexString:@"#ffc106"].CGColor;
    segmentControl.layer.borderWidth = 2.f;
    [segmentControl setTitleTextAttributes:[NSDictionary dicOfTextAttributeWithFont:[UIFont systemFontOfSize:17.f] withTextColor:[UIColor blackColor]] forState:UIControlStateNormal];
    [segmentControl addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged];
    return segmentControl;
}
- (UIButton *)makeAddBtn{
    UIButton * addBtn = [[UIButton alloc]initWithFrame:CGRectMake(10.f, 18.f, KScreenWidth - 20.f, 30.f)];
    [addBtn addTarget:self action:@selector(addMoreBtnAction) forControlEvents:UIControlEventTouchUpInside];
    addBtn.backgroundColor = [UIColor whiteColor];
    [addBtn setTitle:@"加载更多" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    addBtn.layer.cornerRadius = 5.f;
    addBtn.layer.masksToBounds = YES;
    return addBtn;
}
- (void)makeCommentBtn{
    self.commentBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 60.f, KScreenHeight - NavigationHeight - 110.f, 50.f, 50.f)];
    self.commentBtn.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    [self.commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    self.commentBtn.layer.cornerRadius = 25.f;
    self.commentBtn.layer.masksToBounds = YES;
    self.commentBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self.commentBtn addGestureRecognizer:pan];
    [self.commentBtn addTarget:self action:@selector(commentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.commentBtn.hidden = YES;
    [self.view addSubview:self.commentBtn];
}

#pragma mark - ButtonAction
//移动提问按钮
- (void)panAction:(UIPanGestureRecognizer *)pan{
    CGPoint point = [pan translationInView:self.commentBtn];
    self.commentBtn.transform = CGAffineTransformTranslate(self.commentBtn.transform, point.x, point.y);
    [pan setTranslation:CGPointZero inView:self.commentBtn];
}
//提问按钮跳转界面
- (void)commentBtnAction:(UIButton *)sender{
    if (![UserSession instance].isLogin) {
        MDLoginViewController * vc = [[MDLoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    //消除快速点击
    [sender setUserInteractionEnabled:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sender setUserInteractionEnabled:YES];
    });
    MDCommentViewController * vc = [[MDCommentViewController alloc]init];
    vc.idd = self.idd;
    vc.isEvent = self.isEvent;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backBarButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)shareAction{
    if (![UserSession instance].isLogin) {
        MDLoginViewController * vc = [[MDLoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:self.model.pic] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [self makeShareViewWithDic:@{@"image":image,@"shopID":self.model.detailID}];
    }];
}
- (void)collectionBtnAction{
    if (![UserSession instance].isLogin) {
        MDLoginViewController * vc = [[MDLoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    self.isLike = !self.isLike;
    [self makeNavi];
    if (self.isLike) {
        [self requestCollectionAddWithID:self.idd withZT:self.isEvent?@"hd":@"jd"];
    }else{
        [self requestCollectionDelWithID:self.idd withZT:self.isEvent?@"hd":@"jd"];
    }
}
- (void)addMoreBtnAction{
    [self footerRereshing];
}
- (void)segmentControlAction:(UISegmentedControl *)sender{
    self.status = sender.selectedSegmentIndex;
    self.commentBtn.hidden = !self.commentBtn.hidden;
    [self.tableView headerBeginRefreshing];
}
#pragma mark - AVPlayerViewControllerDelegate
- (void)playerViewController:(AVPlayerViewController *)playerViewController failedToStartPictureInPictureWithError:(NSError *)error{
    [playerViewController.player play];
}

#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //滑动隐藏
    if (scrollView.contentOffset.y <0) {
        self.navigationController.navigationBar.hidden = YES;
    }else{
        if (scrollView.contentOffset.y <= 162.f&&scrollView.contentOffset.y >0) {
            CGFloat scale =  1.f - scrollView.contentOffset.y/160.f;
            self.navigationController.navigationBar.alpha = scale;
        }
        self.navigationController.navigationBar.hidden = scrollView.contentOffset.y > 162.f ? YES:NO;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.status == 1) {
        if (indexPath.row == 0) {
            return [self.tableView fd_heightForCellWithIdentifier:COMMENT_TAG_CELL cacheByIndexPath:indexPath configuration:^(MDCommentTagTableViewCell * cell) {
                if(self.tagArr.count > 0){
                    cell.tagArr = self.tagArr;
                }else{
                    cell.tagArr = self.tagKeyArr;
                }
            }];
        }
        return [self.tableView fd_heightForCellWithIdentifier:COMMENTCELL cacheByIndexPath:indexPath configuration:^(MDCommentTableViewCell * cell) {
            cell.model = self.commentArr[indexPath.row - 1];
        }];
    }else{
        if (indexPath.row == 0) {
            return [self.tableView fd_heightForCellWithIdentifier:HOTEL_DETAIL_CELL cacheByIndexPath:indexPath configuration:^(MDHotelDetailTableViewCell * cell) {
                cell.model = self.model;
            }];
        }else{
            return 10.f + 200.f*KScreenWidth/355.f;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 74.f + ACTUAL_WIDTH(200.f);
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0001f;
    }
    return 66.f;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.isEvent) {
            MDEventHeader * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:EVENT_HEADER];
            if (self.model)header.model = self.model;
            return header;
        }else{
            MDHotelHeader * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HOTEL_HEADER];
            if (self.model)header.model = self.model;
            return header;
        }
    }else{
        if (!self.segmentedView) {
            self.segmentedView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KScreenWidth, 44.f)];
            self.segmentedView.backgroundColor = [UIColor whiteColor];
            [self.segmentedView addSubview:[self makeSegmentedControl]];
        }
        if (self.model) {
            UISegmentedControl * segmentControl = (UISegmentedControl *)self.segmentedView.subviews.lastObject;
            [segmentControl setTitle:[NSString stringWithFormat:@"用户评论(%@)",self.model.comment_num] forSegmentAtIndex:1];
        }
        return self.segmentedView;
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        if (!self.addMoreView) {
            self.addMoreView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KScreenWidth, 66.f)];
            self.addMoreView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
            [self.addMoreView addSubview:[self makeAddBtn]];
        }
        return self.addMoreView;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.status == 1) {
        MDCommentDetailViewController * vc = [[MDCommentDetailViewController alloc]init];
        vc.model = self.commentArr[indexPath.row - 1];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    if (self.status == 1) {
        //评论
        return self.commentArr.count + 1;
    }else{
        if (self.showCount > self.picArr.count + 2) {
            return self.picArr.count + 2;
        }
        return self.showCount;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.status == 0) {
        if (indexPath.row == 0) {
            MDHotelDetailTableViewCell * detailCell = [tableView dequeueReusableCellWithIdentifier:HOTEL_DETAIL_CELL];
            detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
            detailCell.model = self.model;
            detailCell.photoBlock = ^(NSInteger index){
                MDHotelPhotoViewController * vc = [[MDHotelPhotoViewController alloc]init];
                vc.idd = self.idd;
                vc.type = index;
                vc.isEvent = self.isEvent;
                [self.navigationController pushViewController:vc animated:YES];
            };
            
            return detailCell;
        }else if (indexPath.row >= self.picArr.count + 1){
            MDHotelVideoTableViewCell * videoCell = [tableView dequeueReusableCellWithIdentifier:HOTEL_VIDEO_CELL];
            videoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.model) {
                videoCell.videoUrlStr = self.model.video;
            }else{
                videoCell.videoUrlStr = @"http://baobab.cdn.wandoujia.com/14468618701471.mp4";
            }
            
            videoCell.readyToPlayBlock = ^(NSString * videoStr){
                AVPlayerViewController *player = [[AVPlayerViewController alloc]init];
                player.player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:videoStr]];
                player.delegate = self;
                [self presentViewController:player animated:YES completion:nil];
                [player.player play];
            };
            return videoCell;
        }else{
            MDHotelPicTableViewCell * picCell = [tableView dequeueReusableCellWithIdentifier:HOTEL_PIC_CELL];
            picCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [picCell.showImageView sd_setImageWithURL:[NSURL URLWithString:self.picArr[indexPath.row - 1]] placeholderImage:[UIImage imageNamed:@"photo-detail"] completed:nil];
            
            return picCell;
        }
    }else{
        if (indexPath.row == 0) {
            MDCommentTagTableViewCell * tagCell = [tableView dequeueReusableCellWithIdentifier:COMMENT_TAG_CELL];
            tagCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(self.tagArr.count > 0){
                tagCell.tagArr = self.tagArr;
            }else{
                tagCell.tagArr = self.tagKeyArr;
            }
            return tagCell;
        }
        //评论
        MDCommentTableViewCell * commentCell = [tableView dequeueReusableCellWithIdentifier:COMMENTCELL];
        commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        commentCell.model = self.commentArr[indexPath.row - 1];
        return commentCell;
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
    [self requestData];
}
- (void)footerRereshing
{
    if (self.status == 0) {
        [self.tableView footerEndRefreshing];
        self.showCount += 4;
        [self.tableView reloadData];
        return;
    }
    self.pages++;
    [self requestDataWithPages:self.pages];
}
#pragma mark - HTTP
- (void)requestData{
    
    if (self.status == 1) {
        //评论
        self.pages = 0;
        [self requestDataWithPages:0];
    }else{
        self.showCount = 4;
        if (self.model) {
            [self.tableView headerEndRefreshing];
            [self.tableView reloadData];
            return;
        }
        [self requestDetail];
    }
}

- (void)requestDetail{
    NSDictionary * pragram = @{@"id":self.idd,@"uid":[UserSession instance].token};
    [[HttpObject manager]getDataWithType:self.isEvent == NO?MaldivesType_HOTEL_DETAIL:MaldivesType_EVENT_DETAIL withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        [self.tableView headerEndRefreshing];
        self.model = [MDHotelDetailModel yy_modelWithDictionary:responsObj[@"data"]];
        if (self.isEvent) {
            NSString * picStr = responsObj[@"data"][@"info_pic"];
            self.picArr = [NSMutableArray arrayWithArray:[picStr componentsSeparatedByString:NSLocalizedString(@",", nil)]];
        }else{
            self.picArr = [NSMutableArray arrayWithArray:responsObj[@"data"][@"info_pic"]];
        }
        self.isLike = [self.model.collection integerValue];
        [self makeNavi];
        [self.tableView reloadData];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
        [self.tableView headerEndRefreshing];
    }];
    
}

//请求评论
- (void)requestDataWithPages:(NSInteger)page{
    NSDictionary * pragram = @{@"id":self.idd,@"pagen":self.pagen,@"pages":[NSString stringWithFormat:@"%zi",page]};
    [[HttpObject manager]getDataWithType:self.isEvent == YES?MaldivesType_EVENT_COMMENT:MaldivesType_HOTEL_COMMENT withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        if (page == 0) {
            //下拉刷新
            [self.tableView headerEndRefreshing];
            [self.commentArr removeAllObjects];
            [self.tagArr removeAllObjects];
        }else{
            //上拉刷新
            [self.tableView footerEndRefreshing];
        }
        if (![responsObj[@"data"] isKindOfClass:[NSArray class]]) {
            //标签
            if (self.tagArr.count <= 0) {
                NSDictionary * tagDic = responsObj[@"data"][@"label"];
                [self.tagKeyArr enumerateObjectsUsingBlock:^(NSString * _Nonnull tagKey, NSUInteger idx, BOOL * _Nonnull stop) {
                    //                [self.tagArr addObject:[tagDic[tagKey] integerValue] <=0?tagKey:[NSString stringWithFormat:@"%@(%@)",tagKey,tagDic[tagKey]]];
                    [self.tagArr addObject:[NSString stringWithFormat:@"%@(%@)",tagKey,tagDic[tagKey]]];
                }];
            }
            //评论
            NSArray * data = responsObj[@"data"][@"pj"];
            for (NSDictionary * dataDic in data) {
                [self.commentArr addObject:[MDCommentModel yy_modelWithDictionary:dataDic]];
            }
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
