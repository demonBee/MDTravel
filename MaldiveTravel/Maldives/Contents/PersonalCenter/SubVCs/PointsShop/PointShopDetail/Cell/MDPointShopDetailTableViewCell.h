//
//  MDPointShopDetailTableViewCell.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/15.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDPointShopDetailModel.h"
#import "PayNumberView.h"
@interface MDPointShopDetailTableViewCell : UITableViewCell<PayNumberViewDelegate>
@property (nonatomic,copy)void (^payNumberGetBlock)(NSString *);
@property (nonatomic,strong)MDPointShopDetailModel * model;

@property (weak, nonatomic) IBOutlet UILabel *namelLabel;
@property (weak, nonatomic) IBOutlet PayNumberView *payNumberView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introLabelHeight;

@end
