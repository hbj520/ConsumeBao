//
//  ReturnBateTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/7/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "ReturnBateTableViewCell.h"

@implementation ReturnBateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView * tuibiaoImg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 20, 20)];
        tuibiaoImg.image=[UIImage imageNamed:@"组-1"];
        [self.contentView addSubview:tuibiaoImg];
        
        _returnBateLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(tuibiaoImg)+8, 15, 120, 20)];
        _returnBateLabel.text=@"返币20.0%";
        _returnBateLabel.font=[UIFont boldSystemFontOfSize:16];
        _returnBateLabel.textColor=MAINCHARACTERCOLOR;
        [self.contentView addSubview:_returnBateLabel];
        
//        _orderNumLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH-15-100, 15, 100, 20)];
//        _orderNumLabel.textColor=RGBACOLOR(154, 154, 154, 1);
//        _orderNumLabel.text=@"已领";
//        _orderNumLabel.textAlignment=NSTextAlignmentRight;
//        _orderNumLabel.font=[UIFont systemFontOfSize:14];
//        [self.contentView addSubview:_orderNumLabel];
        
        _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(tuibiaoImg)+8, kDown(_returnBateLabel)+10, 160, 20)];
        _timeLabel.textColor=RGBACOLOR(154, 154, 154, 1);
        _timeLabel.text=@"每天0:00-24:00可用";
        _timeLabel.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_timeLabel];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
