

//
//  elseMsgTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/1/16.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "elseMsgTableViewCell.h"

@implementation elseMsgTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 14, 16, 16)];
        _headImg.contentMode=2;
//        _headImg.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:_headImg];
        
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_headImg)+W(10), 12, W(120), 20)];
        _titleLabel.textColor=MAINCHARACTERCOLOR;
        _titleLabel.font=[UIFont systemFontOfSize:14];
//        _titleLabel.backgroundColor=[UIColor cyanColor];
        [self.contentView addSubview:_titleLabel];
        
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 43, WIDTH, 1)];
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
