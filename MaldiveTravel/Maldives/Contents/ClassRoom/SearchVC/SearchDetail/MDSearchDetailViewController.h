//
//  MDSearchDetailViewController.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/10.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDBasicViewController.h"
#import "MDGuideDetailViewController.h"
#import "MDClassDetailViewController.h"

@interface MDSearchDetailViewController : MDBasicViewController

@property (nonatomic,copy)NSString * keyStr;//搜索关键字
@property (nonatomic,assign)NSInteger status;

@end
