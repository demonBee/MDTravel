//
//  MDGuideTableViewCell.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/9.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDGuideTableViewCell.h"

@implementation MDGuideTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MDGuideModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
}

- (void)dataSet{
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:self.model.pic] placeholderImage:[UIImage imageNamed:@"pic-hotel-photos-list"] completed:nil];
    self.nameLabel.text = self.model.title;
    self.introLabel.text = self.model.con;
    self.publicInfoLabel.text = self.model.time;
}

@end
