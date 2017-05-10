//
//  MDPhotoTypeTableViewCell.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/17.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDPhotoTypeTableViewCell.h"

@implementation MDPhotoTypeTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setConArr:(NSArray *)conArr{
    if (!conArr)return;
    _conArr = conArr;
    [self makeTypeBtn];
}

- (void)makeTypeBtn{
    __block CGFloat btnX = 10.f;
    __block CGFloat btnY = 40.f;
    NSMutableArray * tagArr = [self.conArr mutableCopy];
    self.typeLabel.text = tagArr[0];
    [tagArr replaceObjectAtIndex:0 withObject:@"全部"];
    [tagArr removeLastObject];
    NSDictionary * attributes = [NSDictionary dicOfTextAttributeWithFont:[UIFont systemFontOfSize:15.f] withTextColor:[UIColor blackColor]];
    [tagArr enumerateObjectsUsingBlock:^(NSString *  _Nonnull tagStr, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect tagRect = [tagStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.f) options:NSStringDrawingUsesFontLeading attributes:attributes context:nil];
        if (btnX + tagRect.size.width + 30.f + 15.f >KScreenWidth) {
            btnX = 10.f;
            btnY += 50.f;
        }
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY, tagRect.size.width + 30.f, 40.f)];
        btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        btn.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
        if (self.typeIndex == self.selectTypeIndex && self.selectIndex == idx) {
            btn.backgroundColor = [UIColor colorWithHexString:@"#cbe0f8"];
        }
        [btn setTitle:tagStr forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(photoChooseAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = idx + 10;
        [self addSubview:btn];
        btn.layer.cornerRadius = 4.f;
        btn.layer.masksToBounds = YES;
        btnX += tagRect.size.width + 30.f + 15.f;
    }];
    
    btnY += 10.f + 40.f;
    self.ccellHeigh.constant = btnY;
    [self setNeedsLayout];
}

- (void)photoChooseAction:(UIButton *)sender{
    self.chooseTypeBlock(sender.tag - 10,self.typeIndex);
}

@end
