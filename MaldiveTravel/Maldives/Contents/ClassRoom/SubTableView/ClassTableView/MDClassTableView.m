//
//  MDClassTableView.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/9.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDClassTableView.h"
#import "MDClassTableViewCell.h"

#define CLASSCELL @"MDClassTableViewCell"
@interface MDClassTableView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation MDClassTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        self.showsVerticalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.rowHeight = UITableViewAutomaticDimension;
        [self registerNib:[UINib nibWithNibName:CLASSCELL bundle:nil] forCellReuseIdentifier:CLASSCELL];
    }
    return self;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 500.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataArr.count;
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MDClassTableViewCell * clasCell = [tableView dequeueReusableCellWithIdentifier:CLASSCELL];
    clasCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return clasCell;
}


@end
