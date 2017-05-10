//
//  MDGradeShopHeaderView.h
//  Maldives
//
//  Created by TianWei You on 17/1/9.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDGradeShopHeaderView : UIView

@property (nonatomic,copy)void (^changeListBlock)();
@property (nonatomic,copy)void (^gradeListBlock)();

@end
