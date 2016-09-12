//
//  RecommendCollectionViewCell.m
//  eShangBao
//
//  Created by doumee on 16/1/14.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "RecommendCollectionViewCell.h"

@implementation RecommendCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        _recommendImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, W(150), H(100))];
//        _recommendImg.image=[UIImage imageNamed:@"sj01"];
//        _recommendImg.layer.masksToBounds=YES;
//        _recommendImg.layer.cornerRadius=3;
        _recommendImg.contentMode=3;
        [self.contentView addSubview:_recommendImg];
        
        _backView=[[UIView alloc]initWithFrame:CGRectMake(0, H(80), W(150), H(20))];
        _backView.backgroundColor=[UIColor blackColor];
        _backView.alpha=0.4;
        [self.contentView addSubview:_backView];
        
        _recommendLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(80), W(150), H(20))];
        _recommendLabel.text=@"肥西老乡鸡";
        _recommendLabel.textAlignment=NSTextAlignmentCenter;
        _recommendLabel.textColor=[UIColor whiteColor];
        _recommendLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:_recommendLabel];
    }
    
    return self;
}
@end
