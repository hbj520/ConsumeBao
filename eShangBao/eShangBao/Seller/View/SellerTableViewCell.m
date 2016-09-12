//
//  SellerTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/1/14.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "SellerTableViewCell.h"

@implementation SellerTableViewCell

- (void)awakeFromNib {
    
    
    _storeImageView.layer.masksToBounds=YES;
    // Initialization code
}
//配置数据
-(void)setListModel:(SellerListModel *)listModel
{
    [_storeImageView setImageWithURLString:listModel.doorImg placeholderImage:DEFAULTIMAGE];
   
    if (listModel.branchName.length!=0&&listModel.shopName!=0) {
        _storeName.text=[NSString stringWithFormat:@"%@(%@)",listModel.shopName,listModel.branchName];
    }
    else if (listModel.branchName.length==0&&listModel.shopName!=0) {
         _storeName.text=listModel.shopName;
    }
    else if (listModel.branchName.length!=0&&listModel.shopName.length==0)
    {
        _storeName.text=listModel.branchName;
    }
    else
    {
        _storeName.text=@"";
    }
    _monthNum.text=[NSString stringWithFormat:@"月销量%@",listModel.monthOrderNum];
    if (listModel.shopAddr.length==0) {
        _dizhiImg.hidden=YES;
    }
    else
    {
        _dizhiImg.hidden=NO;
    }
    if ([listModel.isSupportGold intValue]==0) {
        _fanbiImg.hidden=YES;
    }
    else
    {
        _fanbiImg.hidden=NO;
    }
    _addressName.text=listModel.shopAddr;
    int starNum=[listModel.score intValue];
    
    _starImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d_05",starNum]];
    

}

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(320, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
