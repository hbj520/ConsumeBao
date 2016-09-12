//
//  SYQTableViewCell.m
//  eShangBao
//
//  Created by Dev on 16/6/29.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "SYQTableViewCell.h"

@implementation SYQTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.opaque=YES;
        _textView=[[UITextView alloc]init];
        _textView.font=[UIFont systemFontOfSize:12];
        _textView.textColor=GRAYCOLOR;
        _textView.editable=NO;
        _textView.backgroundColor=[UIColor clearColor];
        _textView.contentInset = UIEdgeInsetsZero;
        _textView.scrollIndicatorInsets = UIEdgeInsetsZero;
        _textView.alwaysBounceHorizontal=NO;
        _textView.alwaysBounceVertical=NO;
        [_textView setUserInteractionEnabled:NO];
       // _textView.scrollEnabled=NO;
        [self.contentView addSubview:_textView];
        
    }
    return self;
}
-(void)setContentStr:(NSString *)contentStr
{
    float strH=[NSString calculatemySizeWithFont:12. Text:contentStr width:KScreenWidth-24];
    _textView.frame=CGRectMake(8, 0, KScreenWidth-16, strH+10);
    _textView.text=contentStr;
    
}
-(void)setIsLine:(BOOL)isLine
{
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, KScreenWidth-24, 1)];
    line.backgroundColor=RGBACOLOR(225, 225, 225, 1);
    [self.contentView addSubview:line];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
