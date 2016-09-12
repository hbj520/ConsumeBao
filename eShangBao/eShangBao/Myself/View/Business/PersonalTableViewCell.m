

//
//  PersonalTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/3/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "PersonalTableViewCell.h"

@implementation PersonalTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, H(100))];
        view.backgroundColor=BGMAINCOLOR;
        [self.contentView addSubview:view];
        
        UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, H(90))];
        coverView.backgroundColor=[UIColor whiteColor];
        [view addSubview:coverView];
        
        UIImageView * headImg=[[UIImageView alloc]initWithFrame:CGRectMake(W(12), H(10), W(70), H(70))];
        headImg.contentMode=2;
        headImg.layer.masksToBounds=YES;
        headImg.layer.cornerRadius=3;
//        if (_type==0) {
        [headImg setImageWithURLString:_myImgUrl placeholderImage:@"头像"];
//        }
//        else
//        {
//            [headImg setImageWithURLString:_lastImgUrl placeholderImage:@"头像"];
//        }
        
        //    headImg.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_myImgUrl]]];
        [coverView addSubview:headImg];
        
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(kRight(headImg)+W(10), H(35), WIDTH-W(12)*2-W(10)-W(80), H(20))];
//        if (_type==0) {
        label.text=_myNickName;
//        }
//        else
//        {
//            label.text=_lastUserName;
//        }
        label.font=[UIFont systemFontOfSize:14];
        label.textColor=MAINCHARACTERCOLOR;
        [coverView addSubview:label];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
