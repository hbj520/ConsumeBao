//
//  ManageOrderTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/1/21.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "ManageOrderTableViewCell.h"

@implementation ManageOrderTableViewCell

- (void)awakeFromNib {
    _headImg.layer.masksToBounds=YES;
    _headImg.layer.cornerRadius=3;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
