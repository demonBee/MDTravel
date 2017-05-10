//
//  MDCommentTableViewCell.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/16.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDCommentModel.h"
#import "MDTouchShowImageView.h"
#import "XWScanImage.h"


@interface MDCommentTableViewCell : UITableViewCell
@property (nonatomic,strong)MDCommentModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *conLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;//无图时为0

@property (nonatomic,assign)BOOL isDetail;

//评分tag1-5  图片tag6-9

@end
