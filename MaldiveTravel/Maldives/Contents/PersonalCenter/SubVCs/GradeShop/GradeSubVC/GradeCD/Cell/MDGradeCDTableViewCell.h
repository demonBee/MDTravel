//
//  MDGradeCDTableViewCell.h
//  Maldives
//
//  Created by TianWei You on 17/1/9.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDCouponModel.h"

@interface MDGradeCDTableViewCell : UITableViewCell

@property (nonatomic,strong)MDCouponModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;

@end
