//
//  UserSession.h
//  GKAPP
//
//  Created by 黄佳峰 on 15/11/6.
//  Copyright © 2015年 黄佳峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSession : NSObject

@property (nonatomic,copy)NSString * token;  //uid   token
@property (nonatomic,copy)NSString * account;  //账户
@property (nonatomic,copy)NSString * logo;      //用户头像
@property (nonatomic,copy)NSString * name;      //用户名user
@property (nonatomic,copy)NSString * realName;      //姓名name
@property (nonatomic,copy)NSString * email;    //邮箱
@property (nonatomic,copy)NSString * sex;     //性别
@property (nonatomic,copy)NSString * birthday;  //生日时间
@property (nonatomic,copy)NSString * city;    //省市区
@property (nonatomic,copy)NSString * password;   //密码
@property (nonatomic,copy)NSString * collection;//收藏数
@property (nonatomic,copy)NSString * newinfo;//新消息new_info
@property (nonatomic,copy)NSString * mobile;//手机号
@property (nonatomic,copy)NSString * userid;
@property (nonatomic,copy)NSString * point;//积分
@property (nonatomic,copy)NSString * grade_point;


@property (nonatomic,assign)BOOL isLogin;   //是否登录



+ (UserSession *) instance;   //单例
+ (void)cleanUser;     //清空

+ (void)saveUserLoginWithAccount:(NSString *)account withPassword:(NSString *)password;  //存数据

+ (void)saveUserInfoWithDic:(NSDictionary *)dataDic;

+ (void)newInfoUp;
+ (void)newInfoDown;

@end
