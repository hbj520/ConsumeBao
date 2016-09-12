//
//  CategoryCollectionViewCell.m
//  eShangBao
//
//  Created by doumee on 16/4/6.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "CategoryCollectionViewCell.h"

@implementation CategoryCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(5), WIDTH/4-20, H(20))];
        _titleLabel.textColor=MAINCHARACTERCOLOR;
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        _titleLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:_titleLabel];
        
    }
    return self;
}

@end
