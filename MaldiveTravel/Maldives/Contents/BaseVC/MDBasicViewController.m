//
//  MDBasicViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDBasicViewController.h"
#import "MDTabBarViewController.h"
#import "MDPersonCenterViewController.h"

#import "WXApi.h"

@interface MDBasicViewController ()

@end

@implementation MDBasicViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - 取消第一响应
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - ButtonAction
- (void)backBarButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Share
- (void)makeShareViewWithDic:(NSDictionary *)sharInfoDic{
    if (!self.shareView) {
        self.shareView = [[MDShareView alloc]init];
        WEAKSELF;
        //SSDKPlatformType
        self.shareView.shareClickBlock = ^(SSDKPlatformType shareType){
            if (sharInfoDic[@"shopID"]) {//2333333
                [weakSelf requestSharedLinkWithType:shareType  withDic:sharInfoDic];
            }else{
                [weakSelf shareButtonClickHandlerWithType:shareType  withDic:sharInfoDic];
            }
        };
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self.shareView];
}

- (void)shareButtonClickHandlerWithType:(SSDKPlatformType)shareType withDic:(NSDictionary *)sharInfoDic{
    //1、创建分享参数
    NSArray* imageArray = @[sharInfoDic[@"image"]];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKEnableUseClientShare];
    if (shareType == SSDKPlatformTypeSinaWeibo) {//2333333酒店链接换成相应url
        //新浪微博
        [shareParams SSDKSetupSinaWeiboShareParamsByText:@"" title:@"珍珠马代" image:imageArray[0] url:[NSURL URLWithString:sharInfoDic[@"shopID"]?[NSString stringWithFormat:@"%@%@",SHARE_HOTEL_HTTP,sharInfoDic[@"shopID"]]:SHARE_HTTP] latitude:0.f longitude:0.f objectID:nil type:SSDKContentTypeAuto];
    }else{
        //微信(微信好友SSDKPlatformSubTypeWechatSession，微信朋友圈SSDKPlatformSubTypeWechatTimeline)应用
        imageArray = @[[JWTools zipImageWithImage:sharInfoDic[@"image"]]];
        [shareParams SSDKSetupWeChatParamsByText:@"" title:@"分享" url:[NSURL URLWithString:sharInfoDic[@"shopID"]?[NSString stringWithFormat:@"%@%@",SHARE_HOTEL_HTTP,sharInfoDic[@"shopID"]]:SHARE_HTTP] thumbImage:imageArray[0] image:imageArray[0] musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:shareType];
    }
    
//    2.编辑页面
    [SSUIEditorViewStyle setiPhoneNavigationBarBackgroundColor:[UIColor cyanColor]];
    [SSUIEditorViewStyle setTitleColor:[UIColor whiteColor]];
    [SSUIEditorViewStyle setCancelButtonLabelColor:[UIColor whiteColor]];
    [SSUIEditorViewStyle setShareButtonLabelColor:[UIColor whiteColor]];
    [SSUIEditorViewStyle setTitle:@"分享"];
    [SSUIEditorViewStyle setCancelButtonLabel:@"  取消"];
    [SSUIEditorViewStyle setShareButtonLabel:@"确认  "];
    [SSUIEditorViewStyle setStatusBarStyle:UIStatusBarStyleDefault];
    
    //3、分享
    [ShareSDK showShareEditor:shareType otherPlatformTypes:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        switch (state) {
            case SSDKResponseStateSuccess:{//分享成功
                [self sharedSuccessWithShopID:(sharInfoDic[@"shopID"]?sharInfoDic[@"shopID"]:@"")];
//                [self showHUDWithStr:@"分享成功" withSuccess:YES];
                break;
            }
            case SSDKResponseStateFail:{//分享失败
                if ((shareType ==SSDKPlatformSubTypeWechatSession||shareType ==SSDKPlatformSubTypeWechatTimeline)&&![WXApi isWXAppInstalled]) {
                    //没有安装微信
                    MyLog(@"没有安装微信!");
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有安装微信" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                    
                    [alert show];
                }else{
                    [self showHUDWithStr:@"分享失败" withSuccess:NO];
                }
                
                break;
            }
            case SSDKResponseStateCancel:{//分享已取消
//                [self sharedSuccess];
                [self showHUDWithStr:@"分享已取消" withSuccess:NO];
            }
            default:
                break;
        }
        
    }];
    
}

#pragma mark - Photo
- (void)makePhotoTake{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [picker setAllowsEditing:YES];
            [picker setDelegate:self];
            [self presentViewController:picker animated:YES completion:nil];
        } else {
            MyLog(@"照片源不可用");
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self makeLocalImagePicker];
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)makeLocalImagePicker{
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVC.allowPickingVideo = NO;
    [imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
        
    }];
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    self.cameraImage = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - MBProgressHUD
- (void)showHUDWithStr:(NSString *)showHud withSuccess:(BOOL)isSuccess{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = showHud;
//    hud.dimBackground = YES;//蒙板
    if (isSuccess) {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    }
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:0.8];
}

#pragma mark - HTTP
- (void)requestCollectionAddWithID:(NSString *)idd withZT:(NSString *)zt{
    NSDictionary * pragram = @{@"id":idd,@"uid":[UserSession instance].token,@"zt":zt};
    [[HttpObject manager]getDataWithType:MaldivesType_COLLECTION_ADD withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        [UserSession instance].collection = [NSString stringWithFormat:@"%zi",[[UserSession instance].collection integerValue] + 1];
        [self showHUDWithStr:@"收藏成功" withSuccess:YES];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
    }];
}

- (void)requestCollectionDelWithID:(NSString *)idd withZT:(NSString *)zts{
    NSDictionary * pragram = @{@"uid":[UserSession instance].token,@"id":idd,@"zt":@"del",@"zts":zts};
    [[HttpObject manager]getDataWithType:MaldivesType_COLLECTION_DEL withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        [UserSession instance].collection = [NSString stringWithFormat:@"%zi",[[UserSession instance].collection integerValue] - 1];
        [self showHUDWithStr:@"取消成功" withSuccess:YES];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
    }];
}

- (void)requestSharedLinkWithType:(SSDKPlatformType)shareType  withDic:(NSDictionary *)sharInfoDic{
    [self shareButtonClickHandlerWithType:shareType  withDic:sharInfoDic];
}

- (void)sharedSuccessWithShopID:(NSString *)shopID{
    //分享成功增加积分接口
    NSMutableDictionary * pragram = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":[UserSession instance].token}];
    if (![shopID isEqualToString:@""])[pragram setObject:shopID forKey:@"hotel_id"];
    
    [[HttpObject manager]getNoHudWithType:MaldivesType_SHARE_POINT withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        [self showHUDWithStr:responsObj[@"errorMessage"] withSuccess:YES];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
        [self showHUDWithStr:@"获取积分失败" withSuccess:NO];
    }];
}


@end
