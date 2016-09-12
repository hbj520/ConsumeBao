//
//  GorundingCollectionViewCell.m
//  eShangBao
//
//  Created by doumee on 16/4/5.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "GorundingCollectionViewCell.h"

@implementation GorundingCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        _recImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, W(150), H(100))];
        _recImg.image=[UIImage imageNamed:@"sj01"];
        _recImg.layer.masksToBounds=YES;
        _recImg.opaque=YES;
        _recImg.layer.cornerRadius=3;
        _recImg.contentMode=2;
        [self.contentView addSubview:_recImg];
        
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(2, kDown(_recImg)+2, W(150), H(20))];
        _nameLabel.text=@"商品名称商品名称商品名称商品名称商品名称商品名称商品名称";
        _nameLabel.opaque=YES;
        _nameLabel.font=[UIFont systemFontOfSize:12];
        _nameLabel.textColor=MAINCHARACTERCOLOR;
        [self.contentView addSubview:_nameLabel];
        
        _priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(2, kDown(_nameLabel)+10, W(90), H(20))];
        _priceLabel.text=@"售价￥49";
        _priceLabel.font=[UIFont systemFontOfSize:12];
        _priceLabel.textColor=RGBACOLOR(247, 137, 0, 1);
        [self.contentView addSubview:_priceLabel];
        
        _backCoinLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_priceLabel), kDown(_nameLabel)+10, W(50), H(20))];
        _backCoinLabel.font=[UIFont systemFontOfSize:12];
        _backCoinLabel.text=@"返现10%";
        _backCoinLabel.textColor=GRAYCOLOR;
        [self.contentView addSubview:_backCoinLabel];
    }
    
    return self;
}

@end
