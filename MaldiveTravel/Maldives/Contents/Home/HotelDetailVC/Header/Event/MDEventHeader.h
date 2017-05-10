//
//  MDEventHeader.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/16.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDHotelDetailModel.h"

@interface MDEventHeader : UITableViewHeaderFooterView
@property (nonatomic,strong)MDHotelDetailModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cutLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLabelWidth;



@end
