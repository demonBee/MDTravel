//
//  MDHotelDetailTableViewCell.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/16.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDHotelDetailModel.h"
#import "UIButton+WebCache.h"

@interface MDHotelDetailTableViewCell : UITableViewCell
@property (nonatomic,strong)MDHotelDetailModel * model;

@property (nonatomic,copy)void (^photoBlock)(NSInteger);

@property (weak, nonatomic) IBOutlet UIButton *hotelTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *restaurantTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherTypeBtn;
@property (weak, nonatomic) IBOutlet UILabel *hotelTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introduceLabelheight;


@end
