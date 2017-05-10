//
//  MDOrderTableViewCell.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/15.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDOrderModel.h"

@interface MDOrderTableViewCell : UITableViewCell

@property (nonatomic,strong)NSArray * colorArr;
@property (nonatomic,strong)NSDictionary * selectColorDic;
@property (nonatomic,strong)MDOrderModel * model;

@property (nonatomic,copy)void (^sureBlock)();
@property (nonatomic,copy)void (^showBlock)(NSString *);

@property (weak, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *showBtn;//多个状态下显示不同0取消1物流详情2重新购买3物流详情

@property (nonatomic,copy)NSString * status;//多个状态下显示不同0取消1物流详情2重新购买3物流详情


@end
