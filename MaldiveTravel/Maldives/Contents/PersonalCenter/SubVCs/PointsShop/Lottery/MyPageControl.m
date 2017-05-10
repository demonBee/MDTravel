//
//  MyPageControl.m
//  Electric
//
//  Created by 李鹏博 on 15/7/11.
//  Copyright (c) 2015年 刘樊. All rights reserved.
//

#import "MyPageControl.h"
@implementation MyPageControl  // 实现部分

//- (id)initWithFrame:(CGRect)frame { // 初始化
//    self = [super initWithFrame:frame];
//    return self;
//}
- (void)setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    [self setNeedsDisplay];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    [super setNumberOfPages:numberOfPages];
    
    [self setNeedsDisplay];
    
}

- (void)drawRect:(CGRect)iRect
{
    int i;
    CGRect rect;
    UIImage *image;
    
    iRect = self.bounds;
    
    if (self.opaque) {
        [self.backgroundColor set];
        UIRectFill(iRect);
    }
    
    UIImage *_activeImage = [UIImage imageNamed:@"椭圆-2-拷贝-5"];
    UIImage *_inactiveImage = [UIImage imageNamed:@"椭圆-2-拷贝-2"];
    CGFloat _kSpacing = 0.0f;
    
    if (self.hidesForSinglePage && self.numberOfPages == 1) {
        return;
    }
    
    rect.size.height = _activeImage.size.height/2;
    rect.size.width = self.numberOfPages * _activeImage.size.width + (self.numberOfPages - 1) * _kSpacing;
    rect.origin.x = floorf((iRect.size.width - rect.size.width) / 2.0);
    rect.origin.y = floorf((iRect.size.height - rect.size.height) / 2.0);
    rect.size.width = _activeImage.size.width/2;
    
    for (i = 0; i < self.numberOfPages; ++i) {
        image = (i == self.currentPage) ? _activeImage : _inactiveImage;
        [image drawInRect:rect];
        rect.origin.x += _activeImage.size.width;
    }
}
@end
