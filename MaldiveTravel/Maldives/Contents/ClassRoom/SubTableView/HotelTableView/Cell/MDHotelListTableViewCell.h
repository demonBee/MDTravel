//
//  MDHotelListTableViewCell.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/11.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDHotelModel.h"
#import "MDEventModel.h"

@interface MDHotelListTableViewCell : UITableViewCell
@property (nonatomic,strong)MDHotelModel * model;
@property (nonatomic,strong)MDEventModel * eventModel;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;


@end
