//
//  MDCommentTagTableViewCell.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/17.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDCommentTagTableViewCell : UITableViewCell

@property (nonatomic,strong)NSArray * tagArr;
@property (nonatomic,assign)CGFloat allHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;

@end
