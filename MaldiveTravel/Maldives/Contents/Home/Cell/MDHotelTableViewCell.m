//
//  MDHotelTableViewCell.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDHotelTableViewCell.h"

@implementation MDHotelTableViewCell

- (void)awakeFromNib {
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
    self.priceLabel.text = [NSString stringWithFormat:@"%@%@",CURRENCY_DEFAULT,self.model.price];
    self.nameLabel.text = self.model.title;
    self.tagLabel.text = self.model.type;
    if ([self.model.star integerValue] <= 4) {
        for (NSInteger i = [self.model.star integerValue] + 1; i<= 5; i++) {
            UIImageView * imageView = [self viewWithTag:i];
            imageView.image = [UIImage imageNamed:@"home-hotel-star-disable"];
        }
    }
    for (NSInteger i = 1; i <= [self.model.star integerValue]; i++) {
        UIImageView * imageView = [self viewWithTag:i];
        imageView.image = [UIImage imageNamed:@"home-hotel-star-0"];
    }
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:self.model.pic] placeholderImage:[UIImage imageNamed:@"home-picture-hotel"] completed:nil];
}

@end
