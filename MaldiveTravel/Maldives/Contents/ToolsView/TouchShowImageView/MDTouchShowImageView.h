//
//  MDTouchShowImageView.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/18.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDTouchShowImageView : UIImageView

@property (nonatomic,copy)void (^touchBlock)(NSInteger,CGFloat);

@end
