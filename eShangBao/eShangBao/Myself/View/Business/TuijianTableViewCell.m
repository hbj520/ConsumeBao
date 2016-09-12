
//
//  TuijianTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/2/17.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "TuijianTableViewCell.h"

@implementation TuijianTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _headImg=[[UIImageView alloc]initWithFrame:CGRectMake(W(12), H(22), W(70), H(70))];
//        _headImg.image=[UIImage imageNamed:@"sj01"];
        _headImg.contentMode=2;
        _headImg.layer.masksToBounds=YES;
        _headImg.layer.cornerRadius=3;
        [self.contentView addSubview:_headImg];
        
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_headImg)+W(10), H(14), W(160), H(14))];
        _nameLabel.text=@"千里香旗舰店（马鞍山路店）";
//        _nameLabel.backgroundColor=[UIColor redColor];
        _nameLabel.font=[UIFont systemFontOfSize:14];
        _nameLabel.textColor=MAINCHARACTERCOLOR;
        [self.contentView addSubview:_nameLabel];
        
        _payMoneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_headImg)+W(10), kDown(_nameLabel)+H(10), W(200), H(14))];
        _payMoneyLabel.textColor=GRAYCOLOR;
//        _payMoneyLabel.text=@"消费金额：￥1542.00";
        _payMoneyLabel.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_payMoneyLabel];
        
        _levelLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_headImg)+W(10), kDown(_payMoneyLabel)+H(10), W(200), H(14))];
        //        _returnCoinLabel.text=@"返币数量：150个";
        _levelLabel.textColor=GRAYCOLOR;
        _levelLabel.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_levelLabel];
        
        _returnCoinLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_headImg)+W(10), kDown(_levelLabel)+H(10), W(200), H(14))];
//        _returnCoinLabel.text=@"返币数量：150个";
        _returnCoinLabel.textColor=GRAYCOLOR;
        _returnCoinLabel.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_returnCoinLabel];
        
        _payStatusLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_nameLabel)+25, H(14), 40, 20)];
//        _payStatusImg.backgroundColor=[UIColor redColor];
        _payStatusLabel.layer.borderWidth=1;
        _payStatusLabel.layer.borderColor=[UIColor redColor].CGColor;
        _payStatusLabel.layer.masksToBounds=YES;
        _payStatusLabel.layer.cornerRadius=8;
        _payStatusLabel.text=@"未支付";
        _payStatusLabel.textAlignment=NSTextAlignmentCenter;
        _payStatusLabel.font=[UIFont systemFontOfSize:10];
        _payStatusLabel.textColor=[UIColor redColor];
        [self.contentView addSubview:_payStatusLabel];
        
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(114), WIDTH, H(1))];
        lineLabel.backgroundColor=BGMAINCOLOR;
        [self.contentView addSubview:lineLabel];

    }
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
