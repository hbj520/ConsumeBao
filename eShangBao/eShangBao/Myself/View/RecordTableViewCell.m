//
//  RecordTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/1/19.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "RecordTableViewCell.h"

@implementation RecordTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headImg=[[UIImageView alloc]initWithFrame:CGRectMake(W(12), H(10), W(30), H(30))];
        _headImg.contentMode=2;
        [self.contentView addSubview:_headImg];
        
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_headImg)+W(5), H(5), W(200), H(20))];
        _titleLabel.text=@"徽府披云";
        _titleLabel.font=[UIFont systemFontOfSize:12];
        _titleLabel.textColor=RGBACOLOR(83, 83, 83, 1);
        [self.contentView addSubview:_titleLabel];
        
        _detailLabel1=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_headImg)+W(5), kDown(_titleLabel), W(200), H(20))];
        _detailLabel1.text=@"星期二上午10:20";
        _detailLabel1.textColor=RGBACOLOR(89, 89, 89, 1);
        _detailLabel1.font=[UIFont systemFontOfSize:8];
        [self.contentView addSubview:_detailLabel1];
        
        _moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_detailLabel1), H(10), W(80), H(30))];
        _moneyLabel.text=@"+25.00";
        _moneyLabel.textColor=RGBACOLOR(89, 89, 89, 1);
        _moneyLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:_moneyLabel];
        
        UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(49), WIDTH, H(1))];
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
