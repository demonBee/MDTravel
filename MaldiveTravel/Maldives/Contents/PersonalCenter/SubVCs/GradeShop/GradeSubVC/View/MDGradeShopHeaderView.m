//
//  MDGradeShopHeaderView.m
//  Maldives
//
//  Created by TianWei You on 17/1/9.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDGradeShopHeaderView.h"

@implementation MDGradeShopHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)changeListBtnAction:(id)sender {
    self.changeListBlock();
}
- (IBAction)gradeListBtnAction:(id)sender {
    self.gradeListBlock();
}


@end
