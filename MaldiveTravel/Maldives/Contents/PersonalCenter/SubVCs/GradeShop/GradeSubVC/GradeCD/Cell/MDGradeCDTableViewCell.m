//
//  MDGradeCDTableViewCell.m
//  Maldives
//
//  Created by TianWei You on 17/1/9.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDGradeCDTableViewCell.h"

@implementation MDGradeCDTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MDCouponModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
}

- (void)dataSet{
    self.nameLabel.text = self.model.name;
    NSInteger cut = [self.model.discount floatValue]*100;
    NSString * cutStr = @"0";
    if (cut%10==0) {
        cutStr = [NSString stringWithFormat:@"%zi",cut/10];
    }else if(cut>10){
        cutStr = [NSString stringWithFormat:@"%zi",cut];
    }else{
        cutStr = [NSString stringWithFormat:@"0.%zi",cut];
    }
    
    NSMutableAttributedString * introStr = [NSString stringWithFirstStr:[NSString stringWithFormat:@"%@\n",(self.model.type==1?[NSString stringWithFormat:@"优惠%@元",self.model.amount]:[NSString stringWithFormat:@"打%@折",cutStr])] withFont:self.introLabel.font withColor:[UIColor cyanColor] withSecondtStr:[NSString stringWithFormat:@"所需积点:%@",self.model.if_grade_point] withFont:self.introLabel.font withColor:self.introLabel.textColor];
    self.introLabel.attributedText = introStr;
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:self.model.img] placeholderImage:[UIImage imageNamed:@"home-picture-hotel"] completed:nil];
}

@end
