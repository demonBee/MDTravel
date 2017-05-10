//
//  JXLcoationViewController.m
//  即刻出行
//
//  Created by scjy on 16/5/14.
//  Copyright © 2016年 WeiBang. All rights reserved.
//

#import "JXLcoationViewController.h"
#import "AreaSelectView.h"
#import <CoreLocation/CoreLocation.h>

@interface JXLcoationViewController ()<CLLocationManagerDelegate>
//{
//    MBProgressHUD *hud;
//}
@property (nonatomic,strong) AreaSelectView *areaSelectView;
@property (nonatomic, strong) CLLocationManager *mgr;
@property (nonatomic, strong) CLGeocoder *geo;

@end

@implementation JXLcoationViewController

- (CLLocationManager *)mgr{
    if (!_mgr) {
        _mgr = [[CLLocationManager alloc] init];
        _mgr.delegate = self;
    }
    return _mgr;
}

- (CLGeocoder *)geo{
    if (!_geo) {
        _geo = [[CLGeocoder alloc] init];
    }
    return _geo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"选择城市";
    _isLocationCity = NO;
    
    //判断是否有能够获取位置信息的设备
//    if (![CLLocationManager locationServicesEnabled]) {
//        NSLog(@"请打开手机定位功能");
//    }

//#ifdef __IPHONE_8_0
//    
//    [self.mgr requestAlwaysAuthorization];
//    
//#else
//    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"正在加载中...";
    
    //请求位置信息
//    [manager startUpdatingLocation];
//    
//#endif
    
    self.areaSelectView = [[AreaSelectView alloc] initWithFrame:CGRectMake(0, 64.f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64.f)];
    self.areaSelectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.areaSelectView ];
    WEAKSELF;
    self.areaSelectView.selectedCityBlock = ^(AreaModel * area){
        weakSelf.selectedCityBlock(area);
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };

}


//改变授权的时候，调用的方法
//- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
//    
//    if (kCLAuthorizationStatusAuthorizedAlways == status) {
//        
//        //请求位置信息
//        [manager startUpdatingLocation];
//    }
//    
//}

//当获取到位置信息的时候调用
//改方法，会频繁调用
//- (void)locationManager:(CLLocationManager *)manager
//     didUpdateLocations:(NSArray<CLLocation *> *)locations{
//    
//    CLLocation *location = [locations lastObject];
//    
//    if (!_isLocationCity) {
//        //地理位置反编码
//        [self.geo reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//            
//            //CLPlacemark：位置标记类，包括一切位置所需要的数据
//            [placemarks enumerateObjectsUsingBlock:^(CLPlacemark * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                
//                _areaSelectView.locationCity = obj.locality;
//                
//                _isLocationCity = YES;
//                
////                hud.labelText = @"定位成功";
////                hud.mode = MBProgressHUDModeText;
////                [hud hide:YES afterDelay:1.2];
//            }];
//        }];
//
//    }
//    
//    if (locations.count == 0) {
////        hud.labelText = @"定位失败";
////        hud.mode = MBProgressHUDModeText;
////        [hud hide:YES afterDelay:1.2];
//    }
// 
//}
//
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
//    NSLog(@"error = %@",error);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
