//
//  MDHotelHeader.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/16.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDHotelHeader.h"

@implementation MDHotelHeader

- (void)awakeFromNib{
    [self dataSet];
    [self layoutSet];
}

- (void)setModel:(MDHotelDetailModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
    [self layoutSet];
}

- (void)dataSet{
    NSString * star = [NSString stringWithFormat:@"%@",self.model.star];
    self.countLabel.text = [NSString stringWithFormat:@"%.1f分",[star floatValue]];
    self.tagLabel.text = self.model.grade;
    self.nameLabel.text = self.model.title;
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:self.model.pic] placeholderImage:[UIImage imageNamed:@"home-picture-hotel"] completed:nil];
    self.costLabel.attributedText = [NSString stringWithFirstStr:[NSString stringWithFormat:@"%@%@",CURRENCY_DEFAULT,self.model.price] withFont:[UIFont systemFontOfSize:18.f] withColor:[UIColor whiteColor] withSecondtStr:[NSString stringWithFormat:@"起(%@人)",self.model.price_num] withFont:[UIFont systemFontOfSize:13.f] withColor:[UIColor whiteColor]];
    if (![star isEqualToString:@"(null)"]) {
        if ([star integerValue] <= 4) {
            for (NSInteger i = [star integerValue] + 1; i<= 5; i++) {
                UIImageView * imageView = [self viewWithTag:i];
                imageView.image = [UIImage imageNamed:@"home-hotel-star-disable"];
            }
        }
        for (NSInteger i = 1; i <= [star integerValue]; i++) {
            UIImageView * imageView = [self viewWithTag:i];
            imageView.image = [UIImage imageNamed:@"home-hotel-star-0"];
        }
    }
}

- (void)layoutSet{
    self.costLabelHeight.constant = [[NSString stringWithFormat:@"%@%@",CURRENCY_DEFAULT,self.model.price] boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.f) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dicOfTextAttributeWithFont:[UIFont systemFontOfSize:18.f] withTextColor:[UIColor whiteColor]] context:nil].size.width + [[NSString stringWithFormat:@"起(%@人)",self.model.price_num] boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.f) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dicOfTextAttributeWithFont:[UIFont systemFontOfSize:13.f] withTextColor:[UIColor whiteColor]] context:nil].size.width + 5.f + 10.f;
    
    [self setNeedsLayout];
}


@end
