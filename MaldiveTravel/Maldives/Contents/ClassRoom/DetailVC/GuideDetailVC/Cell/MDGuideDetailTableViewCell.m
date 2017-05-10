//
//  MDGuideDetailTableViewCell.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/10.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDGuideDetailTableViewCell.h"

@implementation MDGuideDetailTableViewCell

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
    [self layoutSet];
}
- (void)dataSet{
    self.timeLabel.text = self.model.time;
    self.nameLabel.text = self.model.title;
    self.detailLabel.text = self.model.con;
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:self.model.pic] placeholderImage:[UIImage imageNamed:@"photo-detail"] completed:nil];
}
- (void)layoutSet{
    self.showImageViewHeight.constant = ACTUAL_WIDTH(self.showImageViewHeight.constant);
    self.detailLabelHeight.constant = [self labelHeightWithLabel:self.detailLabel];
    
    [self setNeedsLayout];
}

- (CGFloat)labelHeightWithLabel:(UILabel *)label{
    NSDictionary * attributes = @{NSFontAttributeName:label.font};
    CGRect conRect = [label.text boundingRectWithSize:CGSizeMake(KScreenWidth - 69.f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return conRect.size.height + 5.f;
}

@end
