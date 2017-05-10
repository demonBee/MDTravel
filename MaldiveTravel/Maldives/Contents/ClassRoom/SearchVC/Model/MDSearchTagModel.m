//
//  MDSearchTagModel.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDSearchTagModel.h"

@implementation MDSearchTagModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"searchID" : @"id",@"searchClass" : @"class"};
}

@end
