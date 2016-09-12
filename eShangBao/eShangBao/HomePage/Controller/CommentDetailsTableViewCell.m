//
//  CommentDetailsTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/4/6.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "CommentDetailsTableViewCell.h"

@implementation CommentDetailsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headImg=[[UIImageView alloc]initWithFrame:CGRectMake(W(12), H(10), W(40), H(40))];
        _headImg.contentMode=2;
        _headImg.layer.masksToBounds=YES;
//        _headImg.backgroundColor=[UIColor cyanColor];
        [self.contentView addSubview:_headImg];
        
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_headImg)+W(10), H(10), W(200), H(20))];
        _nameLabel.text=@"柠**2015";
        _nameLabel.textColor=MAINCHARACTERCOLOR;
        _nameLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:_nameLabel];
        
        _scoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_headImg)+W(10), kDown(_nameLabel), W(40), H(20))];
        _scoreLabel.text=@"评分：";
        _scoreLabel.textColor=MAINCHARACTERCOLOR;
        _scoreLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:_scoreLabel];
        
        _scoreImg=[[UIImageView alloc]initWithFrame:CGRectMake(kRight(_scoreLabel), kDown(_nameLabel)+3, W(100), H(12))];
//        _scoreImg.backgroundColor=[UIColor cyanColor];
        [self.contentView addSubview:_scoreImg];
        
        _contentLabel=[[UILabel alloc]init];
        _contentLabel.numberOfLines=0;
        _contentLabel.font=[UIFont systemFontOfSize:12];
        _contentLabel.textColor=MAINCHARACTERCOLOR;
        [self.contentView addSubview:_contentLabel];
        
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(_contentLabel), WIDTH, 1)];
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
