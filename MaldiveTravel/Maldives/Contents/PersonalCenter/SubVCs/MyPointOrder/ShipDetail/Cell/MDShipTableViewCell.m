//
//  MDShipTableViewCell.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/15.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDShipTableViewCell.h"

@implementation MDShipTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MDShipModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
}

- (void)dataSet{
    self.statusLabel.attributedText = [NSString stringWithFirstStr:@"物流状态    " withFont:[UIFont systemFontOfSize:14.f] withColor:[UIColor colorWithHexString:@"#333333"] withSecondtStr:self.model.status.status withFont:[UIFont systemFontOfSize:14.f] withColor:[UIColor colorWithHexString:@"#ffc106"]];
    self.shipLabel.attributedText = [NSString stringWithFirstStr:@"承运来源    " withFont:[UIFont systemFontOfSize:14.f] withColor:[UIColor colorWithHexString:@"#333333"] withSecondtStr:self.model.status.express?self.model.status.express:@"" withFont:[UIFont systemFontOfSize:14.f] withColor:[UIColor colorWithHexString:@"#333333"]];
    self.orderIDLabel.attributedText = [NSString stringWithFirstStr:@"订单编号    " withFont:[UIFont systemFontOfSize:14.f] withColor:[UIColor colorWithHexString:@"#333333"] withSecondtStr:self.model.status.order_id withFont:[UIFont systemFontOfSize:14.f] withColor:[UIColor colorWithHexString:@"#519bf4"]];
    
}

@end
