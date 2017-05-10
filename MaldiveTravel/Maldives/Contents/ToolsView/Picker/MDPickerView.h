//
//  MDPickerView.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/16.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDPickerView : UIView

@property (nonatomic,copy)void (^saveBlock)(NSString *);

- (void)makePickerView;
- (void)saveAvtion;
- (void)clearSeparatorWithView:(UIView * )view;

@end
