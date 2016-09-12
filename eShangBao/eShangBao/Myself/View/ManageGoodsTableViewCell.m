//
//  ManageGoodsTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/1/21.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "ManageGoodsTableViewCell.h"
#import "goodsInfoViewController.h"

@implementation ManageGoodsTableViewCell

- (void)awakeFromNib {
    
    
//    _fanbiLabel.layer.borderWidth=1;÷
//    _fanbiLabel.layer.borderColor=MAINCOLOR.CGColor;
//    _fanbiLabel.layer.cornerRadius=3;
//    _fanbiLabel.layer.masksToBounds=YES;
    // Initialization code
}
- (IBAction)chooseBtnClick:(id)sender {
    
    UIButton *newBtn=(UIButton *)sender;    
    if ([_delegate performSelector:@selector(manageDelegate:)]) {
        
        [_delegate manageModelDelegate:_goodsModel];
        [_delegate manageDelegate:(int)newBtn.tag];
        
    }
//    if ([_delegate performSelector:@selector(manageModelDelegate:)]) {
//        
//
//    }
}

-(void)setIsDelete:(NSString *)isDelete
{
    if ([isDelete intValue]==0) {
        _shelvesImage.image=[UIImage imageNamed:@"下架"];
        _shelvesLabel.text=@"下架";
    }else{
        
        _shelvesImage.image=[UIImage imageNamed:@"上架"];
        _shelvesLabel.text=@"上架";
    }
    
    
    
}

-(void)setGoodsModel:(SellerGoodsListModel *)goodsModel
{
    _goodsModel=goodsModel;
    [_storeImage setImageWithURLString:goodsModel.imgUrl placeholderImage:DEFAULTIMAGE];
    _goodsName.text=goodsModel.goodsName;
    _goodsPrice.text=[NSString stringWithFormat:@"%@",goodsModel.price];
    float returnBate=[goodsModel.returnBate floatValue];
    float floatBate=returnBate*100;
//    int   intBate=floatBate;
    NSString * intBate=[NSString stringWithFormat:@"%.1f",floatBate];

    _fanbiLabel.hidden=NO;
    
    if ([intBate isEqualToString:@"0.0"]) {
        _fanbiLabel.text=@"0";
        _fanbiLabel.hidden=YES;
    }
    else
    {
        _fanbiLabel.text=[NSString stringWithFormat:@"%@％返币",intBate];
    }
    
    
    NSString *stockNum=(goodsModel.stockNum==nil)?@"0":(NSString *)goodsModel.stockNum;
    _goodsSales.text=[NSString stringWithFormat:@"销量%@ 库存%@",goodsModel.monthOrderNum,stockNum];
    _createTime.text=[NSString showTimeFormat:[NSString stringWithFormat:@"%@",goodsModel.createDate] Format:@"YYYY-MM-dd-HH:mm:ss"];

}


- (IBAction)nextBtnClick:(id)sender {
    
    DMLog(@"跳转至下一页");
}

-(void)setCategroyModel:(categoryListModel *)categroyModel
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenCatetgoryBtn) name:@"hiddenCatetgoryBtn" object:nil];
    _categoryName.text=categroyModel.cateName;
    _goodsNum.text=[NSString stringWithFormat:@"共%@件商品",categroyModel.productNum];
}
-(void)hiddenCatetgoryBtn
{
    _editorBtn.hidden=!_editorBtn.hidden;
    _deleteBtn.hidden=!_deleteBtn.hidden;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
