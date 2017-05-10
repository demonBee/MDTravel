//
//  MDBasicViewController.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpObject.h"

#import "TZImagePickerController.h"
#import "MDShareView.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIEditorViewStyle.h>

@interface MDBasicViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,TZImagePickerControllerDelegate>

@property (nonatomic,strong)MDShareView * shareView;
@property (nonatomic,strong)UIImage * cameraImage;

- (void)backBarButtonAction;

- (void)showHUDWithStr:(NSString *)showHud withSuccess:(BOOL)isSuccess;

- (void)makeShareViewWithDic:(NSDictionary *)sharInfoDic;

- (void)makePhotoTake;
- (void)makeLocalImagePicker;

- (void)requestCollectionAddWithID:(NSString *)idd withZT:(NSString *)zt;
- (void)requestCollectionDelWithID:(NSString *)idd withZT:(NSString *)zts;

@end
