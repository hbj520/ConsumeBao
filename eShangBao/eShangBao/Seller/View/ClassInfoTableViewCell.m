//
//  ClassInfoTableViewCell.m
//  eShangBao
//
//  Created by Dev on 16/1/20.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "ClassInfoTableViewCell.h"

@implementation ClassInfoTableViewCell

- (void)awakeFromNib {
    
    _classInfocellImage.layer.masksToBounds=YES;
    _classInfoCellZanNum.hidden=YES;
    _classZan.hidden=YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setGoodListModel:(SellerGoodsListModel *)goodListModel
{
    _goodListModel=goodListModel;
    
    _classInfoFanNum.hidden=NO;
    _backMoneyLabel.hidden=NO;
    [_classInfocellImage setImageWithURLString:goodListModel.imgUrl placeholderImage:DEFAULTIMAGE];
    _classInfoCellName.text=goodListModel.goodsName;
    
    if ([goodListModel.returnBate floatValue]==0) {
        _classInfoFanNum.hidden=YES;
        _backMoneyLabel.hidden=YES;
    }else{
        
        float returnBate=[goodListModel.returnBate floatValue];
        float floatBate=returnBate*100;
//        int   intBate=floatBate;
        NSString * intBate=[NSString stringWithFormat:@"%.1f",floatBate];
        _classInfoFanNum.text=[NSString stringWithFormat:@"%@％",intBate];
    }
    _classInfoCellMonthNum.text=[NSString stringWithFormat:@"月售%@",goodListModel.monthOrderNum];
    //_classInfoCellZanNum.text=[NSString stringWithFormat:@"%@",goodListModel.]
    _classInfoCellMoneyNum.text=[NSString stringWithFormat:@"¥%@",goodListModel.price];
    
}
-(void)setChooseGoodsNum:(NSString *)chooseGoodsNum
{
    _classInfoCellNum.text=@"0";
    _classInfoCellReduction.hidden=NO;
    _classInfoCellNum.hidden=NO;
    if ([chooseGoodsNum intValue]==0||chooseGoodsNum==nil) {
        _classInfoCellReduction.hidden=YES;
        _classInfoCellNum.hidden=YES;
        return;
    }
    
    _classInfoCellNum.text=chooseGoodsNum;
    
}


- (IBAction)addNumButton:(id)sender {
    
    _classInfoCellReduction.hidden=NO;
    _classInfoCellNum.hidden=NO;
    _classInfoCellNum.text=[NSString stringWithFormat:@"%d",[_classInfoCellNum.text intValue]+1];
    
    
    _goodListModel.chooseNum=_classInfoCellNum.text;
    
    //int num=[_classInfoCellNum.text intValue];
    DMLog(@"%@",_classInfoCellNum.text);
    if ([_delegate performSelector:@selector(addAndReductionDelegateType:)]) {
        [_delegate getGoodsinfoData:_goodListModel];
        [_delegate addAndReductionDelegateType:1];
    }

    
}
- (IBAction)reductionNumButton:(id)sender {
    
    if ([_classInfoCellNum.text intValue]==0)
        return;
    _classInfoCellNum.text=[NSString stringWithFormat:@"%d",[_classInfoCellNum.text intValue]-1];
    
    if ([_classInfoCellNum.text intValue]==0) {
        _classInfoCellReduction.hidden=YES;
        _classInfoCellNum.hidden=YES;
    }
    _goodListModel.chooseNum=_classInfoCellNum.text;
    DMLog(@"%d",[_classInfoCellNum.text intValue]);
    
    if ([_delegate performSelector:@selector(addAndReductionDelegateType:)]) {
        
        [_delegate getGoodsinfoData:_goodListModel];
        [_delegate addAndReductionDelegateType:2];

    }
    

}
- (IBAction)chooseAddBtn:(id)sender {
    DMLog(@"添加");
    _chooseNum.text=[NSString stringWithFormat:@"%d",[_chooseNum.text intValue]+1];
    DMLog(@"%@",_classInfoCellNum.text);
    _goodListModel.chooseNum=_chooseNum.text;
    if ([_delegate performSelector:@selector(addAndReductionDelegateType:)]) {
        [_delegate getGoodsinfoData:_goodListModel];
        [_delegate addAndReductionDelegateType:1];
    }
}

- (IBAction)chooseReductionBtn:(id)sender {
    DMLog(@"减少");
    _chooseNum.text=[NSString stringWithFormat:@"%d",[_chooseNum.text intValue]-1];
    _goodListModel.chooseNum=_chooseNum.text;
    if ([_delegate performSelector:@selector(addAndReductionDelegateType:)]) {
        [_delegate getGoodsinfoData:_goodListModel];
        [_delegate addAndReductionDelegateType:2];
    }
}


-(void)setCommentModel:(CommentList *)commentModel
{
    
    
    
    ;
    if (commentModel.memberName.length<3) {
    
//        if (<#condition#>) {
//            <#statements#>
//        }
        if (commentModel.memberName.length==0) {
            _commentName.text=@"匿名用户";
        }
        else
        {
            NSString  *newName=[commentModel.memberName substringToIndex:1];
            _commentName.text=[NSString stringWithFormat:@"%@***",newName];
        }
        
        
    }else{
        
        NSString  *newName=[commentModel.memberName substringToIndex:1];
        
        NSString *newNameTwo=[commentModel.memberName substringFromIndex:commentModel.memberName.length-1];
        _commentName.text=[NSString stringWithFormat:@"%@***%@",newName,newNameTwo];
        DMLog(@"%@--%@",newName,newNameTwo);
    }
    _commentContent.text=commentModel.content;
    int starNum=[commentModel.score intValue];
    if (starNum<5) {
        _commentStarImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d_003",starNum]];
    }
    else
    {
        _commentStarImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"5_003"]];
    }
    

    
    //_commentName.text=[];
    
    
}



@end
