//
//  ShoppingTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/4/6.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "ShoppingTableViewCell.h"

@implementation ShoppingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImg=[[UIImageView alloc]initWithFrame:CGRectMake(W(12), 10, W(50), 50)];
        _headImg.contentMode=2;
        _headImg.layer.masksToBounds=YES;
        [self.contentView addSubview:_headImg];
        
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_headImg)+W(12), 10, W(190), 20)];
        _nameLabel.textColor=MAINCHARACTERCOLOR;
        _nameLabel.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameLabel];
        
        _deleteBtn=[UIButton buttonWithType:0];
        _deleteBtn.frame=CGRectMake(kRight(_nameLabel), 12, W(30), H(20));
        _deleteBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [_deleteBtn setTitle:@"删除" forState:0];
        [_deleteBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
        [self.contentView addSubview:_deleteBtn];
        
        _reduceBtn=[UIButton buttonWithType:0];
        _reduceBtn.layer.borderColor=BGMAINCOLOR.CGColor;
        _reduceBtn.layer.borderWidth=1;
        _reduceBtn.frame=CGRectMake(kRight(_headImg)+W(12), kDown(_nameLabel)+10, W(30), H(20));
        [_reduceBtn setTitle:@"-" forState:0];
        [_reduceBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
        [self.contentView addSubview:_reduceBtn];
        
        _countLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_reduceBtn), kDown(_nameLabel)+10, W(30), H(20))];
        _countLabel.textAlignment=NSTextAlignmentCenter;
        _countLabel.layer.borderColor=BGMAINCOLOR.CGColor;
        _countLabel.layer.borderWidth=1;
        _countLabel.textColor=MAINCHARACTERCOLOR;
        _countLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:_countLabel];
        
        _addBtn=[UIButton buttonWithType:0];
        _addBtn.layer.borderColor=BGMAINCOLOR.CGColor;
        _addBtn.layer.borderWidth=1;
        _addBtn.frame=CGRectMake(kRight(_countLabel), kDown(_nameLabel)+10, W(30), H(20));
        [_addBtn setTitle:@"+" forState:0];
        [_addBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
        [self.contentView addSubview:_addBtn];
        
        _priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_headImg)+W(160), kDown(_nameLabel)+10, W(100), H(20))];
        _priceLabel.textAlignment=NSTextAlignmentCenter;
        _priceLabel.textColor=RGBACOLOR(255, 97, 0, 1);
//        _priceLabel.backgroundColor=[UIColor redColor];
        _priceLabel.font=[UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:_priceLabel];
        
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 69, WIDTH, 1)];
        lineLabel.backgroundColor=BGMAINCOLOR;
        [self.contentView addSubview:lineLabel];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
