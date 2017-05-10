//
//  JXLcoationViewController.h
//  即刻出行
//
//  Created by scjy on 16/5/14.
//  Copyright © 2016年 WeiBang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaModel.h"

#define TOP_OFFSET ([[UIApplication sharedApplication] statusBarFrame].size.height + 44.0)

@interface JXLcoationViewController : UIViewController

@property (nonatomic, copy) void(^selectedCityBlock)(AreaModel *);

@property (nonatomic, assign) BOOL isLocationCity;

@end
