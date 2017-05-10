//
//  MDCouponDetailModel.m
//  Maldives
//
//  Created by TianWei You on 17/1/13.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDCouponDetailModel.h"

@implementation MDCouponDetailModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"couponID" : @"id",@"use_time":@"u_time"};
}

@end
