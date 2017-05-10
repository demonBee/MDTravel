//
//  MDHotelDetailModle.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/16.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDHotelDetailModel : NSObject
//Hotel&Event
@property (nonatomic,copy)NSString * detailID;
@property (nonatomic,copy)NSString * video;
@property (nonatomic,copy)NSString * one_num;
@property (nonatomic,copy)NSString * one_pic;
@property (nonatomic,copy)NSString * tow_num;
@property (nonatomic,copy)NSString * tow_pic;
@property (nonatomic,copy)NSString * three_num;
@property (nonatomic,copy)NSString * three_pic;
@property (nonatomic,copy)NSString * pic;
@property (nonatomic,copy)NSString * title;
@property (nonatomic,copy)NSString * price;
@property (nonatomic,copy)NSString * collection;
@property (nonatomic,copy)NSString * content;
@property (nonatomic,copy)NSString * comment_num;
//Hotel
@property (nonatomic,copy)NSString * star;
@property (nonatomic,copy)NSString * price_num;
@property (nonatomic,copy)NSString * type;
@property (nonatomic,copy)NSString * grade;
//Event
@property (nonatomic,copy)NSString * discount;

@end
