//
//  MDStreetAddressViewController.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/15.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDBasicViewController.h"

@interface MDStreetAddressViewController : MDBasicViewController

@property (nonatomic,copy)void (^streetChooseBlock)(NSString *);

@end
