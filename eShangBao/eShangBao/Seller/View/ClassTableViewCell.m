//
//  ClassTableViewCell.m
//  eShangBao
//
//  Created by Dev on 16/1/19.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "ClassTableViewCell.h"

@implementation ClassTableViewCell

- (void)awakeFromNib {
    
    _storeImage.layer.masksToBounds=YES;
    // Initialization code
}

-(void)setListModel:(SellerListModel *)ListModel
{
    [_storeImage setImageWithURLString:ListModel.doorImg placeholderImage:DEFAULTIMAGE];
    _storeName.text=ListModel.shopName;
    NSString *distance=(ListModel.distance.length==0)?@"0":ListModel.distance;
    if ([distance intValue]<100) {
        _storeDistance.text=[NSString stringWithFormat:@"%@m",distance];
    }
    else
    {
        
        _storeDistance.text=[NSString stringWithFormat:@"%.2fkm",[distance floatValue]/1000];
    }
    
    _monthNum.text=[NSString stringWithFormat:@"月销量%@",ListModel.monthOrderNum];
    NSString *startSendPrice=(ListModel.startSendPrice.length==0)?@"0":ListModel.startSendPrice;
    NSString *sendPrice=(ListModel.sendPrice.length==0)?@"0":ListModel.sendPrice;
    _starLabel.text=[NSString stringWithFormat:@"起送¥%@｜配送¥%@",startSendPrice,sendPrice];
    _addrLabel.text=ListModel.shopAddr;
    int starNum=[ListModel.score intValue];
    _starImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d_05",starNum]];
//#warning 需判断是否支持返币 等待接口调试。。。
    if ([ListModel.isSupportGold intValue]==1) {
        _fanImage.hidden=NO;
    }else{
        _fanImage.hidden=YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
