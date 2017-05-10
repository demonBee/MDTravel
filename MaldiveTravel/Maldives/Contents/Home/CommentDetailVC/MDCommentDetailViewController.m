//
//  MDCommentDetailViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/22.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDCommentDetailViewController.h"
#import "MDCommentTableViewCell.h"

#define COMMENTCELL @"MDCommentTableViewCell"
@interface MDCommentDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MDCommentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论详情";
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:COMMENTCELL bundle:nil] forCellReuseIdentifier:COMMENTCELL];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.tableView fd_heightForCellWithIdentifier:COMMENTCELL cacheByIndexPath:indexPath configuration:^(MDCommentTableViewCell * cell) {
        cell.isDetail = YES;
        cell.model = self.model;
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MDCommentTableViewCell * commentCell = [tableView dequeueReusableCellWithIdentifier:COMMENTCELL];
    commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    commentCell.isDetail = YES;
    commentCell.model = self.model;
    return commentCell;
}

@end
