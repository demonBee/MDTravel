//
//  MDPersonCenterHeaderView.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/10.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDPersonCenterHeaderView : UIView

@property (nonatomic,copy)void (^loginBlock)();

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sexLabelRight;


- (void)isLogin;

@end
