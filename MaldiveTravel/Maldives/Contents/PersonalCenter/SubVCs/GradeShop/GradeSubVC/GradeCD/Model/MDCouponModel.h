//
//  MDCouponModel.h
//  Maldives
//
//  Created by TianWei You on 17/1/9.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDCouponModel : NSObject

@property (nonatomic,copy)NSString * couponID;
@property (nonatomic,copy)NSString * amount;
@property (nonatomic,copy)NSString * discount;
@property (nonatomic,copy)NSString * name;
@property (nonatomic,copy)NSString * if_grade_point;

@property (nonatomic,copy)NSString * img;
@property (nonatomic,assign)NSInteger type;//1金钱2折扣

@end
