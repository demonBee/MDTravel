//
//  MDShipModel.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/15.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDShipDetailModel.h"
#import "MDShipStatusModel.h"

@interface MDShipModel : NSObject

@property (nonatomic,strong)MDShipStatusModel * status;
@property (nonatomic,strong)NSArray * logs;

@end
