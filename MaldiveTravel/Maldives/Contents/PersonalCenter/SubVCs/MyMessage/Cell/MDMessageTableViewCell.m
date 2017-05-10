//
//  MDMessageTableViewCell.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/22.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDMessageTableViewCell.h"

@implementation MDMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textLabel.textColor = [UIColor darkGrayColor];
    self.textLabel.numberOfLines = 1;
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
    self.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGFloat roundWidth = 12.f;
    self.isFlookLabel = [[UILabel alloc]initWithFrame:CGRectMake(57.f, 10.f, roundWidth, roundWidth)];
    self.isFlookLabel.backgroundColor = [UIColor redColor];
    self.isFlookLabel.layer.cornerRadius = roundWidth/2;
    self.isFlookLabel.layer.masksToBounds = YES;
    [self addSubview:self.isFlookLabel];
    self.isFlookLabel.hidden = YES;
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 75.f, KScreenWidth, 1.f)];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#d6d6d6"];
    [self addSubview:self.lineView];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth - 130.f, 0.f, 120.f, 44.f)];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.font = [UIFont systemFontOfSize:12.f];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.timeLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsFlook:(NSString *)isFlook{
    if (!isFlook)return;
    _isFlook = isFlook;
    self.isFlookLabel.hidden = [isFlook isEqualToString:@"0"]?NO:YES;
    if ([isFlook isEqualToString:@"0"]) {
        self.textLabel.textColor = [UIColor blackColor];
    }
}


@end
