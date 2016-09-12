//
//  ClassHeadView.m
//  eShangBao
//
//  Created by Dev on 16/1/20.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "ClassHeadView.h"

@implementation ClassHeadView
{
    BOOL look;
}

-(void)awakeFromNib
{
    _allComments.layer.cornerRadius=14;
    _allComments.layer.masksToBounds=YES;
    _goodsComments.layer.cornerRadius=14;
    _goodsComments.layer.masksToBounds=YES;
    _generalComments.layer.cornerRadius=14;
    _generalComments.layer.masksToBounds=YES;
    _poorComments.layer.cornerRadius=14;
    _poorComments.layer.masksToBounds=YES;
    _selectedBtn=(UIButton *)[self viewWithTag:1];
}

-(void)setInfoMedel:(SellerInfoModel *)infoMedel
{
    
    _allScoreLabel.text=[NSString stringWithFormat:@"%.1f",[infoMedel.totalScore floatValue]];
    _quelityScoreLabel.text=[NSString stringWithFormat:@"%.1f",[infoMedel.qualityScore floatValue]];
    _sendScoreLabel.text=[NSString stringWithFormat:@"%.1f",[infoMedel.sendScore floatValue]];
    
    int maxComment=[infoMedel.maxScoreCount intValue];
    int mediumComment=[infoMedel.mediumScoreCount intValue];
    int minComment=[infoMedel.minScoreCount intValue];
    int allComment=maxComment+mediumComment+minComment;
    
    [_allComments setTitle:[NSString stringWithFormat:@"全部(%d)",allComment] forState:0];
    [_goodsComments setTitle:[NSString stringWithFormat:@"好评(%d)",maxComment] forState:0];
    [_generalComments setTitle:[NSString stringWithFormat:@"中评(%d)",mediumComment] forState:0];
    [_poorComments setTitle:[NSString stringWithFormat:@"差评(%d)",minComment] forState:0];    
}

-(void)setContentMode:(UIViewContentMode)contentMode
{
    
}


- (IBAction)chooseTheCommentsBtn:(id)sender {

    UIButton *newBtn=(UIButton *)sender;
    if (newBtn!=_selectedBtn) {
        
        newBtn.backgroundColor=MAINCOLOR;
        [newBtn setTitleColor:[UIColor whiteColor] forState:0];
        _selectedBtn.backgroundColor=RGBACOLOR(248, 220, 200, 1);
        [_selectedBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
        _selectedBtn=newBtn;
    }
//    
//    if ([_delegate performSelector:@selector(chooseCommenType:)]) {
//        
//        [_delegate chooseCommenType:(int)newBtn.tag];
//    }
    
}
- (IBAction)lookTheHaveContentBtn:(id)sender {
    
    if (!look) {
        
        [_contentBtn setImage:[UIImage imageNamed:@"see_yes"] forState:0];
    }else{
        [_contentBtn setImage:[UIImage imageNamed:@"see_no"] forState:0];
    }
    look=!look;
}

@end
