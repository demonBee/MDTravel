//
//  MDGradeShopModel.m
//  Maldives
//
//  Created by TianWei You on 17/1/9.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDGradeShopModel.h"

@implementation MDGradeShopModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"gradeShopID":@"id",@"title":@"name"};
}

@end
