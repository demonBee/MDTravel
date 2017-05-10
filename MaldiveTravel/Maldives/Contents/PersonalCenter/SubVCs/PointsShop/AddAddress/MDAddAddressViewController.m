//
//  MDAddAddressViewController.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/15.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDAddAddressViewController.h"
#import "JXLcoationViewController.h"
#import "MDStreetAddressViewController.h"
#import "MDMyPointOrderViewController.h"

#import "MDTextView.h"

#define RECORD_ADDRESS @"record_address"
@interface MDAddAddressViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong)NSMutableDictionary * addressDic;
@property (nonatomic,strong)NSArray * addressKeyArr;
@property (nonatomic,strong)NSArray * tittleArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation MDAddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  @"添加收货地址";
    [self makeNavi];
    [self getAddress];
}
- (void)makeNavi{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];//调位置
    negativeSpacer.width = -10.f;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, [UIBarButtonItem barItemWithImageName:nil withSelectImage:nil withHorizontalAlignment:UIControlContentHorizontalAlignmentLeft withTittle:@"保存" withTittleColor:[UIColor lightGrayColor] withTarget:self action:@selector(saveAddressInfo) forControlEvents:UIControlEventTouchUpInside  withWidth:40.f], nil];
}

- (void)getAddress{
    NSDictionary *recordAddressDic = [NSDictionary dictionaryWithDictionary:[KUSERDEFAULT objectForKey:RECORD_ADDRESS]];
    if (recordAddressDic[@"name"]) {
        self.addressDic = [NSMutableDictionary dictionaryWithDictionary:recordAddressDic];
    }else{
        self.addressDic = [NSMutableDictionary dictionaryWithDictionary:@{@"name":@"",@"mobile":[UserSession instance].account,@"city":@"",@"street":@"",@"address":@""}];
    }
    
    self.tittleArr = @[@"收货人:",@"联系电话:",@"所在城市:",@"街区:",@""];
    self.addressKeyArr = @[@"name",@"mobile",@"city",@"street",@"address"];
}
- (void)saveAddressInfo{
    //判断空
    NSDictionary * hudStrDic = @{@"name":@"姓名",@"mobile":@"电话",@"city":@"城市",@"street":@"街区",@"address":@"详细住址"};
    __block NSString * nullStr;
    [self.addressKeyArr enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.addressDic[key] isEqualToString:@""]&& !nullStr) {
            nullStr = hudStrDic[key];
        }
    }];
    if (nullStr) {
        [self showHUDWithStr:[NSString stringWithFormat:@"请完善%@",nullStr] withSuccess:NO];
        return ;
    }
    //判断手机号
    if (![JWTools checkTelNumber:self.addressDic[@"mobile"]]) {
        [self showHUDWithStr:@"请添加正确的手机号" withSuccess:NO];
        return;
    }
    //地址详细判断
    NSString * address = self.addressDic[@"address"];
    if (address.length < 5){
        [self showHUDWithStr:@"请添加详细地址" withSuccess:NO];
        return;
    }
    
    [self requestSendAddress];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
        return 101.f;
    }
    return 44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        JXLcoationViewController * vc = [[JXLcoationViewController alloc]init];
        WEAKSELF;
        vc.selectedCityBlock = ^(AreaModel * area){
            [weakSelf.addressDic setObject:area.areaName forKey:@"city"];
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 3){
        MDStreetAddressViewController * vc = [[MDStreetAddressViewController alloc]init];
        vc.streetChooseBlock = ^(NSString * street){
            [self.addressDic setObject:street forKey:@"street"];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * addressCell = addressCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"pointAddressCell"];
    NSString * conStr = self.addressDic[self.addressKeyArr[indexPath.row]];
    
    addressCell.selectionStyle = UITableViewCellSelectionStyleNone;
    addressCell.textLabel.text = self.tittleArr[indexPath.row];
    if (indexPath.row <= 1) {
        UITextField * textFiled = [[UITextField alloc]initWithFrame:CGRectMake(93.f, 7.f, KScreenWidth - 93.f - 10.f, 30.f)];
        textFiled.placeholder = indexPath.row == 0?@"收货人姓名":@"电话号码";
        textFiled.delegate = self;
        textFiled.tag = indexPath.row + 1000;
        textFiled.text = conStr;
        textFiled.clearsOnBeginEditing = YES;
        [addressCell addSubview:textFiled];
    }else if (indexPath.row <= 3){
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(93.f, 7.f, KScreenWidth - 73.f - 10.f, 30.f)];
        label.text = conStr;
        [addressCell addSubview:label];
        
        addressCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel * showLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth - 73.f, label.y, 44.f, label.height)];
        showLabel.font = [UIFont systemFontOfSize:14.f];
        showLabel.text = indexPath.row == 2?@"请选择":@"去填写";
        showLabel.textColor = [UIColor lightGrayColor];
        [addressCell addSubview:showLabel];
    }else{
        MDTextView * textView = [[MDTextView alloc]initWithFrame:CGRectMake(10.f, 1.f, KScreenWidth - 20.f, 100.f)];
        textView.delegate = self;
        textView.text = conStr;
        if ([conStr isEqualToString:@""]) {
            textView.placeholderColor = [UIColor lightGrayColor];
            textView.placeholder = @"请填写详细地址,不少于5字";
        }
        [addressCell addSubview:textView];
    }
    
    if (indexPath.row >= 1) {
        //加线条
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, KScreenWidth, 1.f)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#d6d6d6"];
        [addressCell addSubview:lineView];
    }
    return addressCell;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    [self.addressDic setObject:textView.text forKey:@"address"];
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        [self saveAddressInfo];
    }
    
    return YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [self.addressDic setObject:textField.text forKey:textField.tag == 1000? @"name":@"mobile"];
    if ([string isEqualToString:@"\n"]){
        [textField resignFirstResponder];
        [self saveAddressInfo];
    }
    
    return YES;
}

#pragma mark - Http
- (void)requestSendAddress{
    MyLog(@"Address is %@",self.addressDic);
    [self requestSure];
}
- (void)requestSendOrder{
    NSDictionary * pragram = @{@"uid":[UserSession instance].token,@"id":self.idd,@"num":self.payNumber,@"zt":@"shop",@"consignee":self.addressDic[@"name"],@"address":self.addressDic[@"address"],@"tel":self.addressDic[@"mobile"],@"city":self.addressDic[@"city"],@"street":self.addressDic[@"street"]};
    [[HttpObject manager]getDataWithType:MaldivesType_POINT_SHOP_PAY withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        MDMyPointOrderViewController * vc =[[MDMyPointOrderViewController alloc]init];
        vc.isOrderJust = YES;
        [UserSession instance].point = [NSString stringWithFormat:@"%.f",[[UserSession instance].point floatValue] - [self.cost floatValue]*[self.payNumber integerValue]];
        [UserSession newInfoUp];
        [self.navigationController pushViewController:vc animated:YES];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",errorData);
        MyLog(@"Error is %@",error);
        [self showHUDWithStr:errorData[@"errorMessage"] withSuccess:NO];
    }];
}
- (void)requestSure{
    //保存地址
    [KUSERDEFAULT setObject:self.addressDic forKey:RECORD_ADDRESS];
    
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self requestSendOrder];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"确认" message:[NSString stringWithFormat:@"确认兑换%@件此商品",self.payNumber] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
