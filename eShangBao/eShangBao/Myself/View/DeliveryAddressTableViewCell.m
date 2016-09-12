//
//  DeliveryAddressTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/1/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "DeliveryAddressTableViewCell.h"

@implementation DeliveryAddressTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
    
}
-(void)managmentBtnHidden
{
    _managmentBtn.hidden=!_managmentBtn.hidden;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managmentBtnHidden) name:@"managementBtn" object:nil];
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(15), H(15), W(60), H(20))];
        _nameLabel.textColor=MAINCHARACTERCOLOR;
        _nameLabel.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameLabel];
        
        _phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_nameLabel), H(15), W(200), H(20))];
        _phoneLabel.textColor=MAINCHARACTERCOLOR;
        _phoneLabel.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_phoneLabel];
        
        _addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(15), kDown(_nameLabel)+H(15), WIDTH-W(15), H(20))];
        _addressLabel.textColor=MAINCHARACTERCOLOR;
        _addressLabel.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_addressLabel];
        
        _managmentBtn=[UIButton buttonWithType:0];
        _managmentBtn.frame=CGRectMake(KScreenWidth-40, 0, 35, H(80)) ;
        _managmentBtn.hidden=YES;
        [_managmentBtn setImage:[UIImage imageNamed:@"managment_addr"] forState:0];
        //_managmentBtn.backgroundColor=[UIColor brownColor];
        
        [self addSubview:_managmentBtn];
        
        
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(79), WIDTH, H(1))];
        lineLabel.backgroundColor=BGMAINCOLOR;
        [self.contentView addSubview:lineLabel];
        
        _addIDLabel=[[UILabel alloc]init];
        [self.contentView addSubview:_addIDLabel];
        
        _longitudeLabel=[[UILabel alloc]init];
        [self.contentView addSubview:_longitudeLabel];
        
        _latitudeLabel=[[UILabel alloc]init];
        [self.contentView addSubview:_latitudeLabel];
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
