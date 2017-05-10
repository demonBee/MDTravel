//
//  GlobalInfo.h
//  GKAPP
//
//  Created by 黄佳峰 on 15/11/2.
//  Copyright © 2015年 黄佳峰. All rights reserved.
//

#ifndef GlobalInfo_h
#define GlobalInfo_h


#define HTTP_ADDRESS     @"http://121.42.190.20"    //地址

#define HTTP_REGISTER @"/?m=appapi&s=register&act=register&" //注册账号
#define HTTP_REGISTER_CODE @"/?m=appapi&s=register&act=yanzhen&" //验证码

#define HTTP_LOGIN @"/?m=appapi&s=login&act=login&" //登入
#define HTTP_LOGIN_OUT @"/?m=appapi&s=login&act=logout&" //登出
#define HTTP_LOGIN_FORGET_TEL @"/?m=appapi&s=login&act=fortel&" //忘记密码—手机验证
#define HTTP_LOGIN_FORGET_CODE @"/?m=appapi&s=login&act=foryz&" //忘记密码—发送验证码
#define HTTP_LOGIN_FORGET_PASSWORD @"/?m=appapi&s=login&act=forget&" //忘记密码—修改密码

#define HTTP_INFO_CHANGE_LOGO @"/?m=appapi&s=membercenter&act=up_logo&" //修改个人头像
#define HTTP_INFO_CHANGE_NAME @"/?m=appapi&s=membercenter&act=up_user&" //修改用户名
#define HTTP_INFO_CHANGE_REALNAME @"/?m=appapi&s=membercenter&act=up_name&" //修改姓名
#define HTTP_INFO_CHANGE_SEX @"/?m=appapi&s=membercenter&act=up_sex&" //修改性别
#define HTTP_INFO_CHANGE_BIRTHDAY @"/?m=appapi&s=membercenter&act=up_birthday&" //修改生日
#define HTTP_INFO_CHANGE_CITY @"/?m=appapi&s=membercenter&act=up_city" //修改所在城市
#define HTTP_INFO_CHANGE_EMAIL @"/?m=appapi&s=membercenter&act=send_email&" //修改邮箱
#define HTTP_INFO_CHANGE_EMAIL_COMFIRE @"/?m=appapi&s=membercenter&act=up_email&" //绑定邮箱
#define HTTP_INFO_CHANGE_PASSWORD @"/?m=appapi&s=membercenter&act=forget&" //修改密码

#define HTTP_ABOUTUS @"/?m=appapi&s=system&act=about_us" //关于我们
#define HTTP_ABOUTUS_SUGGEST_MOBILE @"/?m=appapi&s=system&act=feedback" //意见反馈电话
#define HTTP_ABOUTUS_CUSTOMER_MOBILE @"/?m=appapi&s=system&act=consultation" //客服反馈电话
#define HTTP_ABOUTUS_EARN_POINTS @"/?m=appapi&s=system&act=earn_points" //如何赚取积分

#define HTTP_SUGGEST_SEND @"/?m=appapi&s=membercenter&act=feedback&" //发送意见反馈
#define HTTP_CUSTOMER_SEND @"/?m=appapi&s=membercenter&act=consultation&" //发送客服咨询

#define HTTP_MESSAGE @"/?m=appapi&s=membercenter&act=my_news&" //我的消息

#define HTTP_COLLECTION_LIST @"/?m=appapi&s=membercenter&act=collection&" //收藏列表接口
#define HTTP_COLLECTION_ADD @"/?m=appapi&s=membercenter&act=add_collection" //添加收藏
#define HTTP_COLLECTION_DEL @"/?m=appapi&s=membercenter&act=collection&" //删除收藏

#define HTTP_CLASS_LIST @"/?m=appapi&s=school&act=problem&" //学堂列表
#define HTTP_CLASS_QUEST @"/?m=appapi&s=membercenter&act=problem&" //学堂提问

#define HTTP_GUIDE_LIST @"/?m=appapi&s=school&act=raiders&" //攻略列表
#define HTTP_GUIDE_DETAIL @"/?m=appapi&s=school&act=details&" //攻略详情

#define HTTP_IS_COLLECTION @"/?m=appapi&s=school&act=is_collec&" //学堂 攻略 是否被收藏


#define HTTP_POINT_SHOP_LIST @"/?m=appapi&s=points&act=shop&" //积分商品列表显示
#define HTTP_POINT_SHOP_DETAIL @"/?m=appapi&s=points&act=details&" //积分商品详情
#define HTTP_POINT_SHOP_CANPAY @"/?m=appapi&s=membercenter&act=points_buy&" //积分商品是否能购买
#define HTTP_POINT_SHOP_PAY @"/?m=appapi&s=membercenter&act=points_buy&" //积分商品购买

#define HTTP_POINT_ORDER_LIST @"/?m=appapi&s=membercenter&act=points_order&" //积分订单列表显示
#define HTTP_POINT_ORDER_DETAIL @"/?m=appapi&s=membercenter&act=points_details&" //积分订单详情
#define HTTP_POINT_ORDER_CANCEL @"/?m=appapi&s=membercenter&act=points_status&" //积分订单取消
#define HTTP_POINT_ORDER_FINISH @"/?m=appapi&s=membercenter&act=points_status&" //积分订单完成

#define HTTP_POINT_LIST @"/?m=appapi&s=membercenter&act=points_list&" //积分明细列表显示

#define HTTP_SEARCH @"/?m=appapi&s=hotel&act=cable&" //搜索
#define HTTP_SEARCH_TAG @"/?m=appapi&s=hotel&act=keyword" //热门词显示

#define HTTP_HOME @"/?m=appapi&s=hotel&act=homepage&" //首页

#define HTTP_HOTEL_LIST @"/?m=appapi&s=hotel&act=home&" //酒店列表
#define HTTP_HOTEL_DETAIL @"/?m=appapi&s=hotel&act=details&" //酒店详情
#define HTTP_HOTEL_PIC @"/?m=appapi&s=hotel&act=pohto&" //酒店介绍图片显示
#define HTTP_HOTEL_COMMENT @"/?m=appapi&s=hotel&act=evaluate&" //酒店评论列表详情
#define HTTP_HOTEL_COMMENT_ADD @"/?m=appapi&s=membercenter&act=add_rated&" //添加酒店评论

#define HTTP_EVENT_LIST @"/?m=appapi&s=hotel&act=activity&" //活动列表
#define HTTP_EVENT_DETAIL @"/?m=appapi&s=hotel&act=detailed&" //活动详情
#define HTTP_EVENT_PIC @"/?m=appapi&s=hotel&act=view&" //活动介绍图片显示
#define HTTP_EVENT_COMMENT @"/?m=appapi&s=hotel&act=discuss&" //活动评论列表详情
#define HTTP_EVENT_COMMENT_ADD @"/?m=appapi&s=membercenter&act=add_discuss&" //添加活动评论

#define HTTP_COMMENT_PHOTO @"/?m=appapi&s=membercenter&act=uppic&" //添加评论图片

#define HTTP_SHARE_POINT @"/?m=appapi&s=membercenter&act=share&" //分享获得积分

#define HTTP_LOTTORY @"/?m=appapi&s=points&act=display" //抽奖数据显示
#define HTTP_LOTTORY_DRAW @"/?m=appapi&s=membercenter&act=draw&" //积分抽奖



#define HTTP_GRAGE_POINT_LIST @"/?m=appapi&s=membercenter&act=grade_points_list&" //积点列表
#define HTTP_GRAGE_POINT_SHOPLIST @"/?m=appapi&s=grade_points&act=shop&" //积点商城列表
#define HTTP_GRAGE_POINT_DETAILS @"/?m=appapi&s=grade_points&act=details&" //酒店积点兑换接口
#define HTTP_GRAGE_POINT_COUPON @"/?m=appapi&s=membercenter&act=coupon_exchang&" //兑换优惠券
#define HTTP_GRAGE_POINT_COUPONLIST @"/?m=appapi&s=membercenter&act=exchanged_coupon_list&" //我的兑换列表
#define HTTP_GRAGE_POINT_COUPONUSE @"/?m=appapi&s=membercenter&act=use_coupon&" //兑换物品使用接口
//#define HTTP_GRAGE_POINT_ @"/?m=appapi&s=membercenter&act=draw&" //积点抽奖






#endif /* GlobalInfo_h */
