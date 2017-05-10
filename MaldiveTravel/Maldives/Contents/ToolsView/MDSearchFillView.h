//
//  MDSearchFillView.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/9.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDSearchFillView : UIView

@property (nonatomic,copy)void (^searchBlock)();
@property (weak, nonatomic) IBOutlet UIImageView *searchImgView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;


@end
