
//
//  BillTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/1/29.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "BillTableViewCell.h"

@implementation BillTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIFont *fontName = [UIFont systemFontOfSize:12.0f];
        //定义字体大小
        CGSize sizeName = [@"11月12日10：20" sizeWithFont:fontName constrainedToSize:CGSizeMake(80.0f,MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        //orderFood.food_name为字符串，即UILabel要显示的内容；fontName 字体大小；CGSizeMake(130.0f,MAXFLOAT) UILabel显示内容的宽度130.0f，MAXFLOAT为显示内容所允许的最大高度，最终得到的sizeName，其width,heightwei值为显示内容所需显示的实际宽度与高度；UILineBreakModeWordWrap以单词为单位换行，以单词为单位截断。
        //定义显示内容的UILabel，宽度为130，高度为经过sizeName.height。
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(W(12), H(5), sizeName.width, sizeName.height)];
        [_timeLabel setText:@"11月12日10：20"];
        [_timeLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_timeLabel setNumberOfLines:0];
        _timeLabel.textColor=GRAYCOLOR;
        //注意这里UILabel的numberoflines(即最大行数限制)设置成0，即不做行数限制。
        [_timeLabel setLineBreakMode:UILineBreakModeWordWrap];
        //将UILabel加入到tvCell 的View中显示。  
        [self.contentView addSubview:_timeLabel];
        
        _storeLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(135), H(5), W(60), H(12))];
        _storeLabel.text=@"徽府披云";
        _storeLabel.textColor=MAINCHARACTERCOLOR;
        _storeLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:_storeLabel];
        
        _countLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(100), kDown(_storeLabel)+H(5), W(100), H(12))];
        _countLabel.text=@"-￥325";
        _countLabel.textAlignment=NSTextAlignmentCenter;
        _countLabel.textColor=RGBACOLOR(255, 97, 0, 1);
        _countLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:_countLabel];
        
        UILabel * yueLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(240), H(5), W(60), H(12))];
        yueLabel.textColor=MAINCHARACTERCOLOR;
        yueLabel.text=@"账户余额";
        yueLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:yueLabel];
        
        _balanceLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(210), kDown(yueLabel)+H(5), W(100), H(12))];
        _balanceLabel.text=@"￥2000";
        _balanceLabel.textAlignment=NSTextAlignmentCenter;
        _balanceLabel.textColor=RGBACOLOR(255, 97, 0, 1);
        _balanceLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:_balanceLabel];
        
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
