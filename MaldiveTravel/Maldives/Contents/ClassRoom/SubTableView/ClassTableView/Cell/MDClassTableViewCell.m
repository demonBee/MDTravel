//
//  MDClassTableViewCell.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/9.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDClassTableViewCell.h"

@implementation MDClassTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.qShowLabel.layer.cornerRadius = 10.f;
    self.qShowLabel.layer.masksToBounds = YES;
    self.aShowLabel.layer.cornerRadius = 10.f;
    self.aShowLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MDClassModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
    [self layoutSet];
}

- (void)dataSet{
    self.questLabel.text = self.model.problem;
    self.answerLabel.text = self.model.reply;
}

- (void)layoutSet{
    self.questLabelHeigh.constant = [JWTools labelHeightWithLabel:self.questLabel];
    CGFloat answerHeigh = [JWTools labelHeightWithLabel:self.answerLabel];
    if (self.bottomView.hidden) {
        self.answerLabelHeigh.constant = answerHeigh;
    }else{
        self.answerLabelHeigh.constant = answerHeigh < 76.f?answerHeigh : 76.f;
    }
    [self setNeedsLayout];
}



@end
