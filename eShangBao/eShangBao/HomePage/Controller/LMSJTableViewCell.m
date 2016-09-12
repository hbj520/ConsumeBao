//
//  LMSJTableViewCell.m
//  eShangBao
//
//  Created by Dev on 16/6/29.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "LMSJTableViewCell.h"

@implementation LMSJTableViewCell

- (void)awakeFromNib {
    
    _storeImage.layer.masksToBounds=YES;
    // Initialization code
}


-(void)setListModel:(SellerListModel *)ListModel
{
    [_storeImage setImageWithURLString:ListModel.doorImg placeholderImage:DEFAULTIMAGE];
    if (ListModel.branchName.length==0&&ListModel.shopName.length!=0) {
        _storeName.text=ListModel.shopName;
    }
    if (ListModel.branchName.length!=0&&ListModel.shopName.length!=0) {
       _storeName.text=[NSString stringWithFormat:@"%@(%@)",ListModel.shopName,ListModel.branchName];
    }
    if (ListModel.branchName.length!=0&&ListModel.shopName.length==0) {
        _storeName.text=ListModel.branchName;
    }
    if (ListModel.branchName.length==0&&ListModel.shopName.length==0) {
        _storeName.text=@"";
    }
    
     NSString *distance=(ListModel.distance.length==0)?@"0":ListModel.distance;
    if ([distance intValue]<100) {
        _distanceLabel.text=[NSString stringWithFormat:@"%@m",distance];
    }
    else
    {
        
        _distanceLabel.text=[NSString stringWithFormat:@"%.2fkm",[distance floatValue]/1000];
    }
    
    
    
    _storeAddress.text=ListModel.shopAddr;
    int starNum=[ListModel.score intValue];
    _storeStar.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d_05",starNum]];
    if (starNum>5) {
        
        _storeStar.image=[UIImage imageNamed:[NSString stringWithFormat:@"5_05"]];
    }
    //#warning 需判断是否支持返币 等待接口调试。。。
    float shopreturnrate=[ListModel.shopreturnrate floatValue];
    shopreturnrate=shopreturnrate*100;
    if (shopreturnrate==0) {
        
        _goldNumLabel.hidden=YES;
        
    }else{
        _goldNumLabel.hidden=NO;
       _goldNumLabel.text=[NSString stringWithFormat:@"返币%.1f%@",shopreturnrate,@"%"];
    }

        _fanImage.hidden=YES;

}

-(void)setCollectModel:(MycollectModel *)collectModel
{
    
    [_storeImage setImageWithURLString:collectModel.doorImg placeholderImage:DEFAULTIMAGE];
    
    _storeName.text=(collectModel.branchName.length==0)?collectModel.shopName:[NSString stringWithFormat:@"%@(%@)",collectModel.shopName,collectModel.branchName];
    _storeAddress.text=collectModel.shopAddr;
    int starNum=[collectModel.score intValue];
    _storeStar.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d_05",starNum]];
    if (starNum>5) {
        
        _storeStar.image=[UIImage imageNamed:[NSString stringWithFormat:@"5_05"]];
    }
    _fanImage.hidden=YES;
    float shopreturnrate=[collectModel.shopreturnrate floatValue];
    shopreturnrate=shopreturnrate*100;
    
    _distanceLabel.text=@"已收藏";
    
    if (shopreturnrate==0) {
        
        _goldNumLabel.hidden=YES;
        
    }else{
        _goldNumLabel.hidden=NO;
        _goldNumLabel.text=[NSString stringWithFormat:@"返币%.1f%@",shopreturnrate,@"%"];
    }
 
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
