//
//  goodInfoView.m
//  eShangBao
//
//  Created by Dev on 16/1/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "goodInfoView.h"

@implementation goodInfoView

-(void)setGoodsModel:(GoodsInfoModel *)goodsModel
{
    
    _goodsHeadImage.layer.masksToBounds=YES;
    _goodsHeadImage.contentMode=1;
    [_goodsHeadImage setImageWithURLString:goodsModel.imgUrl placeholderImage:DEFAULTIMAGE];
    _goodsName.text=goodsModel.goodsName;
    if ([goodsModel.price intValue]==0) {
        _goodsPrice.text=[NSString stringWithFormat:@"￥0"];
    }
    else
    {
        _goodsPrice.text=[NSString stringWithFormat:@"¥%@",goodsModel.price];
    }
    
    float returnBate;
    float floatBate;
//    int   intBate;
    if ([goodsModel.returnBate intValue]==0) {
        returnBate=0;
    }
    returnBate=[goodsModel.returnBate floatValue];
    floatBate=returnBate*100;
    NSString *intBate=[NSString stringWithFormat:@"%.1f",floatBate];
//    intBate=floatBate;
    
    _returnBate.text=[NSString stringWithFormat:@"%@％通宝币",intBate];
    if ([goodsModel.monthOrderNum intValue]==0) {
        _monthOrderNum.text=[NSString stringWithFormat:@"销售 0"];
    }
    else
    {
         _monthOrderNum.text=[NSString stringWithFormat:@"销售%@",goodsModel.monthOrderNum];
    }
   
    if ([goodsModel.stock intValue]==0) {
        _stock.text=@"库存0";
    }
    else
    {
        _stock.text=[NSString stringWithFormat:@"库存%@",goodsModel.stock];
    }
    
    
}

@end
