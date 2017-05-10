//
//  MDCouponDetailTableViewCell.h
//  Maldives
//
//  Created by TianWei You on 17/1/13.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDCouponDetailModel.h"

@interface MDCouponDetailTableViewCell : UITableViewCell

@property (nonatomic,strong)MDCouponDetailModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introLabelheight;


@end
