//
//  MDPointShopCollectionViewCell.h
//  Maldives
//
//  Created by Tian Wei You on 16/8/12.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDPointShopModel.h"

@interface MDPointShopCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)MDPointShopModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;



@end
