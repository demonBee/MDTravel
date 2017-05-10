//
//  MDPersonInfoViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/12.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDPersonInfoViewController.h"
#import "MDPersonInfoSetViewController.h"
#import "MDChangePassWordViewController.h"


#import "MDDatePickerView.h"
#import "MDSexPickerView.h"

@interface MDPersonInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSArray * conArr;
@property (nonatomic,strong)NSArray * userInfoArr;
@property (nonatomic,strong)MDDatePickerView * datePicker;
@property (nonatomic,strong)MDSexPickerView * sexPicker;

@property (nonatomic,strong)UIImageView * imageView;

@end

@implementation MDPersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    [self dataSet];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)dataSet{
    self.conArr = @[@[@"头像"],@[@"用户名",@"邮箱地址",@"姓名",@"性别",@"生日",@"所在城市",@"修改密码"]];
}

- (IBAction)quiteLoginBtnAction:(id)sender {
    [UserSession cleanUser];
    [self showHUDWithStr:@"Success" withSuccess:YES];
    [self requestLoginOut];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}

- (MDSexPickerView *)sexPicker{
    if (!_sexPicker) {
        _sexPicker = [[MDSexPickerView alloc]init];
        WEAKSELF;
        _sexPicker.saveBlock = ^(NSString * sex){
            [weakSelf requestChangeInfoWithType:MaldivesType_InfoChange_Sex withStr:@{@"sex":sex}];
        };
    }
    return _sexPicker;
}
- (MDDatePickerView *)datePicker{
    if (!_datePicker) {
        _datePicker = [[MDDatePickerView alloc]init];
        WEAKSELF;
        _datePicker.saveBlock = ^(NSString * date){
            [weakSelf requestChangeInfoWithType:MaldivesType_InfoChange_BirthDay withStr:@{@"birthday":date}];
        };
    }
    return _datePicker;
}

- (void)makeLocalImagePicker{
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVC.allowPickingVideo = NO;
    [imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto) {
        [self requestChangeInfoLogoWithPhoto:photos[0]];
    }];
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)setCameraImage:(UIImage *)cameraImage{
    if (!cameraImage)return;
    [self requestChangeInfoLogoWithPhoto:cameraImage];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //头像
        [self makePhotoTake];
    }else if (indexPath.row == 3){
        //性别
        [[UIApplication sharedApplication].keyWindow addSubview:self.sexPicker];
    }else if (indexPath.row == 4){
        //生日
        [[UIApplication sharedApplication].keyWindow addSubview:self.datePicker];
    }else if (indexPath.row == 6){
        //修改密码
        MDChangePassWordViewController * vc = [[MDChangePassWordViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //0用户名,1邮箱,2姓名,5城市
        MDPersonInfoSetViewController * vc = [[MDPersonInfoSetViewController alloc]init];
        if (indexPath.row == 0) {
            vc.status = MaldivesType_InfoChange_UserNmae;
        }else if (indexPath.row == 1){
            vc.status = MaldivesType_InfoChange_Email;
        }else if (indexPath.row == 2){
            vc.status = MaldivesType_InfoChange_RealName;
        }else if (indexPath.row == 5){
            vc.status = MaldivesType_InfoChange_City;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.conArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.conArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * personInfoCell = [tableView dequeueReusableCellWithIdentifier:@"personInfoCell"];
    if (!personInfoCell) {
        personInfoCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"personInfoCell"];
    }
    personInfoCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    personInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    personInfoCell.textLabel.text = self.conArr[indexPath.section][indexPath.row];
    
    if (indexPath.row >= 1) {
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KScreenWidth, 1.f)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#d6d6d6"];
        [personInfoCell addSubview:lineView];
    }
    
    if (indexPath.section == 0) {
        //头像
        if (!self.imageView) {
            self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth - 55.f, 10.f, 24.f, 24.f)];
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:[UserSession instance].logo?[UserSession instance].logo:@"Head-portrait"] placeholderImage:[UIImage imageNamed:@"Head-portrait"] completed:nil];
            self.imageView.layer.cornerRadius = 12.f;
            self.imageView.layer.masksToBounds = YES;
        }
        [personInfoCell addSubview:self.imageView];
    }else if(indexPath.row < [self.conArr[indexPath.section] count] - 1){
        personInfoCell.detailTextLabel.textColor = [UIColor lightGrayColor];
        switch (indexPath.row) {
            case 0:
                personInfoCell.detailTextLabel.text = [UserSession instance].name?[UserSession instance].name:@"选填";
                break;
            case 1:
                personInfoCell.detailTextLabel.text = [UserSession instance].email?[UserSession instance].email:@"选填";
                break;
            case 2:
                personInfoCell.detailTextLabel.text = [UserSession instance].realName?[UserSession instance].realName:@"选填";
                break;
            case 3:
                personInfoCell.detailTextLabel.text = [UserSession instance].sex?[[UserSession instance].sex isEqualToString:@"0"]?@"男":@"女":@"选填";
                break;
            case 4:
                personInfoCell.detailTextLabel.text = [UserSession instance].birthday?[UserSession instance].birthday:@"选填";
                break;
            case 5:
                personInfoCell.detailTextLabel.text = [UserSession instance].city?[UserSession instance].city:@"选填";
                break;
                
            default:
                break;
        }
        personInfoCell.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
    }
    
    return personInfoCell;
}

#pragma mark - HTTP
- (void)requestChangeInfoLogoWithPhoto:(UIImage *)image{
    NSDictionary * pragram = @{@"uid":[UserSession instance].token,@"name":@"File"};
    [[HttpObject manager]postPhotoWithType:MaldivesType_InfoChange_Logo withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        [UserSession instance].logo = responsObj[@"imgurl"];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[UserSession instance].logo] placeholderImage:image completed:nil];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
        [self showHUDWithStr:@"Faild" withSuccess:NO];
    } withPhoto:UIImagePNGRepresentation(image)];
}

- (void)requestChangeInfoWithType:(kMaldivesType)type withStr:(NSDictionary *)infoDic{
    __block NSMutableDictionary * pragram = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":[UserSession instance].token}];
    [infoDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString *  _Nonnull info, BOOL * _Nonnull stop) {
        [pragram setObject:info forKey:key];
    }];
    [[HttpObject manager]getDataWithType:(kMaldivesType)type withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        if (type == MaldivesType_InfoChange_Sex) {
            [UserSession instance].sex = infoDic[@"sex"];
        }else{
            [UserSession instance].birthday = infoDic[@"birthday"];
        }
        [self.tableView reloadData];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",responsObj);
        MyLog(@"Error is %@",error);
    }];
}


- (void)requestLoginOut{
    NSDictionary * pragram = @{@"token":[UserSession instance].token};
    [[HttpObject manager]getDataWithType:(kMaldivesType)MaldivesType_LoginOut withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",responsObj);
        MyLog(@"Error is %@",error);
    }];
}

@end
