//
//  HttpObject.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum MaldivesType{
    MaldivesType_Register,//注册
    MaldivesType_ComfireCode,//验证码
    
    MaldivesType_Login,//登入
    MaldivesType_LoginOut,//登出
    
    MaldivesType_Forget_MobileComfire,//忘记密码—手机验证
    MaldivesType_Forget_SendCode,//忘记密码—发送验证码
    MaldivesType_Forget_ChangePassword,//忘记密码—修改密码
    
    MaldivesType_InfoChange_Logo,//修改个人头像
    MaldivesType_InfoChange_UserNmae,//修改用户名
    MaldivesType_InfoChange_RealName,//修改姓名
    MaldivesType_InfoChange_Sex,//修改性别
    MaldivesType_InfoChange_BirthDay,//修改生日
    MaldivesType_InfoChange_City,//修改所在城市
    MaldivesType_InfoChange_Email,//修改邮箱
    MaldivesType_InfoChange_Email_Comfire,//绑定邮箱
    MaldivesType_InfoChange_Password,//修改密码
    
    MaldivesType_ABOUTUS,//关于我们
    MaldivesType_ABOUTUS_SUGGEST_MOBILE,//意见反馈电话
    MaldivesType_ABOUTUS_CUSTOMER_MOBILE,//客服反馈电话
    MaldivesType_ABOUTUS_EARN_POINTS,//如何赚取积分
    
    MaldivesType_MESSAGE,//我的消息
    
    MaldivesType_SUGGEST_SEND,//发送意见反馈
    MaldivesType_CUSTOMER_SEND,//发送客服咨询
    
    MaldivesType_COLLECTION_LIST,//收藏列表接口
    MaldivesType_COLLECTION_ADD,//添加收藏
    MaldivesType_COLLECTION_DEL,//删除收藏
    
    MaldivesType_CLASS_LIST,//学堂列表
    MaldivesType_CLASS_QUEST,//学堂提问
    MaldivesType_GUIDE_LIST,//攻略列表
    MaldivesType_IS_COLLECTION,//学堂 攻略 是否被收藏
    MaldivesType_GUIDE_DETAIL,//攻略详情
    
    MaldivesType_POINT_LIST,//积分明细列表显示
    
    MaldivesType_POINT_SHOP_LIST,//积分商品列表显示
    MaldivesType_POINT_SHOP_DETAIL,//积分商品详情
    MaldivesType_POINT_SHOP_CANPAY,//积分商品是否能购买
    MaldivesType_POINT_SHOP_PAY,//积分商品购买
    
    MaldivesType_POINT_ORDER_LIST,//积分订单列表显示
    MaldivesType_POINT_ORDER_DETAIL,//积分订单详情
    MaldivesType_POINT_ORDER_CANCEL,//积分订单取消
    MaldivesType_POINT_ORDER_FINISH,//积分订单完成
    
    MaldivesType_SEARCH,//搜索
    MaldivesType_SEARCH_TAG,//热门词显示
    
    MaldivesType_Home,//首页
    
    MaldivesType_HOTEL_LIST, //酒店列表
    MaldivesType_HOTEL_DETAIL, //酒店详情
    MaldivesType_HOTEL_PIC, //酒店介绍图片显示
    MaldivesType_HOTEL_COMMENT, //酒店评论列表详情
    MaldivesType_HOTEL_COMMENT_ADD, //添加酒店评论
    
    MaldivesType_EVENT_LIST, //活动列表
    MaldivesType_EVENT_DETAIL, //活动详情
    MaldivesType_EVENT_PIC, //活动介绍图片显示
    MaldivesType_EVENT_COMMENT, //活动评论列表详情
    MaldivesType_EVENT_COMMENT_ADD, //添加活动评论
    
    MaldivesType_SHARE_POINT, //分享获得积分
    
    MaldivesType_LOTTORY, //抽奖数据显示
    MaldivesType_LOTTORY_DRAW, //积分抽奖
    
    MaldivesType_COMMENT_PHOTO, //添加评论图片
    
    MaldivesType_GRAGE_POINT_LIST, //积点列表
    MaldivesType_GRAGE_POINT_SHOPLIST, //积点商城列表
    MaldivesType_GRAGE_POINT_DETAILS, //酒店积点兑换接口
    MaldivesType_GRAGE_POINT_COUPON, //兑换优惠券
    MaldivesType_GRAGE_POINT_COUPONLIST, //我的兑换列表
    MaldivesType_GRAGE_POINT_COUPONUSE, //兑换物品使用接口
    
}kMaldivesType;

@interface HttpObject : NSObject
#pragma mark - Singleton
+ (id)manager;


//GET请求
- (void)getDataWithType:(kMaldivesType)type withPragram:(NSDictionary *)pragram success:(void(^)(id responsObj))success failur:(void(^)(id errorData,NSError *error))fail;

//GET无Hud请求
- (void)getNoHudWithType:(kMaldivesType)type withPragram:(NSDictionary *)pragram success:(void(^)(id responsObj))success failur:(void(^)(id errorData,NSError *error))fail;

//上传照片
- (void)postPhotoWithType:(kMaldivesType)type withPragram:(NSDictionary *)pragram success:(void(^)(id responsObj))success failur:(void(^)(id errorData,NSError *error))fail withPhoto:(NSData *)photo;


@end
