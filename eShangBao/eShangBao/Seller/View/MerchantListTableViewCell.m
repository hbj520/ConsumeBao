//
//  MerchantListTableViewCell.m
//  eShangBao
//
//  Created by Dev on 16/1/20.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "MerchantListTableViewCell.h"

@implementation MerchantListTableViewCell

- (void)awakeFromNib {
    
    _merchantImage.layer.masksToBounds=YES;
    // Initialization code
}

-(void)setNearModel:(SellerListModel *)nearModel
{
    [_merchantImage setImageWithURLString:nearModel.doorImg placeholderImage:DEFAULTIMAGE];
    if (nearModel.branchName.length==0) {
        
        _merchantName.text=nearModel.shopName;
    }else
    {
        _merchantName.text=[NSString stringWithFormat:@"%@(%@)",nearModel.shopName,nearModel.branchName];
    }
    NSString *distance=(nearModel.distance.length==0)?@"0":nearModel.distance;
    if ([distance intValue]<100) {
        _merchentDistance.text=[NSString stringWithFormat:@"%@m",distance];
    }
    else
    {
        
        _merchentDistance.text=[NSString stringWithFormat:@"%.2fkm",[distance floatValue]/1000];
    }

//    _merchentDistance.text=[NSString stringWithFormat:@"%@km",distance];
    _merchentMonth.text=[NSString stringWithFormat:@"月销量%@",nearModel.monthOrderNum];
    _merchentAdd.text=nearModel.shopAddr;
    
    int starNum=[nearModel.score intValue];
    _starImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d_05",starNum]];
    if ([nearModel.isSupportGold intValue]==1) {
        _merchantFan.hidden=NO;
    }else{
        _merchantFan.hidden=YES;
    }
    _merchentComment.text=[NSString stringWithFormat:@"%.1f",[nearModel.score floatValue]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
