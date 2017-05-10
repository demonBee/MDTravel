//
//  MDSettingViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/11.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDSettingViewController.h"
#import "MDAboutUsViewController.h"
#import "MDSuggestSendViewController.h"
#import "MDPersonInfoViewController.h"
#import "JWThirdTools.h"

@interface MDSettingViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * contentArr;
@property (nonatomic,strong)NSArray * subVCClassArr;

@end

@implementation MDSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self dataSet];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    });
}
- (void)dataSet{
    self.contentArr = [NSMutableArray arrayWithArray:@[@"关于我们",@"意见反馈",@"清除缓存",@"推荐给朋友",@"个人资料"]];
    self.subVCClassArr =@[[MDAboutUsViewController class],[MDSuggestSendViewController class],@"",@"",[MDPersonInfoViewController class]];
    [self reSetData];
}
- (void)clearData{
    //清除缓存
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
    [JWThirdTools clearCache:paths[0]];
    [self showHUDWithStr:@"清除成功" withSuccess:YES];
    [self reSetData];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)reSetData{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
    [self.contentArr replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"清除缓存(%.fM)",[JWThirdTools folderSizeAtPath:paths[0]]]];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        //分享
        [self makeShareViewWithDic:@{@"image":[UIImage imageNamed:@"home-page"]}];
        return;
    }else if (indexPath.row == 2){
        //清除缓存
        [self clearData];
        return;
    }
    
    Class vcClass = (Class)self.subVCClassArr[indexPath.row];
    UIViewController * vc = [[vcClass alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * personCell = [tableView dequeueReusableCellWithIdentifier:@"personSetCell"];
    if (!personCell) {
        personCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"personSetCell"];
    }
    personCell.textLabel.text = self.contentArr[indexPath.row];
    personCell.selectionStyle = UITableViewCellSelectionStyleNone;
    personCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row >= 1) {
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KScreenWidth, 1.f)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#d6d6d6"];
        [personCell addSubview:lineView];
    }
    return personCell;
}

@end
