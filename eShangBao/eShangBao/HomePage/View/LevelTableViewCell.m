//
//  LevelTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/2/17.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "LevelTableViewCell.h"

@implementation LevelTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(5), W(300), H(20))];
        _titleLabel.textColor=RGBACOLOR(255, 97, 0, 1);
        _titleLabel.text=@"22";
        [self.contentView addSubview:_titleLabel];
        
        _detailTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(_titleLabel), W(200), H(20))];
        _detailTitleLabel.textColor=MAINCHARACTERCOLOR;
        _detailTitleLabel.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_detailTitleLabel];

//        _chooseBtn=[UIButton buttonWithType:0];
//        _chooseBtn.frame=CGRectMake(kRight(_detailTitleLabel)+W(100), H(50)*2, W(40), H(40));
//        _chooseBtn.backgroundColor=[UIColor cyanColor];
////        [_chooseBtn setImage:[UIImage imageNamed:@"yx_clk"] forState:0];
//        [self.contentView addSubview:_chooseBtn];
        
        _chooseBtn=[UIButton buttonWithType:0];
        _chooseBtn.frame=CGRectMake(kRight(_detailTitleLabel)+W(60), H(10), W(40), H(40));;
        [_chooseBtn setImage:[UIImage imageNamed:@"3-(2)选择_03"] forState:0];
        [self.contentView addSubview:_chooseBtn];
        
        _levelLabel=[[UILabel alloc]init];
        [self.contentView addSubview:_levelLabel];
        
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(49), WIDTH, H(1))];
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
