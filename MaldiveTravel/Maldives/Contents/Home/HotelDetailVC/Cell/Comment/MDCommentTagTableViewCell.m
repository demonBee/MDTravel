//
//  MDCommentTagTableViewCell.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/17.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDCommentTagTableViewCell.h"

@implementation MDCommentTagTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTagArr:(NSMutableArray *)tagArr{
    if (!tagArr)return;
    _tagArr = tagArr;
    [self makeTagLabel];
    [self layoutSet];
}

- (void)makeTagLabel{
    CGFloat labelX = 10.f;
    CGFloat labelY = 10.f;
    
    NSDictionary * attributes = [NSDictionary dicOfTextAttributeWithFont:[UIFont systemFontOfSize:15.f] withTextColor:[UIColor colorWithHexString:@"#4f4f4f"]];
    for (NSString * tagStr in self.tagArr) {
        CGRect tagRect = [tagStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.f) options:NSStringDrawingUsesFontLeading attributes:attributes context:nil];
        if (labelX + tagRect.size.width + 20.f + 10.f >KScreenWidth) {
            labelX = 10.f;
            labelY += 35.f;
        }
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(labelX, labelY, tagRect.size.width + 20.f, 30.f)];
        label.font = [UIFont systemFontOfSize:15.f];
        label.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
        label.text = tagStr;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        label.layer.cornerRadius = 3.f;
        label.layer.masksToBounds = YES;
        labelX += tagRect.size.width + 20.f + 10.f;
    }
    
    self.allHeight = labelY + 30.f + 10.f;
}

- (void)layoutSet{
    self.viewHeight.constant = self.allHeight;
    [self setNeedsLayout];
}


@end
