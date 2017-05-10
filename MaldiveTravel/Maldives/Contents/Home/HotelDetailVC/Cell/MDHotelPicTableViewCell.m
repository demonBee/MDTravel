//
//  MDHotelPicTableViewCell.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/16.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDHotelPicTableViewCell.h"
#import "XWScanImage.h"

@implementation MDHotelPicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
    [self.showImageView addGestureRecognizer:tapGestureRecognizer];
    [self.showImageView setUserInteractionEnabled:YES];
}

#pragma mark - XWScanImage
-(void)scanBigImageClick:(UITapGestureRecognizer *)tap{
    UIImageView *clickedImageView = (UIImageView *)tap.view;
    [XWScanImage scanBigImageWithImageView:clickedImageView];
}

@end
