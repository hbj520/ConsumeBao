//
//  RecommendLevelTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/6/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "RecommendLevelTableViewCell.h"

@implementation RecommendLevelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 14, 16, 16)];
        [self.contentView addSubview:_iconImg];
        
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_iconImg)+10, 12, 300, 20)];
        _titleLabel.textColor=MAINCHARACTERCOLOR;
        _titleLabel.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_titleLabel];
        
        _detailTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH-35-50, 12, 50, 20)];
        _detailTitleLabel.backgroundColor=MAINCOLOR;
        _detailTitleLabel.textAlignment=NSTextAlignmentCenter;
        _detailTitleLabel.textColor=[UIColor whiteColor];
        _detailTitleLabel.font=[UIFont systemFontOfSize:12];
        _detailTitleLabel.layer.cornerRadius=10;
        _detailTitleLabel.layer.masksToBounds=YES;
        [self.contentView addSubview:_detailTitleLabel];
        
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
