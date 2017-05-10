//
//  MDGuideTableView.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/9.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDGuideTableView.h"
#import "MDGuideTableViewCell.h"

#define GUIDECELL @"MDGuideTableViewCell"
@interface MDGuideTableView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray * dataArr;


@end

@implementation MDGuideTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate =self;
        self.dataSource = self;
        self.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
        [self registerNib:[UINib nibWithNibName:GUIDECELL bundle:nil] forCellReuseIdentifier:GUIDECELL];
    }
    return self;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 141.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return self.dataArr.count;
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MDGuideTableViewCell * guidCell = [tableView dequeueReusableCellWithIdentifier:GUIDECELL];
    guidCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return guidCell;
}




@end
