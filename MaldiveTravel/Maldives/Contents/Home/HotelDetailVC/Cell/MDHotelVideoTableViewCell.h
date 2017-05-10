//
//  MDHotelVideoTableViewCell.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/16.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MDHotelVideoTableViewCell : UITableViewCell

@property (nonatomic,copy)void (^readyToPlayBlock)(NSString *);
@property (nonatomic,strong)NSString * videoUrlStr;

@end
