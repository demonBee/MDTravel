//
//  MDPhotoTypeTableViewCell.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/17.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDPhotoTypeTableViewCell : UITableViewCell

@property (nonatomic,copy)void (^chooseTypeBlock)(NSInteger,NSInteger);



@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (nonatomic,strong)NSArray * conArr;

@property (nonatomic,assign)NSInteger typeIndex;

@property (nonatomic,assign)NSInteger selectIndex;
@property (nonatomic,assign)NSInteger selectTypeIndex;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ccellHeigh;


@end
