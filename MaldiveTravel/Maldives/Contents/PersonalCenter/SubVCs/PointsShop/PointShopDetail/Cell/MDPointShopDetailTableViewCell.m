//
//  MDPointShopDetailTableViewCell.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/15.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDPointShopDetailTableViewCell.h"

@implementation MDPointShopDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.payNumberView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MDPointShopDetailModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
    [self layoutSet];
}

- (void)dataSet{
    self.namelLabel.text = self.model.name;
    self.priceLabel.text = self.model.points;
    self.introLabel.text = self.model.content;
}

- (void)layoutSet{
    self.introLabelHeight.constant = [JWTools labelHeightWithLabel:self.introLabel];
    [self setNeedsLayout];
}

#pragma mark - PayNumberViewDelegate
- (void)deleteBtnAction:(UIButton *)sender addNumberView:(PayNumberView *)view{
    NSInteger number = [view.numberLab.text integerValue] - 1;
    view.numberLab.text = [NSString stringWithFormat:@"%zi",number];
    self.payNumberGetBlock(view.numberLab.text);
}
- (void)addBtnAction:(UIButton *)sender addNumberView:(PayNumberView *)view{
    NSInteger number = [view.numberLab.text integerValue] + 1;
    view.numberLab.text = [NSString stringWithFormat:@"%zi",number];
    self.payNumberGetBlock(view.numberLab.text);
}

@end
