
//
//  VIPTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/1/29.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "VIPTableViewCell.h"

@implementation VIPTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _selectBtn=[UIButton buttonWithType:0];
        _selectBtn.frame=CGRectMake(W(12), H(10), W(20), H(20));
        [_selectBtn setImage:[UIImage imageNamed:@"3-(2)选择_03"] forState:0];
        [self.contentView addSubview:_selectBtn];
        
        _levelLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_selectBtn)+W(10), H(10), W(200), H(20))];
        _levelLabel.textColor=MAINCHARACTERCOLOR;
        _levelLabel.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_levelLabel];
        
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
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
