//
//  MDMessageTableViewCell.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/22.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDMessageTableViewCell : UITableViewCell

@property (nonatomic,copy)NSString * isFlook;
@property (nonatomic,strong)UILabel * isFlookLabel;
@property (nonatomic,strong)UIView * lineView;
@property (nonatomic,strong)UILabel * timeLabel;

@end
