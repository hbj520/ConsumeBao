//
//  HHRTableViewCell.m
//  eShangBao
//
//  Created by Dev on 16/6/30.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "HHRTableViewCell.h"

@implementation HHRTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark - 商品信息
-(void)setGroundModel:(GroundingModel *)groundModel
{
    [_goodsImage setImageWithURLString:groundModel.imgUrl placeholderImage:DEFAULTIMAGE];
    _goodsName.text=[NSString stringWithFormat:@"%@",groundModel.goodsName];
    _goodsPrice.text=[NSString stringWithFormat:@"¥%@",groundModel.price];
//    _goodsDescribe.text= 却少参数
    
}

#pragma mark -  评论基本信息
-(void)setCommentModel:(CommentModel *)commentModel
{

    [_userImage setImageWithURLString:commentModel.memberImgUrl placeholderImage:@"头像"];
 
    _userPhone.text=(commentModel.memberName.length>0)?[NSString stringWithFormat:@"%@****%@",[commentModel.memberName substringToIndex:1],[commentModel.memberName substringFromIndex:commentModel.memberName.length-1]]:@"**";
    int starNum=[commentModel.score intValue];
    _commentStar.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d_05副本",starNum]];
    
    _contentLabel.text=commentModel.content;
    _createDate.text=[NSString showTimeFormat:commentModel.createdate Format:@"YYYY-MM-dd "];
    
    
}

-(void)setStoreComment:(CommentList *)storeComment
{

    [_userImage setImageWithURLString:storeComment.memberImgUrl placeholderImage:@"头像"];
    _userPhone.text=[NSString stringWithFormat:@"%@****%@",[storeComment.memberName substringToIndex:1],[storeComment.memberName substringFromIndex:storeComment.memberName.length-1]];
    int starNum=[storeComment.score intValue];
    _commentStar.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d_05副本",starNum]];
    
    _contentLabel.text=storeComment.content;
    _createDate.text=[NSString stringWithFormat:@"%@",[NSString showTimeFormat:storeComment.createdate Format:@"YYYY-MM-dd"]];
}

-(void)setInfoModel:(PurchaseRecordModel *)infoModel
{
    _userName.text=infoModel.memberName;
    _buyDate.text=[NSString stringWithFormat:@"%@",infoModel.buyDate];
    [_buyImageView setImageWithURLString:infoModel.memberImgUrl placeholderImage:@"头像"];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
