//
//  HttpObject.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "HttpObject.h"

@implementation HttpObject
+ (id)manager
{
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static HttpObject *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
        
    });
    return manager;
}

- (void)getDataWithType:(kMaldivesType)type withPragram:(NSDictionary *)pragram success:(void(^)(id responsObj))success failur:(void(^)(id errorData,NSError *error))fail{
    NSString * urlStr = HTTP_ADDRESS;
    switch (type) {
#pragma mark - Register
        case MaldivesType_Register://注册
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_REGISTER];
            break;
        case MaldivesType_ComfireCode://验证码
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_REGISTER_CODE];
            break;
#pragma mark - Login
        case MaldivesType_Login://登入
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_LOGIN];
            break;
        case MaldivesType_LoginOut://登出
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_LOGIN_OUT];
            break;
#pragma mark - ForgetPASSWORD
        case MaldivesType_Forget_MobileComfire://忘记密码—手机验证
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_LOGIN_FORGET_TEL];
            break;
        case MaldivesType_Forget_SendCode://忘记密码—发送验证码
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_LOGIN_FORGET_CODE];
            break;
        case MaldivesType_Forget_ChangePassword://忘记密码—修改密码
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_LOGIN_FORGET_PASSWORD];
            break;
#pragma mark - Change Info
        case MaldivesType_InfoChange_UserNmae://修改用户名
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_INFO_CHANGE_NAME];
            break;
        case MaldivesType_InfoChange_RealName://修改姓名
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_INFO_CHANGE_REALNAME];
            break;
        case MaldivesType_InfoChange_Sex://修改性别
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_INFO_CHANGE_SEX];
            break;
        case MaldivesType_InfoChange_BirthDay://修改生日
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_INFO_CHANGE_BIRTHDAY];
            break;
        case MaldivesType_InfoChange_City://修改所在城市
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_INFO_CHANGE_CITY];
            break;
        case MaldivesType_InfoChange_Email://修改邮箱
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_INFO_CHANGE_EMAIL];
            break;
        case MaldivesType_InfoChange_Email_Comfire://绑定邮箱
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_INFO_CHANGE_EMAIL_COMFIRE];
            break;
        case MaldivesType_InfoChange_Password://修改密码
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_INFO_CHANGE_PASSWORD];
            break;
#pragma mark - AboutUs
        case MaldivesType_ABOUTUS://关于我们
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_ABOUTUS];
            break;
        case MaldivesType_ABOUTUS_SUGGEST_MOBILE://意见反馈电话
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_ABOUTUS_SUGGEST_MOBILE];
            break;
        case MaldivesType_ABOUTUS_CUSTOMER_MOBILE://客服反馈电话
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_ABOUTUS_CUSTOMER_MOBILE];
            break;
        case MaldivesType_ABOUTUS_EARN_POINTS://如何赚取积分
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_ABOUTUS_EARN_POINTS];
            break;
#pragma mark - Suggest Send
        case MaldivesType_SUGGEST_SEND://发送意见反馈
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_SUGGEST_SEND];
            break;
        case MaldivesType_CUSTOMER_SEND://发送客服咨询
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_CUSTOMER_SEND];
            break;
#pragma mark - Message
        case MaldivesType_MESSAGE://我的消息
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MESSAGE];
            break;
#pragma mark - Collection
        case MaldivesType_COLLECTION_LIST://收藏列表接口
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_COLLECTION_LIST];
            break;
        case MaldivesType_COLLECTION_ADD://添加收藏
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_COLLECTION_ADD];
            break;
        case MaldivesType_COLLECTION_DEL://删除收藏
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_COLLECTION_DEL];
            break;
#pragma mark - Class & Guide
        case MaldivesType_CLASS_LIST://学堂列表
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_CLASS_LIST];
            break;
        case MaldivesType_CLASS_QUEST://学堂提问
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_CLASS_QUEST];
            break;
        case MaldivesType_GUIDE_LIST://攻略列表
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GUIDE_LIST];
            break;
        case MaldivesType_GUIDE_DETAIL://攻略详情
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GUIDE_DETAIL];
            break;
        case MaldivesType_IS_COLLECTION://学堂 攻略 是否被收藏
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_IS_COLLECTION];
            break;
#pragma mark - Point
        case MaldivesType_POINT_LIST://积分明细列表显示
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_POINT_LIST];
            break;
#pragma mark - Point Shop
        case MaldivesType_POINT_SHOP_LIST://积分商品列表显示
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_POINT_SHOP_LIST];
            break;
        case MaldivesType_POINT_SHOP_DETAIL://积分商品详情
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_POINT_SHOP_DETAIL];
            break;
        case MaldivesType_POINT_SHOP_CANPAY://积分商品是否能购买
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_POINT_SHOP_CANPAY];
            break;
        case MaldivesType_POINT_SHOP_PAY://积分商品购买
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_POINT_SHOP_PAY];
            break;
#pragma mark - Point Order
        case MaldivesType_POINT_ORDER_LIST://积分订单列表显示
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_POINT_ORDER_LIST];
            break;
        case MaldivesType_POINT_ORDER_DETAIL://积分订单详情
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_POINT_ORDER_DETAIL];
            break;
        case MaldivesType_POINT_ORDER_CANCEL://积分订单取消
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_POINT_ORDER_CANCEL];
            break;
        case MaldivesType_POINT_ORDER_FINISH://积分订单完成
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_POINT_ORDER_FINISH];
           break;
#pragma mark - Search
        case MaldivesType_SEARCH://搜索
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_SEARCH];
            break;
        case MaldivesType_SEARCH_TAG://热门词显示
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_SEARCH_TAG];
            break;
#pragma mark - Home
        case MaldivesType_Home://首页
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOME];
            break;
#pragma mark - Hotel
        case MaldivesType_HOTEL_LIST://酒店列表
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOTEL_LIST];
            break;
        case MaldivesType_HOTEL_DETAIL://酒店详情
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOTEL_DETAIL];
            break;
        case MaldivesType_HOTEL_PIC://酒店介绍图片显示
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOTEL_PIC];
            break;
        case MaldivesType_HOTEL_COMMENT://酒店评论列表详情
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOTEL_COMMENT];
            break;
        case MaldivesType_HOTEL_COMMENT_ADD://添加酒店评论
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_HOTEL_COMMENT_ADD];
            break;
#pragma mark - Event
        case MaldivesType_EVENT_LIST://活动列表
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_EVENT_LIST];
            break;
        case MaldivesType_EVENT_DETAIL://活动详情
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_EVENT_DETAIL];
            break;
        case MaldivesType_EVENT_PIC://活动介绍图片显示
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_EVENT_PIC];
            break;
        case MaldivesType_EVENT_COMMENT://活动评论列表详情
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_EVENT_COMMENT];
            break;
        case MaldivesType_EVENT_COMMENT_ADD://添加活动评论
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_EVENT_COMMENT_ADD];
            break;
            
#pragma mark - Grade Point
        case MaldivesType_GRAGE_POINT_LIST://积点列表
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GRAGE_POINT_LIST];
            break;
        case MaldivesType_GRAGE_POINT_SHOPLIST://积点商城列表
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GRAGE_POINT_SHOPLIST];
            break;
        case MaldivesType_GRAGE_POINT_DETAILS://酒店积点兑换接口
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GRAGE_POINT_DETAILS];
            break;
        case MaldivesType_GRAGE_POINT_COUPON://兑换优惠券
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GRAGE_POINT_COUPON];
            break;
        case MaldivesType_GRAGE_POINT_COUPONLIST://我的兑换列表
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GRAGE_POINT_COUPONLIST];
            break;
        case MaldivesType_GRAGE_POINT_COUPONUSE://兑换物品使用
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GRAGE_POINT_COUPONUSE];
            break;
            
           //URLStr建立
        default:
            break;
    }
    HttpManager*manager= [[HttpManager alloc]init];
    [manager getDataFromNetworkWithUrl:urlStr parameters:pragram compliation:^(id data, NSError *error) {
        if ([data[@"errorCode"] isEqualToString:@"0"]||[data[@"errorCode"] isEqualToString:@"1"]||[data[@"errorMessage"] isEqualToString:@"successful"]) {
            success(data);
        }else{
            fail(data,error);
        }
    }];
}


- (void)getNoHudWithType:(kMaldivesType)type withPragram:(NSDictionary *)pragram success:(void(^)(id responsObj))success failur:(void(^)(id errorData,NSError *error))fail{
    NSString * urlStr = HTTP_ADDRESS;
    switch (type) {
#pragma mark - Login
        case MaldivesType_Login://登入
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_LOGIN];
            break;
#pragma mark - Get Point
        case MaldivesType_SHARE_POINT://分享获得积分
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_SHARE_POINT];
            break;
#pragma mark - Lottory
        case MaldivesType_LOTTORY://抽奖数据显示
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_LOTTORY];
            break;
        case MaldivesType_LOTTORY_DRAW://积分抽奖
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_LOTTORY_DRAW];
            break;
            
            //URLStr建立
        default:
            break;
    }
    HttpManager*manager= [[HttpManager alloc]init];
    [manager getDataFromNetworkNOHUDWithUrl:urlStr parameters:pragram compliation:^(id data, NSError *error) {
        if ([data[@"errorCode"] isEqualToString:@"0"]||[data[@"errorCode"] isEqualToString:@"1"]||[data[@"errorMessage"] isEqualToString:@"successful"]) {
            success(data);
        }else{
            fail(data,error);
        }
    }];
}


- (void)postPhotoWithType:(kMaldivesType)type withPragram:(NSDictionary *)pragram success:(void(^)(id responsObj))success failur:(void(^)(id errorData,NSError *error))fail withPhoto:(NSData *)photo{
    NSString * urlStr = HTTP_ADDRESS;
    switch (type) {
#pragma mark - Change Info Logo
        case MaldivesType_InfoChange_Logo://修改个人头像
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_INFO_CHANGE_LOGO];
            break;
            //URLStr建立
#pragma mark - Comment Photo Add
        case MaldivesType_COMMENT_PHOTO://添加评论图片
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_COMMENT_PHOTO];
            break;
        default:
            break;
    }
    HttpManager*manager= [[HttpManager alloc]init];
    [manager postDataUpDataPhotoWithUrl:urlStr parameters:pragram photo:photo compliation:^(id data, NSError *error) {
        if ([data[@"errorCode"] isEqualToString:@"0"]||[data[@"errorMessage"] isEqualToString:@"successful"]) {
            success(data);
            
        }else{
            fail(data,error);
        }
    }];
}

@end
