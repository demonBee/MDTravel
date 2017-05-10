//
//  MDGuideTableViewCell.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/9.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDGuideModel.h"

@interface MDGuideTableViewCell : UITableViewCell

@property (nonatomic,strong)MDGuideModel * model;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *publicInfoLabel;

@end
