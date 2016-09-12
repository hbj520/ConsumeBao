//
//  SJXQCommentTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/6/30.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "SJXQCommentTableViewCell.h"

@implementation SJXQCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 1, WIDTH, 1)];
        lineLabel.backgroundColor=BGMAINCOLOR;
        [self.contentView addSubview:lineLabel];
        
        _headImg=[[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 35, 35)];
        _headImg.backgroundColor=[UIColor redColor];
        _headImg.image=[UIImage imageNamed:@"头像.png"];
        [self.contentView addSubview:_headImg];
        
        _phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_headImg)+5, 8, 100, 20)];
        _phoneLabel.text=@"1309****116";
        _phoneLabel.font=[UIFont systemFontOfSize:14];
        _phoneLabel.textColor=MAINCHARACTERCOLOR;
        [self.contentView addSubview:_phoneLabel];
        
        _dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH-100-12, 10, 100, 20)];
        _dateLabel.textColor=RGBACOLOR(136, 136, 136, 1);
        _dateLabel.font=[UIFont systemFontOfSize:12];
        _dateLabel.textAlignment=NSTextAlignmentRight;
        _dateLabel.text=@"2016-04-03";
        [self.contentView addSubview:_dateLabel];
        
        _scoreImg=[[UIImageView alloc]initWithFrame:CGRectMake(kRight(_headImg)+5, kDown(_phoneLabel), 65, 10)];
        _scoreImg.image=[UIImage imageNamed:@"4_05副本"];
        [self.contentView addSubview:_scoreImg];
        
        _commentLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_headImg)+5, kDown(_scoreImg), WIDTH-12*2-5-35, 50)];
        _commentLabel.text=@"和气温服务和分流清河日护工费俩号圣诞快乐宏发科技和速度快了解放和利润恢复IQherwi哗哗的发挥安徽的返回";
        _commentLabel.numberOfLines=0;
        _commentLabel.textColor=MAINCHARACTERCOLOR;
        _commentLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:_commentLabel];
    }
    
    return self;
}

-(void)setCommentLabel:(UILabel *)commentLabel
{
    

    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
