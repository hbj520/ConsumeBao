//
//  MarkTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/1/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "MarkTableViewCell.h"

@implementation MarkTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(W(15), H(10), W(50), H(22))];
        label.text=@"总体评分";
        label.font=[UIFont systemFontOfSize:12];
        label.textColor=MAINCHARACTERCOLOR;
        [self.contentView addSubview:label];
        
        _commendLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(label), H(10), W(36), H(22))];
        _commendLabel.textColor=RGBACOLOR(255, 97, 0, 1);
        _commendLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:_commendLabel];
        
        UILabel * label1=[[UILabel alloc]initWithFrame:CGRectMake(W(120), H(10), W(50), H(22))];
        label1.textColor=MAINCHARACTERCOLOR;
        label1.font=[UIFont systemFontOfSize:12];
        label1.text=@"商品质量";
        [self.contentView addSubview:label1];
        
        _massLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(label1), H(10), W(36), H(22))];
        _massLabel.textColor=RGBACOLOR(255, 97, 0, 1);
        _massLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:_massLabel];
        
        UILabel * label2=[[UILabel alloc]initWithFrame:CGRectMake(W(230), H(10), W(50), H(22))];
        label2.textColor=MAINCHARACTERCOLOR;
        label2.font=[UIFont systemFontOfSize:12];
        label2.text=@"配送服务";
        [self.contentView addSubview:label2];
        
        _sendLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(label2), H(10), W(36), H(22))];
        _sendLabel.textColor=RGBACOLOR(255, 97, 0, 1);
        _sendLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:_sendLabel];
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
