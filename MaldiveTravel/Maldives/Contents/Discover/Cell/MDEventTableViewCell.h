//
//  MDEventTableViewCell.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/10.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDEventModel.h"

@interface MDEventTableViewCell : UITableViewCell
@property (nonatomic,strong)MDEventModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end
