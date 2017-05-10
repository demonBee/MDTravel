//
//  MDPersonCenterHeaderView.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/10.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDPersonCenterHeaderView.h"

@implementation MDPersonCenterHeaderView
- (void)awakeFromNib{
    self.loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.loginBtn.layer.borderWidth = 1.f;
    self.loginBtn.layer.cornerRadius = 5.f;
    self.loginBtn.layer.masksToBounds = YES;
    
    
    self.sexLabel.layer.cornerRadius = 10.f;
    self.sexLabel.layer.masksToBounds = YES;
    self.sexLabel.transform = CGAffineTransformRotate(self.sexLabel.transform, M_PI_4);
    
    self.iconImageView.layer.cornerRadius = 40.f;
    self.iconImageView.layer.masksToBounds = YES;
    
    [self isLogin];
}

- (void)isLogin{
    if ([UserSession instance].isLogin) {
        self.loginBtn.hidden = YES;
        self.nameLabel.hidden = NO;
        
        self.nameLabel.text = [UserSession instance].name?[UserSession instance].name:[NSString stringWithFormat:@"Hi~%@",[UserSession instance].name];
        
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[UserSession instance].logo?[UserSession instance].logo:@"btn-Upload-Avatar"] placeholderImage:[UIImage imageNamed:@"btn-Upload-Avatar"] completed:nil];
        
        if ([UserSession instance].sex) {
            //显示性别
            self.sexLabel.hidden = NO;
            NSDictionary * attributes = [NSDictionary dicOfTextAttributeWithFont:[UIFont systemFontOfSize:15.f] withTextColor:[UIColor whiteColor]];
            CGRect nameRect = [self.nameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.f) options:NSStringDrawingUsesFontLeading attributes:attributes context:nil];
            self.sexLabelRight.constant = (KScreenWidth + nameRect.size.width)/2 + 10.f;
            self.sexLabel.text = [[UserSession instance].sex isEqualToString:@"0"]?@"♂":@"♀";
            if ([[UserSession instance].sex isEqualToString:@"0"]) {
                self.sexLabel.backgroundColor = [UIColor cyanColor];
                [self setNeedsLayout];
            }else{
                self.sexLabel.backgroundColor = [UIColor redColor];
            }
        }else{
            self.sexLabel.hidden = YES;
        }
    }else{
        self.sexLabel.hidden = YES;
        self.loginBtn.hidden = NO;
        self.nameLabel.hidden = YES;
        self.iconImageView.image = [UIImage imageNamed:@"Head-portrait"];
    }
}


- (IBAction)loginBtnAction:(id)sender {
    self.loginBlock();
}


@end
