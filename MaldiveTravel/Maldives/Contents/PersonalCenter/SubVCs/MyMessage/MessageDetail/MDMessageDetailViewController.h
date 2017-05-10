//
//  MDMessageDetailViewController.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/16.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDBasicViewController.h"
#import "MDMessageModel.h"
@interface MDMessageDetailViewController : MDBasicViewController

@property (nonatomic,strong)MDMessageModel * model;
@property (nonatomic,copy)NSString * zt;

@end
