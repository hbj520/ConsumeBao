//
//  NumberTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/1/15.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "NumberTableViewCell.h"

@implementation NumberTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _numberLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), 0, W(90), H(50))];
//        _numberLabel.text=@"名称/编号";
        _numberLabel.textColor=MAINCHARACTERCOLOR;
        [self.contentView addSubview:_numberLabel];
        
        _numberTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(_numberLabel), 0, WIDTH-W(90)-W(13)-W(12), H(50))];
        _numberTF.returnKeyType=UIReturnKeyDone;
        _numberTF.textColor=MAINCHARACTERCOLOR;
        _numberTF.textAlignment=NSTextAlignmentRight;
//        _numberTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入执照编号/名称" attributes:@{NSForegroundColorAttributeName:GRAYCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:28/2*KRatioH]}];
        _numberTF.font=[UIFont systemFontOfSize:14];
        
        [self.contentView addSubview:_numberTF];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
