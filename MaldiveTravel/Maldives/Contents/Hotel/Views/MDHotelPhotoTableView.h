//
//  MDHotelPhotoTableView.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/17.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDHotelPhotoTableView : UITableView

@property (nonatomic,copy)void(^choosedTypeBlock)(NSInteger,NSInteger,NSString *);

@property (nonatomic,strong)NSArray * dataArr;
@property (nonatomic,assign)NSInteger selectTypeIndex;

@end
