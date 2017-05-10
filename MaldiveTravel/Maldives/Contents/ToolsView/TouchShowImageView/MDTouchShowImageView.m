//
//  MDTouchShowImageView.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/18.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDTouchShowImageView.h"

@implementation MDTouchShowImageView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return [super hitTest:point withEvent:event];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGFloat likeCount = point.x/self.width>=0.8?1.f:point.x/self.width;
    self.image = [UIImage imageNamed:likeCount >=0.5f?@"icon-like":@"half-heart"];
    self.touchBlock(self.tag,likeCount);
}

@end
