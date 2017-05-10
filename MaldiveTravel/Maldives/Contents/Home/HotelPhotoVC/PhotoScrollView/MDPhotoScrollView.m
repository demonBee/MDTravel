//
//  MDPhotoScrollView.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/18.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDPhotoScrollView.h"
#import "XWScanImage.h"
#import "MDPhotoImageView.h"

@implementation MDPhotoScrollView

- (instancetype)initWithFrame:(CGRect)frame withPicArr:(NSArray *)picArr withSelectIndex:(NSInteger)selectIndex{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        self.countLabel = [[UILabel alloc]initWithFrame:CGRectMake((KScreenWidth - 150.f)/2, 20.f, 150.f, 44.f)];
        self.countLabel.textColor = [UIColor whiteColor];
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        self.countLabel.text = [NSString stringWithFormat:@"%zi/%zi",selectIndex + 1,picArr.count];
        [self addSubview:self.countLabel];
        
        UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10.f, self.countLabel.center.y - 15.f, 30.f, 30.f)];
        [backBtn setImage:[UIImage imageNamed:@"icon-back-white"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        
        self.picArr = picArr;
        [self makeScrollViewWithSelectIndex:selectIndex];
    }
    return self;
}

- (void)tapAction{
    [self removeFromSuperview];
}

- (void)makeScrollViewWithSelectIndex:(NSInteger)selectIndex{
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavigationHeight, KScreenWidth, KScreenHeight - NavigationHeight)];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(KScreenWidth * self.picArr.count, 100.f);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.scrollsToTop = YES;
    for (int i = 0; i < self.picArr.count; i++) {
        CGSize size = [JWTools getScaleImageSizeWithImageView:self.picArr[i] withHeight:KScreenHeight withWidth:KScreenWidth];
        MDPhotoImageView * imageView = [[MDPhotoImageView alloc]initWithFrame:CGRectMake(i * KScreenWidth, KScreenHeight/2-size.height, KScreenWidth, size.height)];
        imageView.rectOld = imageView.frame;
        imageView.center = CGPointMake(imageView.center.x, KScreenHeight/2 - ACTUAL_WIDTH(105));
        imageView.image = self.picArr[i];
        [scrollView addSubview:imageView];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick:)];
        [imageView addGestureRecognizer:tapGestureRecognizer];
        [imageView setUserInteractionEnabled:YES];
//        imageView.tag = 
        UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinshAction:)];
        [imageView addGestureRecognizer:pinch];
    }
    
    [scrollView setContentOffset:CGPointMake(selectIndex * KScreenWidth, 0.f) animated:NO];
    [self addSubview:scrollView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x/ KScreenWidth;
    NSLog(@"%zi",page);
    self.countLabel.text = [NSString stringWithFormat:@"%zi/%zi", page + 1,self.picArr.count];
}

#pragma mark - XWScanImage
- (void)scanBigImageClick:(UITapGestureRecognizer *)tap{
    MDPhotoImageView *clickedImageView = (MDPhotoImageView *)tap.view;
    if (clickedImageView.scale != 0.f) {
        clickedImageView.frame = clickedImageView.rectOld;
        clickedImageView.center = CGPointMake(clickedImageView.center.x, KScreenHeight/2 - ACTUAL_WIDTH(105));
        clickedImageView.scale= 0.f;
        return;
    }
    [XWScanImage scanBigImageWithImageView:clickedImageView];
}

- (void)pinshAction:(UIPinchGestureRecognizer *)pinch{
    //原始imageview
    MDPhotoImageView *imageView = (MDPhotoImageView *)pinch.view;
    pinch.scale=pinch.scale-imageView.scale+1;
    
    imageView.transform = CGAffineTransformScale(imageView.transform, pinch.scale,pinch.scale);
    
    imageView.scale=pinch.scale;
}

@end
