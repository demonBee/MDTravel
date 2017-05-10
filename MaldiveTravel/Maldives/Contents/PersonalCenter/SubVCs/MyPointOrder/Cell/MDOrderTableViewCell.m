//
//  MDOrderTableViewCell.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/15.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDOrderTableViewCell.h"

@implementation MDOrderTableViewCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.colorArr = @[@{@"labelColor":[UIColor redColor],@"labelText":@"待处理",@"btnColor":[UIColor colorWithHexString:@"ffc106"],@"btnText":@"取消"},
            @{@"labelColor":[UIColor colorWithHexString:@"ffc106"],@"labelText":@"已发货",@"btnColor":[UIColor blackColor],@"btnText":@"物流详情"},
            @{@"labelColor":[UIColor lightGrayColor],@"labelText":@"订单已取消",@"btnColor":[UIColor redColor],@"btnText":@"重新购买"},
            @{@"labelColor":[UIColor colorWithHexString:@"ffc106"],@"labelText":@"已签收",@"btnColor":[UIColor blackColor],@"btnText":@"物流详情"}];//右上label颜色;右上label文字;右下btn颜色;右下btn文字
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.sureBtn.layer.cornerRadius = 5.f;
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.borderWidth = 1.f;
    self.sureBtn.layer.borderColor = [UIColor redColor].CGColor;
    
    self.showBtn.layer.cornerRadius = 5.f;
    self.showBtn.layer.masksToBounds = YES;
    self.showBtn.layer.borderWidth = 1.f;
    self.showBtn.layer.borderColor = [UIColor colorWithHexString:@"ffc106"].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(MDOrderModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
}

- (void)dataSet{
    
    NSArray * statusArr = @[@"2",@"0",@"1",@"3"];
    self.status = statusArr[[self.model.status integerValue]];
    self.selectColorDic = self.colorArr[[self.status integerValue]];
    
    UIColor * labelColor = self.selectColorDic[@"labelColor"];
    self.orderStateLabel.textColor = labelColor;
    self.orderStateLabel.text = self.selectColorDic[@"labelText"];
    
    UIColor * btnColor = self.selectColorDic[@"btnColor"];
    self.showBtn.layer.borderColor = btnColor.CGColor;
    [self.showBtn setTitleColor:btnColor forState:UIControlStateNormal];
    [self.showBtn setTitle:self.selectColorDic[@"btnText"] forState:UIControlStateNormal];
    
    self.sureBtn.hidden = [self.status integerValue] == 1?NO:YES;
    
    self.orderIDLabel.text = self.model.order_id;
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:self.model.pic] placeholderImage:[UIImage imageNamed:@"my-order-pic"] completed:nil];
    self.nameLabel.text = self.model.product_name;
    self.countLabel.text = [NSString stringWithFormat:@"x%@",self.model.num];
    self.priceLabel.text  = [NSString stringWithFormat:@"%@积分",self.model.allpoint];
}

- (IBAction)sureBtnAction:(id)sender {
    if (!self.status)return;
    self.sureBlock();
}

- (IBAction)showBtnAction:(id)sender {
    if (!self.status)return;
    self.showBlock(self.status);//多个状态下显示不同0取消1物流详情2重新购买3物流详情
}


@end
