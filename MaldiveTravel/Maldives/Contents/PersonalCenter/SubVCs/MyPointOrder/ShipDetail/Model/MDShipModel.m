//
//  MDShipModel.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/15.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDShipModel.h"

@implementation MDShipModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"logs" : [MDShipDetailModel class]};
}

@end
