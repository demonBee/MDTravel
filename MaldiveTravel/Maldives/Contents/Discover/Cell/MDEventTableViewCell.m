//
//  MDEventTableViewCell.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/10.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDEventTableViewCell.h"

@implementation MDEventTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(MDEventModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
}

- (void)dataSet{
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:self.model.pic] placeholderImage:[UIImage imageNamed:@"activity-list-pic-hotel"] completed:nil];
    self.nameLabel.text = [NSString stringWithFormat:@"%@折起  %@",self.model.discount,self.model.title];
}

@end
