//
//  MDPhotoScrollView.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/18.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDPhotoScrollView : UIView<UIScrollViewDelegate>

@property (nonatomic,strong)UILabel * countLabel;
@property (nonatomic,strong)NSArray * picArr;

- (instancetype)initWithFrame:(CGRect)frame withPicArr:(NSArray *)picArr withSelectIndex:(NSInteger)selectIndex;

@end
