//
//  CollectTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/1/18.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "CollectTableViewCell.h"
#import <CoreText/CoreText.h>
@implementation CollectTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImg=[[UIImageView alloc]initWithFrame:CGRectMake(W(12), H(10), W(60), H(60))];
        _headImg.backgroundColor=[UIColor cyanColor];
        [self.contentView addSubview:_headImg];
        
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_headImg)+W(10), H(15), W(160), H(20))];
//        _titleLabel.backgroundColor=[UIColor redColor];
        _titleLabel.text=@"仟吉旗舰店";
        _titleLabel.font=[UIFont systemFontOfSize:16];
        _titleLabel.textColor=RGBACOLOR(111, 111, 111, 1);
        [self.contentView addSubview:_titleLabel];
        
        _backLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_headImg)+W(10), kDown(_titleLabel)+H(10), W(160), H(20))];
//        _backLabel.text=@"返还10%金币";
         _backLabel.textColor=RGBACOLOR(111, 111, 111, 1);
        NSMutableAttributedString *attributeString=[[NSMutableAttributedString alloc]initWithString:@"返还10%金币"];
        [attributeString addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(247, 137, 0, 1) range:NSMakeRange(2,3)];
//        [attributeString setAttributes:@{NSForegroundColorAttributeName:RGBACOLOR(247, 137, 0, 1), NSLinkAttributeName:[NSURL URLWithString:@"http://www.baidu.com"] } range:NSMakeRange(2, 3)];
        //        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:247/255.0 green:137/255.0 blue:0 alpha:1] range:NSMakeRange(5, [NSString stringWithFormat:@"%@",model.DeliveryFee].length+1)];
        _backLabel.attributedText=attributeString;
        _backLabel.font=[UIFont systemFontOfSize:14];
//        _backLabel.textColor=RGBACOLOR(111, 111, 111, 1);
        [self.contentView addSubview:_backLabel];
        
        _starBtn=[UIButton buttonWithType:0];
//        _starBtn.backgroundColor=[UIColor cyanColor];
        _starBtn.frame=CGRectMake(kRight(_titleLabel)+W(30), H(20), W(30), H(30));
        [_starBtn setImage:[UIImage imageNamed:@"收藏店铺_12_03"] forState:0];
        [self.contentView addSubview:_starBtn];
        
        _simmilorBtn=[UIButton buttonWithType:0];
        _simmilorBtn.frame=CGRectMake(kRight(_titleLabel)-W(5), kDown(_starBtn)+H(5), W(60), H(20));
        _simmilorBtn.layer.borderWidth=1;
        _simmilorBtn.layer.borderColor=[UIColor redColor].CGColor;
        [_simmilorBtn setTitle:@"找相似" forState:0];
        [_simmilorBtn setTitleColor:RGBACOLOR(111, 111, 111, 1) forState:0];
        _simmilorBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [self.contentView addSubview:_simmilorBtn];
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
