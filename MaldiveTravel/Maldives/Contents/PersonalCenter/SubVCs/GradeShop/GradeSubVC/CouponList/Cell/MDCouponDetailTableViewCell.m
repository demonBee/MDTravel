//
//  MDCouponDetailTableViewCell.m
//  Maldives
//
//  Created by TianWei You on 17/1/13.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDCouponDetailTableViewCell.h"

@implementation MDCouponDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MDCouponDetailModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
}

- (void)dataSet{
    self.nameLabel.text = self.model.name;
    NSMutableAttributedString * introStr = [NSString stringWithFirstStr:[NSString stringWithFormat:@"%@\n",self.model.coupon_name] withFont:self.introLabel.font withColor:[UIColor cyanColor] withSecondtStr:[NSString stringWithFormat:@"使用时间:%@-%@\n",[JWTools dateStrWithDate:@""],[JWTools dateStrWithDate:self.model.ex_time]] withFont:self.introLabel.font withColor:[UIColor lightGrayColor]];
    [introStr appendAttributedString:[NSString stringWithFirstStr:[NSString stringWithFormat:@"优惠券号码:%@\n",self.model.coupon_code] withFont:self.introLabel.font withColor:[UIColor redColor] withSecondtStr:[NSString stringWithFormat:@"%@",self.model.content] withFont:self.introLabel.font withColor:[UIColor yellowColor]]];
    self.introLabel.attributedText = introStr;
    self.introLabelheight.constant = [JWTools labelHeightWithLabel:self.introLabel withWidth:(KScreenWidth-111.5f)];
    [self setNeedsLayout];
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:self.model.pic] placeholderImage:[UIImage imageNamed:@"home-picture-hotel"] completed:nil];
}

@end
