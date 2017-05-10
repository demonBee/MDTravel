//
//  MDClassTableViewCell.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/9.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDClassModel.h"
@interface MDClassTableViewCell : UITableViewCell

@property (nonatomic,strong)MDClassModel * model;

@property (weak, nonatomic) IBOutlet UILabel *qShowLabel;
@property (weak, nonatomic) IBOutlet UILabel *aShowLabel;

@property (weak, nonatomic) IBOutlet UILabel *questLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *questLabelHeigh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *answerLabelHeigh;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end
