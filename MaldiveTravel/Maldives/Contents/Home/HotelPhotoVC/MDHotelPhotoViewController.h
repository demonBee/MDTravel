//
//  MDHotelPhotoViewController.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/17.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDBasicViewController.h"

@interface MDHotelPhotoViewController : MDBasicViewController

@property (nonatomic,copy)NSString * idd;//接口参数
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,assign)BOOL isEvent;

@end
