//
//  OrderDetaileTableViewCell.m
//  eShangBao
//
//  Created by Dev on 16/1/27.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "OrderDetaileTableViewCell.h"

@implementation OrderDetaileTableViewCell

- (void)awakeFromNib {
    _payButton.layer.cornerRadius=5;
    _payButton.layer.masksToBounds=YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
