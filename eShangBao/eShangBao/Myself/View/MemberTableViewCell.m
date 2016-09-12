//
//  MemberTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/1/29.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "MemberTableViewCell.h"

@implementation MemberTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(10), W(70), H(20))];
//        _titleLabel.text=@"会员级别";
        _titleLabel.textColor=MAINCHARACTERCOLOR;
        _titleLabel.font=[UIFont systemFontOfSize:14];
//        label.font=[UIFont systemFontOfSize:14*KRatioH];
        [self.contentView addSubview:_titleLabel];
        
        _levelLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_titleLabel)+W(60), H(10), W(100), H(20))];
        _levelLabel.textColor=MAINCHARACTERCOLOR;
        _levelLabel.textAlignment=NSTextAlignmentRight;
//        _levelLabel.backgroundColor=[UIColor cyanColor];
        [self.contentView addSubview:_levelLabel];
        
        _improveBtn=[UIButton buttonWithType:0];
        _improveBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
        _improveBtn.layer.cornerRadius=3;
        _improveBtn.layer.masksToBounds=YES;
        _improveBtn.frame=CGRectMake(kRight(_levelLabel)+W(10), H(10), W(40), H(20));
//        [_improveBtn setTitle:@"升级" forState:0];
        [_improveBtn setTitleColor:[UIColor whiteColor] forState:0];
        _improveBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_improveBtn];
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
