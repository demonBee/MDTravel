//
//  MDHotelPhotoViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/17.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDHotelPhotoViewController.h"
#import "MDHotelPhotoImgCollectionViewCell.h"
#import "MDLoginViewController.h"

#import "MDHotelRightBtn.h"
#import "MDPhotoScrollView.h"
#import "SDWebImageManager.h"

#define HOTEL_PHOTO_IMG_CELL @"MDHotelPhotoImgCollectionViewCell"
@interface MDHotelPhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,assign)NSInteger states;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong)NSMutableArray * dataKeyArr;//关键字
@property (nonatomic,strong)NSMutableArray * dataArr;//所有数值
@property (nonatomic,strong)NSMutableArray * selectArr;//选择数组
@property (nonatomic,strong)NSMutableArray * selectImgArr;//选择数组对应的图片数组

@property (nonatomic,strong)NSArray * allDataArr;//所有数据
@property (nonatomic,strong)MDHotelRightBtn * rightBarBtn;

@property (nonatomic,assign)NSInteger showCount;

@end

@implementation MDHotelPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相册";
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self dataSet];
    [self makeNavi];
    [self setupRefresh];
    [self requestPicDate];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.rightBarBtn.isOn)[self.rightBarBtn tapPhotoAction];
}

- (void)makeNavi{
    if (!self.rightBarBtn) {
        self.rightBarBtn = [[[NSBundle mainBundle]loadNibNamed:@"MDHotelRightBtn" owner:nil options:nil]firstObject];
        self.rightBarBtn.frame = CGRectMake(0.f, 0.f, 120.f, 24.f);
        WEAKSELF;
        self.rightBarBtn.photoType = self.type;
        self.rightBarBtn.isPhoto = @"1";
        self.rightBarBtn.choosePhotoTypeBlock = ^(NSInteger status,NSInteger type){
            //选择排序种类
            weakSelf.states = status;
            weakSelf.type = type;
            
            [weakSelf.collectionView headerBeginRefreshing];
        };
    }
    if (self.allDataArr){
        self.rightBarBtn.photoTypeArr = self.dataKeyArr;
        self.rightBarBtn.isPhoto = @"1";
    }
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];//调位置
    negativeSpacer.width = - 5.f;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, [[UIBarButtonItem alloc]initWithCustomView:self.rightBarBtn], nil];
}
- (void)dataSet{
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:HOTEL_PHOTO_IMG_CELL bundle:nil] forCellWithReuseIdentifier:HOTEL_PHOTO_IMG_CELL];
    self.showCount = 10;
    self.dataKeyArr = [NSMutableArray arrayWithCapacity:0];
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
}

- (void)dataArrSetWithArr:(NSArray *)dataArr{
    [dataArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull typeDic, NSUInteger type, BOOL * _Nonnull stop) {
        
        __block NSMutableArray * keyArr = [NSMutableArray arrayWithCapacity:0];
        __block NSMutableArray * valueArr = [NSMutableArray arrayWithCapacity:0];
        [typeDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull typeKey, NSArray *  _Nonnull stateArr, BOOL * _Nonnull stop) {
            
            [keyArr addObject:typeKey];
            [stateArr enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull stateDic, NSUInteger state, BOOL * _Nonnull stop) {
                
                [stateDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull statekey, NSArray *  _Nonnull picArr, BOOL * _Nonnull stop) {
                    __block NSInteger keyCount = 0;
                    [keyArr enumerateObjectsUsingBlock:^(NSString * _Nonnull arrKey, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([statekey isEqualToString:arrKey]) {
                            NSMutableArray * valuArrTemp = [NSMutableArray arrayWithArray:valueArr[idx-1]];
                            [valuArrTemp addObjectsFromArray:picArr];
                            [valueArr replaceObjectAtIndex:(idx-1) withObject:valuArrTemp];
                        }else{
                            keyCount++;
                        }
                    }];
                    if (keyCount >= keyArr.count) {
                        [keyArr addObject:statekey];
                        [valueArr addObject:picArr];
                    }
                   
                }];
            }];
        }];
        
        [self.dataKeyArr addObject:keyArr];
        [self.dataArr addObject:valueArr];
    }];
    
    [self selectArrSet];
}

- (void)selectArrSet{
    self.selectArr = [NSMutableArray arrayWithCapacity:0];
    self.selectImgArr = [NSMutableArray arrayWithCapacity:0];
    if (self.states == 0) {
        NSArray * typeArr = self.dataArr[self.type];
        WEAKSELF;
        [typeArr enumerateObjectsUsingBlock:^(NSArray *  _Nonnull picArr, NSUInteger idx, BOOL * _Nonnull stop){
            [weakSelf.selectArr addObjectsFromArray:picArr];
            [weakSelf.selectImgArr addObjectsFromArray:picArr];
        }];
        
    }else{
        self.selectArr = self.dataArr[self.type][self.states - 1];
        self.selectImgArr = self.dataArr[self.type][self.states - 1];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.showCount > self.selectArr.count?self.selectArr.count : self.showCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MDHotelPhotoImgCollectionViewCell * imgCell = [collectionView dequeueReusableCellWithReuseIdentifier:HOTEL_PHOTO_IMG_CELL forIndexPath:indexPath];
    [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:self.selectArr[indexPath.row]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        UIImage * imageTemp = image;
        if (!imageTemp) {
            imageTemp = [UIImage imageNamed:@"pic-photo "];
        }
        imgCell.showImageView.image = imageTemp;
        [self.selectImgArr replaceObjectAtIndex:indexPath.row withObject:imageTemp];
    }];
    
    return imgCell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (![UserSession instance].isLogin) {
        MDLoginViewController * vc = [[MDLoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSMutableArray * imgArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i<self.selectImgArr.count; i++) {
            if ([self.selectImgArr[i] isKindOfClass:[UIImage class]]) {
                [imgArr addObject:self.selectImgArr[i]];
            }
        }
        MDPhotoScrollView * photosView= [[MDPhotoScrollView alloc]initWithFrame:CGRectMake(0.f, 0.f, KScreenWidth, KScreenHeight) withPicArr:imgArr withSelectIndex:indexPath.row];
        [[UIApplication sharedApplication].keyWindow addSubview:photosView];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellWidth = (KScreenWidth - 30.f)/2;
    return CGSizeMake(cellWidth, cellWidth);
}

#pragma mark - CollectionView Refresh
- (void)setupRefresh
{
    [self.collectionView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [self.collectionView addFooterWithTarget:self action:@selector(footerRereshing)];
}
- (void)headerRereshing{
    [self requestPicDate];
}
- (void)footerRereshing{
    [self.collectionView footerEndRefreshing];
    self.showCount += 10;
    [self.collectionView reloadData];
}

#pragma mark - HTTP
- (void)requestPicDate{
    //一次请求所有图片都有了
    if (self.allDataArr.count > 0){
        [self.collectionView headerEndRefreshing];
        self.showCount = 10;
        [self selectArrSet];
        [self.collectionView reloadData];
        return;
    }
    
    NSDictionary * pragram = @{@"id":self.idd};
    [[HttpObject manager]getDataWithType:self.isEvent?MaldivesType_EVENT_PIC:MaldivesType_HOTEL_PIC withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        self.allDataArr = responsObj[@"data"];
        [self dataArrSetWithArr:responsObj[@"data"]];
        [self makeNavi];
        MyLog(@"Data is %@",self.allDataArr);
        [self.collectionView reloadData];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
    }];
    
}


@end
