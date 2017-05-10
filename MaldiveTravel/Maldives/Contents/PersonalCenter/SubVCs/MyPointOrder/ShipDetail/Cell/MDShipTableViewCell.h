//
//  MDShipTableViewCell.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/15.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDShipModel.h"

@interface MDShipTableViewCell : UITableViewCell
@property (nonatomic,strong)MDShipModel * model;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *shipLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIDLabel;

@end
