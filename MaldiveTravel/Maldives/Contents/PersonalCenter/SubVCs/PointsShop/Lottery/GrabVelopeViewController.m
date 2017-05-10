//
//  GrabVelopeViewController.m
//  AliShake
//
//  Created by 李鹏博 on 15/10/15.
//  Copyright © 2015年 李鹏博. All rights reserved.
//

#import "GrabVelopeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MyPageControl.h"
#import "math.h"
@interface GrabVelopeViewController ()<UIScrollViewDelegate>{
    UIScrollView *_homeScrollView;
    UIScrollView *_grabScrollView;
    MyPageControl*_pageControl;
    int _speed;
    UIImageView *image1;
    UIButton  *image2;
    float random;
    float startValue;
    float endValue;
    NSDictionary *awards;
    NSArray *_data;
    NSString *result;
    UIImageView *_grabImg;
    NSDictionary *_resultDic;
    NSMutableArray *_inventoryArr;
    UIImageView *logoImg;
}

@property (nonatomic,assign)NSInteger failedCount;
@property (nonatomic,copy)NSString * points;

@end

@implementation GrabVelopeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"抽奖";
    [self.view setUserInteractionEnabled:NO];
    _inventoryArr =[[NSMutableArray alloc] initWithCapacity:0];
    _homeScrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-NavigationBarHeight-StatusBarHeight)];
    _homeScrollView.showsVerticalScrollIndicator =NO;
    [self.view addSubview:_homeScrollView];
    _homeScrollView.contentSize =CGSizeMake(0, KScreenWidth*14/32+35+KScreenWidth*88/98);
    
    [self initLogoView];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_grabImg removeFromSuperview];
}
-(void)initLogoView{
    //中奖和没中奖之间的分隔线设有2.5个弧度的盲区，指针不会旋转到的，避免抽奖的时候起争议。
    _data = @[@"上",@"右上",@"右",@"右下",@"下",@"左下",@"左",@"左上"];
    awards = @{@"上":@[@{@"min": @0,@"max":@18}],
               @"右上":@[@{@"min": @27,@"max":@63}],
               @"右":@[@{@"min": @72,@"max":@108}],
               @"右下":@[@{@"min": @117,@"max":@153}],
               @"下":@[@{@"min": @162,@"max":@198}],
               @"左下":@[@{@"min": @207,@"max":@243}],
               @"左":@[@{@"min": @252,@"max":@288}],
               @"左上":@[@{@"min": @297,@"max":@333}],
               @"上":@[@{@"min": @342,@"max":@360}]};
    
    _speed =0;
    
    logoImg =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth*14/32)];
    logoImg.image =[UIImage imageNamed:@"组-2"];
    [_homeScrollView addSubview:logoImg];
    [self loadGrabData];
}
-(void)loadGrabData{
    [self requestData];
}
-(void)initInventoryView{
    _grabScrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, KScreenWidth*14/32, KScreenWidth, 25)];
    _grabScrollView.backgroundColor =[UIColor colorWithHexString:@"720207"];
    _grabScrollView.contentSize =CGSizeMake(0, 25*_inventoryArr.count);
    _grabScrollView.pagingEnabled =YES;
    _grabScrollView.userInteractionEnabled =NO;
    [_homeScrollView addSubview:_grabScrollView];
    for (NSInteger i=0; i<_inventoryArr.count; i++) {
        NSDictionary *inventDic =[_inventoryArr objectAtIndex:i];
        NSString *grabStr =[NSString stringWithFormat:@"%@抽中了%@元现金礼包",[inventDic objectForKey:@"str_phone"],[inventDic objectForKey:@"Invent_money"]];
        UILabel *grabLable =[[UILabel alloc] initWithFrame:CGRectMake(15, 25*i, KScreenWidth-30, 25)];
        grabLable.textColor =[UIColor whiteColor];
        grabLable.font =[UIFont systemFontOfSize:12.0f];
        grabLable.text =grabStr;
        [_grabScrollView addSubview:grabLable];
    }
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(mactionlogo) userInfo:nil repeats:YES];
}
-(void)mactionlogo{
    _speed++;
    if (_speed==_inventoryArr.count-1) {
        _speed=0;
    }
    [_grabScrollView setContentOffset:CGPointMake(0, 25*_speed) animated:YES];
}
-(void)initGrabViewWithPic:(NSString *)pic{
    CGFloat grabHeight =KScreenWidth*88/98;
    _grabImg =[[UIImageView alloc] initWithFrame:CGRectMake(0, KScreenWidth*14/32+25, KScreenWidth, grabHeight)];
    [_grabImg sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"cjbg.jpg"] completed:nil];
    _grabImg.userInteractionEnabled =YES;
    image1 =_grabImg;
    [_homeScrollView addSubview:_grabImg];
    
    UIButton *grabBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    grabBtn.center =CGPointMake(KScreenWidth/2, _grabImg.height/2);
    grabBtn.bounds =CGRectMake(0, 0, 43*KScreenWidth/98, 43*KScreenWidth/98);
    [grabBtn setBackgroundImage:[UIImage imageNamed:@"cjzp"] forState:UIControlStateNormal];
    [grabBtn addTarget:self action:@selector(grabClick:) forControlEvents:UIControlEventTouchUpInside];
    
    image2 =grabBtn;
    [_grabImg addSubview:grabBtn];

}
-(void)grab{
    image2.userInteractionEnabled =YES;
}
-(void)grabClick:(UIButton*)button{
    [self performSelector:@selector(grab) withObject:nil afterDelay:3.0f];//三秒内不能再点
    [self requestLotery];
}
- (void)grabClickRunWithResult:(NSString *)resultStr{
    //抽检成功转
    image2.userInteractionEnabled =NO;
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    endValue = [self fetchResultWithResult:resultStr];
    rotationAnimation.delegate = self;
    rotationAnimation.fromValue = @(startValue);
    rotationAnimation.toValue = @(endValue);
    rotationAnimation.duration = 3.0f;
    rotationAnimation.autoreverses = NO;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeBoth;
    [image2.layer addAnimation:rotationAnimation forKey:@"revItUpAnimation"];
}

- (float)fetchResultWithResult:(NSString *)resultStr{
    int i =[resultStr intValue] - 1;
    result = _data[i];  //TEST DATA ,shoud fetch result from remote service
   
    for (NSString *str in [awards allKeys]) {
        if ([str isEqualToString:result]) {
            NSDictionary *content = awards[str][0];
            int min = [content[@"min"] intValue];
            int max = [content[@"max"] intValue];
            
            srand((unsigned)time(0));
            random = rand() % (max - min - 1) +min;
            return radians(random + 360*5);
        }
    }
    
    return radians(random + 360*5);
    
}

//角度转弧度
double radians(float degrees) {
    return degrees*M_PI/180;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    startValue = endValue;
    if (startValue >= endValue) {
        startValue = startValue - radians(360*10);
    }
}

#pragma mark - Http
- (void)requestData{
    [[HttpObject manager]getNoHudWithType:MaldivesType_LOTTORY withPragram:@{} success:^(id responsObj) {
        MyLog(@"Data is %@",responsObj);
        [self initGrabViewWithPic:responsObj[@"data"][@"picb"]];
        self.points = responsObj[@"data"][@"points"];
        [logoImg sd_setImageWithURL:[NSURL URLWithString:responsObj[@"data"][@"pica"]] placeholderImage:[UIImage imageNamed:@"组-2"] completed:nil];
        NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
        NSInteger number = [responsObj[@"data"][@"num"] integerValue];
        for (int i = 0; i< number; i++) {
            [arr addObject:[NSString stringWithFormat:@"%zi",i]];
        }
        _data = [NSArray arrayWithArray:arr];
        CGFloat pi = 360/number - 9;
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [_data enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            [dic setObject:@[@{@"min": @(idx * (pi+9) + 9),@"max":@(idx * (pi+9) + pi)}] forKey:key];
        }];
        awards = [NSDictionary dictionaryWithDictionary:dic];
        
        [self.view setUserInteractionEnabled:YES];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
        if (self.failedCount >= 3) {
            [self.view setUserInteractionEnabled:YES];
            [self showHUDWithStr:@"请求失败" withSuccess:NO];
        }else{
            [self requestData];
        }
        self.failedCount++;
    }];
}

- (void)requestLotery{
    [[HttpObject manager]getNoHudWithType:MaldivesType_LOTTORY_DRAW withPragram:@{@"uid":[UserSession instance].token} success:^(id responsObj) {
        MyLog(@"Data is %@",responsObj);
        [self grabClickRunWithResult:responsObj[@"data"][@"position"]];
        [UserSession instance].point = [NSString stringWithFormat:@"%zi",[[UserSession instance].point integerValue] - [self.points integerValue] + [responsObj[@"data"][@"points"] integerValue]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showHUDWithStr:[NSString stringWithFormat:@"恭喜抽到%@积分",responsObj[@"data"][@"points"]] withSuccess:YES];
        });
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
        [self showHUDWithStr:errorData[@"errorMessage"] withSuccess:NO];
    }];
}


@end
