//
//  MDCommentTableViewCell.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/16.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDCommentTableViewCell.h"

@implementation MDCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.showImageView.layer.cornerRadius = 15.f;
    self.showImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(MDCommentModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
    [self layoutSet];
}

- (void)dataSet{
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:self.model.pic] placeholderImage:[UIImage imageNamed:@"Head-portrait"] completed:nil];
    CGFloat count = [self.model.fen floatValue];
    self.nameLabel.text = self.model.name;
    self.countLabel.text = [NSString stringWithFormat:@"%.1f分",count];
    self.conLabel.text  = self.model.con;
    self.timeLabel.text = self.model.time;
    for (int i = 1; i <= 5; i++) {
        MDTouchShowImageView * likeImageView = [self viewWithTag:i];
        if (i<=count) {
            likeImageView.image = [UIImage imageNamed:@"icon-like"];
        }else if (i - count >= 1){
            likeImageView.image = [UIImage imageNamed:@"icon-dislike"];
        }else{
            likeImageView.image = [UIImage imageNamed:@"half-heart"];
        }
        [likeImageView setUserInteractionEnabled:NO];
    }
    for (int i = 6; i < self.model.pics.count + 6; i++) {
        UIImageView * imageView = [self viewWithTag:i];
        if (self.isDetail) {
            UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick1:)];
            [imageView addGestureRecognizer:tapGestureRecognizer1];
            [imageView setUserInteractionEnabled:YES];
        }
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.model.pics[i - 6]] placeholderImage:[UIImage imageNamed:@"pic-hotel-photos-list"] completed:nil];
    }
    
}



- (void)layoutSet{
    if (!self.isDetail && [JWTools labelHeightWithLabel:self.conLabel withWidth:KScreenWidth - 51.f] > 72.f) {
        self.conLabelHeight.constant = 72.f;
    }else{
        self.conLabelHeight.constant = [JWTools labelHeightWithLabel:self.conLabel withWidth:KScreenWidth - 51.f];
    }
    if (self.model.pics.count == 0) {
        self.imageViewHeight.constant = 0.f;
    }else{
        self.imageViewHeight.constant = (KScreenWidth - 93.f)/4;
    }
    
    [self setNeedsLayout];
}


#pragma mark - XWScanImage
-(void)scanBigImageClick1:(UITapGestureRecognizer *)tap{
    //    NSLog(@"点击图片");
    UIImageView *clickedImageView = (UIImageView *)tap.view;
    [XWScanImage scanBigImageWithImageView:clickedImageView];
}


@end
