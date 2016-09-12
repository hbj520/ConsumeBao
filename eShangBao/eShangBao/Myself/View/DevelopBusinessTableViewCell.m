//
//  DevelopBusinessTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/6/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "DevelopBusinessTableViewCell.h"

@implementation DevelopBusinessTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _dataImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 160)];
        _dataImg.contentMode=2;
        _dataImg.layer.masksToBounds=YES;
        _dataImg.layer.cornerRadius=3;
        _dataImg.backgroundColor=RGBACOLOR(220, 220, 220, 1);
        //        _dataImg.image=[UIImage imageNamed:@"zsh01"];
        [self.contentView addSubview:_dataImg];
        
        _dataBtn=[UIButton buttonWithType:0];
        _dataBtn.frame=CGRectMake(0, 0, WIDTH, 160);
        [self.contentView addSubview:_dataBtn];
        
        _coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 160-32, WIDTH, 32)];
        _coverView.backgroundColor=[UIColor blackColor];
        _coverView.alpha=0.5;
        [self.contentView addSubview:_coverView];
        
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 160-32, WIDTH, 32)];
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        _titleLabel.text=@"立即上传店铺头图";
        _titleLabel.font=[UIFont systemFontOfSize:14];
        _titleLabel.textColor=[UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
        
//        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(104), WIDTH, H(1))];
//        lineLabel.backgroundColor=BGMAINCOLOR;
//        [self.contentView addSubview:lineLabel];
        
        
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
