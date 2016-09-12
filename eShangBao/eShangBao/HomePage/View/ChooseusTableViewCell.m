
//
//  ChooseusTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/1/14.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "ChooseusTableViewCell.h"

@implementation ChooseusTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _dataImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, H(150))];
        _dataImg.contentMode=2;
        _dataImg.layer.masksToBounds=YES;
        _dataImg.layer.cornerRadius=3;
        _dataImg.backgroundColor=RGBACOLOR(220, 220, 220, 1);
//        _dataImg.image=[UIImage imageNamed:@"zsh01"];
        [self.contentView addSubview:_dataImg];
        
        _dataButton=[UIButton buttonWithType:0];
        _dataButton.frame=CGRectMake(0, 0, WIDTH, WIDTH);
        [self.contentView addSubview:_dataButton];
        
//        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(149), WIDTH, H(1))];
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
