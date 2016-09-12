
//
//  PaymentOrderTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/7/1.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "PaymentOrderTableViewCell.h"

@implementation PaymentOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 12, 60, 20)];
        _nameLabel.textColor=MAINCHARACTERCOLOR;
        _nameLabel.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameLabel];
        
        _phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_nameLabel)+10, 12, 200, 20)];
        _phoneLabel.textColor=MAINCHARACTERCOLOR;
        _phoneLabel.text=@"236498739";
        _phoneLabel.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_phoneLabel];
        
        _addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, kDown(_phoneLabel)+10, WIDTH-15-40, 20)];
        _addressLabel.textColor=MAINCHARACTERCOLOR;
        _addressLabel.font=[UIFont systemFontOfSize:14];
        _addressLabel.text=@"aqodlfaoiheroif";
        [self.contentView addSubview:_addressLabel];
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
