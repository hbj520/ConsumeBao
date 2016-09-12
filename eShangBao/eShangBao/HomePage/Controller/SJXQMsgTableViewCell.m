
//
//  SJXQMsgTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/6/30.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "SJXQMsgTableViewCell.h"

@implementation SJXQMsgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor=[UIColor redColor];
        
        _headImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 240)];
        _headImg.backgroundColor=[UIColor redColor];
        _headImg.image=[UIImage imageNamed:@"fuzzyImage"];
        [self.contentView addSubview:_headImg];
        
        _storeNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(_headImg)+10, WIDTH, 20)];
        _storeNameLabel.text=@"上岛咖啡（中环城店）";
        _storeNameLabel.textColor=MAINCHARACTERCOLOR;
        _storeNameLabel.textAlignment=NSTextAlignmentCenter;
        _storeNameLabel.font=[UIFont boldSystemFontOfSize:18];
        [self.contentView addSubview:_storeNameLabel];
        
        _scoreImg=[[UIImageView alloc]init];
        _scoreImg.bounds=CGRectMake(0, 0, 120, 15);
        _scoreImg.center=CGPointMake(WIDTH/2-15, kDown(_storeNameLabel)+15);
        _scoreImg.image=[UIImage imageNamed:@"4_05副本"];
        [self.contentView addSubview:_scoreImg];
        
        _scoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_scoreImg)+10, kDown(_storeNameLabel)+5+2, 40, 20)];
        _scoreLabel.textColor=MAINCOLOR;
        _scoreLabel.font=[UIFont systemFontOfSize:14];
        _scoreLabel.text=@"4.0";
        [self.contentView addSubview:_scoreLabel];
        
        _typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(_scoreLabel)+8, WIDTH, 20)];
        _typeLabel.text=@"快餐";
        _typeLabel.textColor=RGBACOLOR(158, 158, 158, 1);
        _typeLabel.textAlignment=NSTextAlignmentCenter;
        _typeLabel.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:_typeLabel];
        
        
        
        _addressLabel=[[UILabel alloc]init];
        _addressLabel.textAlignment=NSTextAlignmentCenter;
        _addressLabel.textColor=MAINCHARACTERCOLOR;
        _addressLabel.text=@"合肥中环城2楼1207号";
        _addressLabel.numberOfLines=0;
        _addressLabel.font=[UIFont systemFontOfSize:18];
        [self.contentView addSubview:_addressLabel];
        
        _locationBtn=[UIButton buttonWithType:0];
        [_locationBtn setImage:[UIImage imageNamed:@"bussiness_address_icon"] forState:0];
        [self.contentView addSubview:_locationBtn];
        
        _dailBtn=[UIButton buttonWithType:0];
        
        [_dailBtn setImage:[UIImage imageNamed:@"bussiness_phone_icon"] forState:0];
        [self.contentView addSubview:_dailBtn];
        
    }
    
    
    return self;
}

-(void)setInfoModel:(SellerInfoModel *)infoModel
{
    
    [_headImg setImageWithURLString:infoModel.doorImg placeholderImage:DEFAULTADVERTISING];
    _headImg.contentMode=UIViewContentModeScaleAspectFill;
    _headImg.layer.masksToBounds=YES;
    
    if (infoModel.branchName.length==0&&infoModel.shopName.length!=0) {
        _storeNameLabel.text=infoModel.shopName;
    }
    if (infoModel.branchName.length!=0&&infoModel.shopName.length!=0) {
        _storeNameLabel.text=[NSString stringWithFormat:@"%@(%@)",infoModel.shopName,infoModel.branchName];
    }
    if (infoModel.branchName.length!=0&&infoModel.shopName.length==0) {
        _storeNameLabel.text=infoModel.branchName;
    }
    if (infoModel.branchName.length==0&&infoModel.shopName.length==0) {
        _storeNameLabel.text=@"";
    }

//    _storeNameLabel.text=[NSString stringWithFormat:@"%@(%@)",infoModel.shopName,infoModel.branchName];
    
    _typeLabel.text=infoModel.categoryName;
    
    _scoreLabel.text=[NSString stringWithFormat:@"%.f",[infoModel.totalScore floatValue]];
    
    int starNum=[infoModel.totalScore intValue];
    if (starNum>5) {
        
        _scoreImg.image=[UIImage imageNamed:[NSString stringWithFormat:@"5_05"]];
        starNum=5;
        
    }else{
        
        _scoreImg.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d_05",starNum]];
    }
    _scoreLabel.text=[NSString stringWithFormat:@"%d",starNum];
    //_scoreImg.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d_05",starNum]];
    
    float addressH=[NSString calculatemySizeWithFont:18. Text:infoModel.shopAddr width:KScreenWidth-16];
    _addressLabel.frame=CGRectMake(8, kDown(_typeLabel)+8, WIDTH-16, addressH);
    _addressLabel.text=infoModel.shopAddr;
    
    _locationBtn.bounds=CGRectMake(0, 0, 40, 40);
    _locationBtn.center=CGPointMake(WIDTH/2.-35, kDown(_addressLabel)+30);
    _dailBtn.frame=CGRectMake(kRight(_locationBtn)+30, kDown(_addressLabel)+10, 40, 40);
    
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
