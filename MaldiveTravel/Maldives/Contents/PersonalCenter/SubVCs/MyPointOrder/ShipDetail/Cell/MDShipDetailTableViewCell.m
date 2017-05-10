//
//  MDShipDetailTableViewCell.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/15.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDShipDetailTableViewCell.h"

@implementation MDShipDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.roundView.layer.cornerRadius = 6.f;
    self.roundView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MDShipDetailModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
}

- (void)dataSet{
    self.nameLabel.text = self.model.status;
    self.timeLabel.text = self.model.create_time;
}

- (void)setStatus:(NSInteger)status{
    //0最新1刚刚开始2只有一个
    if (status == 0 || status == 2) {
        self.roundView.hidden = YES;
        self.roundImageView.hidden = NO;
        self.topLineView.hidden = YES;
        self.nameLabel.textColor = [UIColor blackColor];
    }else if (status == 1 || status == 2){
        self.bottomLineView.hidden = YES;
        self.downLineView.hidden = YES;
    }
}


@end
