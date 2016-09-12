//
//  MyVIPTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/7/23.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "MyVIPTableViewCell.h"

@implementation MyVIPTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headImg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 60, 60)];
        _headImg.layer.cornerRadius=_headImg.frame.size.height/2;
        _headImg.layer.masksToBounds=YES;
        _headImg.backgroundColor=[UIColor cyanColor];
        [self.contentView addSubview:_headImg];
        
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_headImg)+10, 20, WIDTH-15*2-10-60-15, 20)];
        _nameLabel.textColor=MAINCHARACTERCOLOR;
        _nameLabel.font=[UIFont systemFontOfSize:14];
        _nameLabel.text=@"会员名称: 程阳";
        [self.contentView addSubview:_nameLabel];
        
        _dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_headImg)+10, 45+10, WIDTH-15*2-10-60-15, 20)];
        _dateLabel.text=@"锁定时间: 2016-04-10 11:25:23";
        _dateLabel.textColor=GRAYCOLOR;
        _dateLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:_dateLabel];
        
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 89, WIDTH, 1)];
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
