//
//  MDPointShopCollectionViewCell.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/12.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDPointShopCollectionViewCell.h"

@implementation MDPointShopCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MDPointShopModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
}

- (void)dataSet{
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:self.model.pic] placeholderImage:[UIImage imageNamed:@"pic-photo"] completed:nil];
    self.nameLabel.text = self.model.name;
    self.priceLabel.text = self.model.points;
}

@end
