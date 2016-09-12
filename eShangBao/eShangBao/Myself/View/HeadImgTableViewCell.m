
//
//  HeadImgTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/1/19.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "HeadImgTableViewCell.h"

@implementation HeadImgTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(14), H(15), W(40), H(25))];
        _titleLabel.text=@"头像";
        _titleLabel.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_titleLabel];
        
        _headImg=[[UIImageView alloc]initWithFrame:CGRectMake(kRight(_titleLabel)+W(210), H(10), W(35), H(35))];
//        _headImg.image=[UIImage imageNamed:@"fir_nam"];
        _headImg.layer.cornerRadius=3;
        _headImg.layer.masksToBounds=YES;
        _headImg.contentMode=2;
        [self.contentView addSubview:_headImg];
        
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(54), WIDTH, H(1))];
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
