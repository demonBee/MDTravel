//
//  MDHotelChooseTypeTableVC.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDHotelChooseTypeTableVC.h"

@interface MDHotelChooseTypeTableVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign)NSInteger selectIndex;
@property (nonatomic,strong)NSArray * dataArr;

@end

@implementation MDHotelChooseTypeTableVC

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.dataArr = @[@"综合排序",@"星级从高到低",@"价格从高到低",@"价格从低到高",@"评价从高到低",@"浮潜从高到低"];
        self.frame = CGRectMake(0.f, NavigationHeight, KScreenWidth, 44.f * self.dataArr.count);
        self.dataSource = self;
        self.delegate = self;
        
    }
    return self;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectIndex = indexPath.row;
    self.choosedTypeBlock([NSString stringWithFormat:@"%zi",self.selectIndex],self.dataArr[indexPath.row]);
    [self removeFromSuperview];
    [self reloadData];
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * typeCell = [tableView dequeueReusableCellWithIdentifier:@"typeCell"];
    if (!typeCell) {
        typeCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"typeCel"];
    }
    typeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == self.selectIndex) {
        typeCell.accessoryType = UITableViewCellAccessoryCheckmark;
        typeCell.textLabel.textColor = [UIColor colorWithHexString:@"519bf4"];
    }else{
        typeCell.accessoryType = UITableViewCellAccessoryNone;
        typeCell.textLabel.textColor = [UIColor colorWithHexString:@"6c6c6c"];
    }
    typeCell.textLabel.text = self.dataArr[indexPath.row];
    typeCell.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 43.f, KScreenWidth, 1.f)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#d6d6d6"];
    [typeCell addSubview:lineView];
    typeCell.alpha = 1.f;
    return typeCell;
}

@end
