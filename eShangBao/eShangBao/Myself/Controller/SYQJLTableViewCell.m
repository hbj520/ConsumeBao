//
//  SYQJLTableViewCell.m
//  eShangBao
//
//  Created by Dev on 16/7/6.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "SYQJLTableViewCell.h"

@implementation SYQJLTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _headImageView.layer.cornerRadius=10;
    _headImageView.layer.masksToBounds=YES;
    
}

-(void)setInfoModel:(PurchaseProfitModel *)infoModel
{
    _gmNum.text=[NSString stringWithFormat:@"%@",infoModel.num];
    
    if ([infoModel.payStatus intValue]==0) {
        _zfType.text=@"未支付";
        _endDate.text=@"暂无";
//        _titleLabel.hidden=YES;
    }
    else
    {
        _zfType.text=@"已支付";
//        _titleLabel.hidden=NO;
        _endDate.text=[NSString stringWithFormat:@"%@",infoModel.outDate];
    }
    
    _startDate.text=[NSString stringWithFormat:@"%@",infoModel.createDate];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
