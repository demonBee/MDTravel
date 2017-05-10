//
//  MDEventHeader.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/16.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDEventHeader.h"

@implementation MDEventHeader

- (void)setModel:(MDHotelDetailModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
    [self layoutSet];
}

- (void)dataSet{
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:self.model.pic] placeholderImage:[UIImage imageNamed:@"home-picture-hotel"] completed:nil];
    self.nameLabel.text = self.model.title;
    self.cutLabel.text = [NSString stringWithFormat:@"%@折",self.model.discount];
    CGFloat scale = [self.model.discount floatValue]/10;
    CGFloat price = [self.model.price floatValue] * scale;
    self.priceLabel.attributedText = [NSString stringWithFirstStr:[NSString stringWithFormat:@"%@%.2f  ",CURRENCY_DEFAULT,price] withFont:[UIFont systemFontOfSize:16.f] withColor:[UIColor colorWithHexString:@"#666666"] withIsLine:NO withSecondtStr:[NSString stringWithFormat:@"%@%@  ",CURRENCY_DEFAULT,self.model.price] withFont:[UIFont systemFontOfSize:12.f] withColor:[UIColor lightGrayColor] withIsLine:YES];
}

- (void)layoutSet{
    CGFloat scale = [self.model.discount floatValue]/10;
    CGFloat price = [self.model.price floatValue] * scale;
    self.priceLabelWidth.constant = [[NSString stringWithFormat:@"%@%.2f  ",CURRENCY_DEFAULT,price] boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.f) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dicOfTextAttributeWithFont:[UIFont systemFontOfSize:16.f] withTextColor:[UIColor colorWithHexString:@"#666666"]] context:nil].size.width +  [[NSString stringWithFormat:@"%@%@  ",CURRENCY_DEFAULT,self.model.price] boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.f) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dicOfTextAttributeWithFont:[UIFont systemFontOfSize:12.f] withTextColor:[UIColor lightGrayColor]] context:nil].size.width;
    
    [self setNeedsLayout];
}


@end
