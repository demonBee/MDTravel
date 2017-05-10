//
//  ShareView.h
//  shashou
//
//  Created by Tian Wei You on 16/7/27.
//  Copyright © 2016年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>

@interface MDShareView : UIView

@property (nonatomic,copy)void(^shareClickBlock)(SSDKPlatformType);



@end
