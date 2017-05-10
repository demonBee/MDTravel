//
//  MDHotelDetailTableViewCell.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/16.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDHotelDetailTableViewCell.h"

@implementation MDHotelDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MDHotelDetailModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
    [self layoutSet];
}

- (void)dataSet{
    [self.hotelTypeBtn sd_setImageWithURL:[NSURL URLWithString:self.model.one_pic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"pic-hotel-photos-list"] completed:nil];
    [self.restaurantTypeBtn sd_setImageWithURL:[NSURL URLWithString:self.model.tow_pic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"pic-hotel-photos-list"] completed:nil];
    [self.otherTypeBtn sd_setImageWithURL:[NSURL URLWithString:self.model.three_pic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"pic-hotel-photos-list"] completed:nil];
    self.hotelTypeLabel.text = [NSString stringWithFormat:@"房型(%@)",self.model.one_num];
    self.restaurantTypeLabel.text = [NSString stringWithFormat:@"餐厅(%@)",self.model.tow_num];
    self.otherTypeLabel.text = [NSString stringWithFormat:@"其他设施(%@)",self.model.three_num];
    self.introduceLabel.text = self.model.content;
}

- (void)layoutSet{
    self.introduceLabelheight.constant = [JWTools labelHeightWithLabel:self.introduceLabel];
    [self setNeedsLayout];
}

- (IBAction)photoBtnAction:(UIButton *)sender {
    self.photoBlock(sender.tag - 1);
}



@end
