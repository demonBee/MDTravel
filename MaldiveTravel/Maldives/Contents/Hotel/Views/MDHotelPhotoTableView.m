//
//  MDHotelPhotoTableView.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/17.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDHotelPhotoTableView.h"
#import "MDPhotoTypeTableViewCell.h"

#define PHOTOTYPECELL @"MDPhotoTypeTableViewCell"
@interface MDHotelPhotoTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign)NSInteger selectIndex;
@property (nonatomic,assign)CGFloat tableViewHeight;

@end

@implementation MDHotelPhotoTableView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        self.frame = CGRectMake(0.f, NavigationHeight, KScreenWidth, 10.f);
        self.dataSource = self;
        self.delegate = self;
        self.dataArr = [[NSArray alloc]init];
        [self registerNib:[UINib nibWithNibName:PHOTOTYPECELL bundle:nil] forCellReuseIdentifier:PHOTOTYPECELL];
        
    }
    return self;
}

- (void)setDataArr:(NSArray *)dataArr{
    if (!dataArr)return;
    _dataArr = dataArr;
    [self reloadData];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeigh = [self fd_heightForCellWithIdentifier:PHOTOTYPECELL cacheByIndexPath:indexPath configuration:^(MDPhotoTypeTableViewCell * cell) {
        cell.conArr = self.dataArr[indexPath.row];
    }];
    if (self.height <= 20.f) {
        self.tableViewHeight += cellHeigh;
        if (indexPath.row >= self.dataArr.count - 1)self.frame = CGRectMake(0.f, NavigationHeight, KScreenWidth, self.tableViewHeight);
    }
    
    return cellHeigh;
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MDPhotoTypeTableViewCell * typeCell = [tableView dequeueReusableCellWithIdentifier:PHOTOTYPECELL];
    typeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    typeCell.typeIndex = indexPath.row;
    typeCell.selectIndex = self.selectIndex;
    typeCell.selectTypeIndex = self.selectTypeIndex;
    typeCell.conArr = self.dataArr[indexPath.row];
    typeCell.chooseTypeBlock = ^(NSInteger status,NSInteger type){
        self.selectIndex = status;
        self.selectTypeIndex = type;
        self.choosedTypeBlock(status,type,self.dataArr[type][status]);
        [self removeFromSuperview];
        [self reloadData];
    };
    
    return typeCell;
}



@end
