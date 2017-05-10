//
//  MDHotelListTableViewCell.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/11.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDHotelListTableViewCell.h"

@implementation MDHotelListTableViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MDHotelModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
}

- (void)dataSet{
    self.nameLabel.text = self.model.title;
    self.introLabel.text = self.model.content;
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:self.model.pic] placeholderImage:[UIImage imageNamed:@"home-picture-hotel"] completed:nil];
}

- (void)setEventModel:(MDEventModel *)eventModel{
    if (!eventModel)return;
    _eventModel = eventModel;
    [self eventDataSet];
}

- (void)eventDataSet{
    self.nameLabel.text = self.eventModel.title;
    self.introLabel.text = self.eventModel.content;
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:self.eventModel.pic] placeholderImage:[UIImage imageNamed:@"home-picture-hotel"] completed:nil];
}

@end
