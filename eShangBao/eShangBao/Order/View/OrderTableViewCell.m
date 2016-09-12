
//
//  OrderTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/1/25.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=BGMAINCOLOR;
        UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, H(135))];
        coverView.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:coverView];
        
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(10), W(200), H(20))];
        _titleLabel.text=@"张正麻辣串（天天特价）";
        _titleLabel.font=[UIFont systemFontOfSize:14];
        _titleLabel.textColor=RGBACOLOR(63, 62, 62, 1);
        [self.contentView addSubview:_titleLabel];
        
        UIImageView * gotoImg=[[UIImageView alloc]initWithFrame:CGRectMake(kRight(_titleLabel), H(12), W(10), H(16))];
        gotoImg.image=[UIImage imageNamed:@"icon1_15"];
        [self.contentView addSubview:gotoImg];
        
        _gotoBtn=[UIButton buttonWithType:0];
        _gotoBtn.frame=CGRectMake(0, 0, W(200), H(40));
//        _gotoBtn.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:_gotoBtn];
        
        UIButton * button=[UIButton buttonWithType:0];
        button.frame=CGRectMake(W(200), 0, W(120), H(40));
        [self.contentView addSubview:button];
        
        _stateLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(245), H(10), H(75), H(20))];
        _stateLabel.textColor=RGBACOLOR(200, 200, 200, 1);
        _stateLabel.font=[UIFont systemFontOfSize:14];
        _stateLabel.text=@"待评价";
        [self.contentView addSubview:_stateLabel];
        
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(_titleLabel)+H(10), WIDTH, H(1))];
        lineLabel.backgroundColor=BGMAINCOLOR;
        [self.contentView addSubview:lineLabel];
        
        _headImg=[[UIImageView alloc]initWithFrame:CGRectMake(W(12), kDown(lineLabel)+H(10), W(80), H(80))];
        _headImg.image=[UIImage imageNamed:@"goods_1"];
        _headImg.contentMode=2;
        _headImg.layer.masksToBounds=YES;
        [self.contentView addSubview:_headImg];
        
        _moneyLabel=[[UILabel alloc]init];
        _moneyLabel.text=@"￥29.50";
//        _moneyLabel.backgroundColor=[UIColor redColor];
        _moneyLabel.font=[UIFont systemFontOfSize:14];
       
        _moneyLabel.textColor=RGBACOLOR(255, 97, 0, 1);
        [self.contentView addSubview:_moneyLabel];
        
        _tongbaibiLabel=[[UILabel alloc]init];
//        _tongbaibiLabel.backgroundColor=[UIColor redColor];
        _tongbaibiLabel.textColor=RGBACOLOR(255, 97, 0, 1);
        _tongbaibiLabel.numberOfLines=2;
        _tongbaibiLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:_tongbaibiLabel];
        
        _dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_headImg)+W(13), H(10)*2+H(20)*3+H(10)*2, W(100), H(20))];
        _dateLabel.text=@"2015-12-18 12:12";
        _dateLabel.font=[UIFont systemFontOfSize:12];
        _dateLabel.textColor=RGBACOLOR(112, 111, 110, 1);
        [self.contentView addSubview:_dateLabel];
        
        _commentBtn=[UIButton buttonWithType:0];
        _commentBtn.frame=CGRectMake(W(240), kDown(_stateLabel)+H(20), W(65), H(25));
        _commentBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
        _commentBtn.layer.cornerRadius=3;
        _commentBtn.layer.masksToBounds=YES;
        _commentBtn.userInteractionEnabled=NO;
        _commentBtn.backgroundColor=BGMAINCOLOR;
        [_commentBtn setTitle:@"评价订单" forState:0];
        [_commentBtn setTitleColor:[UIColor whiteColor] forState:0];
        _commentBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        _commentBtn.hidden=YES;
        [self.contentView addSubview:_commentBtn];
        
        _payOrderBtn=[UIButton buttonWithType:0];
        _payOrderBtn.frame=CGRectMake(W(240), kDown(_stateLabel)+H(20), W(65), H(25));
        _payOrderBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
        _payOrderBtn.layer.cornerRadius=3;
        _payOrderBtn.layer.masksToBounds=YES;
        [_payOrderBtn setTitle:@"去支付" forState:0];
        [_payOrderBtn setTitleColor:[UIColor whiteColor] forState:0];
        _payOrderBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        _payOrderBtn.hidden=YES;
        [self.contentView addSubview:_payOrderBtn];
        
        _cancelBtn=[UIButton buttonWithType:0];
        _cancelBtn.frame=CGRectMake(W(240), kDown(_stateLabel)+H(60), W(65), H(25));
        _cancelBtn.backgroundColor=RGBACOLOR(160, 160, 160, 1);
        _cancelBtn.layer.cornerRadius=3;
        _cancelBtn.layer.masksToBounds=YES;
//        _cancelBtn.userInteractionEnabled=NO;
//        [_cancelBtn addTarget:self action:@selector(cancelOrder) forControlEvents:1<<6];
        //        _cancelBtn.backgroundColor=BGMAINCOLOR;
        [_cancelBtn setTitle:@"取消订单" forState:0];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:0];
        _cancelBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        _cancelBtn.hidden=YES;
        [self.contentView addSubview:_cancelBtn];
    }
    return self;
}

-(void)setOrderInfo:(OrderInfoModel *)orderInfo
{
    if ([orderInfo.orderType intValue]==2) {
        _headImg.image=[UIImage imageNamed:@"Partner_default"];
    }
    else
    {
        [_headImg setImageWithURLString:orderInfo.doorImg placeholderImage:DEFAULTIMAGE];
    }
    
    if ([orderInfo.orderType intValue]==2) {
        _titleLabel.text=@"合伙人商品";
    }
    else
    {
        _titleLabel.text=(orderInfo.branchName.length==0)?orderInfo.shopName:[NSString stringWithFormat:@"%@(%@)",orderInfo.shopName,orderInfo.branchName];
    }
   
    _moneyLabel.text=[NSString stringWithFormat:@"¥%.2f",[orderInfo.price floatValue]];
    CGSize size =  [self sizeWithStrings:_moneyLabel.text font:_moneyLabel.font];
    _moneyLabel.frame=CGRectMake(kRight(_headImg)+H(10), H(10)*2+H(20)+H(20), size.width, size.height);
    _tongbaibiLabel.hidden=NO;
    if ([orderInfo.goldNum isEqualToString:@"0.0"]) {
        _tongbaibiLabel.hidden=YES;
    }
    else
    {
        _tongbaibiLabel.text=[NSString stringWithFormat:@"通宝币付款：%@",orderInfo.goldNum];
    }
    _tongbaibiLabel.frame=CGRectMake(kRight(_headImg)+H(10), H(10)*2+H(20)+H(20)+H(20), W(130), H(20));
//    _dateLabel.text=[NSString stringWithFormat:@"%@",orderInfo.createDate];
    _dateLabel.text=[NSString showTimeFormat:orderInfo.createDate Format:@"MM-dd HH:mm:ss"];
    //_dateLabel.text=[NSString showTimeFormat:orderInfo.createDate];
    _commentBtn.userInteractionEnabled=NO;
    _commentBtn.backgroundColor=BGMAINCOLOR;
    _commentBtn.hidden=NO;
    _payOrderBtn.hidden=YES;
    _cancelBtn.hidden=YES;
    _orderID=orderInfo.orderId;
//0未付款，1:已付款 2:商家已确认 3:商家拒接 4:已发货 5:已收货 6:买家取消
    switch ([orderInfo.status intValue]) {
        case 0:
        {
            _stateLabel.text=@"未付款";
            _commentBtn.hidden=YES;
            _payOrderBtn.hidden=NO;
            _cancelBtn.hidden=NO;
            
        }
            break;
        case 1:
        {
            _stateLabel.text=@"已付款";
            _commentBtn.hidden=YES;
             _cancelBtn.hidden=YES;
        }
            break;

        case 2:
        {
            _stateLabel.text=@"商家已确定";
            _commentBtn.hidden=YES;
            _cancelBtn.hidden=YES;
        }
            break;

        case 3:
        {
            _stateLabel.text=@"商家拒接";
            _commentBtn.hidden=YES;
            _cancelBtn.hidden=YES;
        }
            break;

        case 4:
        {
            _stateLabel.text=@"已发货";
            _commentBtn.userInteractionEnabled=YES;
            _commentBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
            [_commentBtn setTitle:@"确认收货" forState:0];
            _cancelBtn.hidden=YES;
        }
            break;

        case 5:
        {
            _cancelBtn.hidden=YES;
            if ([orderInfo.isComment intValue]==0) {
                _stateLabel.text=@"未评价";

                _commentBtn.userInteractionEnabled=YES;
                [_commentBtn setTitle:@"评价订单" forState:0];
                _commentBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
                
            }else{
                _stateLabel.text=@"订单完成";
                _commentBtn.hidden=YES;
            }
            
        }
            break;
        case 6:
        {
            _cancelBtn.hidden=YES;
            _stateLabel.text=@"已取消";
            _commentBtn.hidden=YES;
        }
            break;
            
        default:
            break;
    }

    
}

-(void)cancelOrder
{
    DMLog(@"取消订单");
    DMLog(@"----%@",_orderID);
//    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否取消该订单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
        {
            DMLog(@"----%@",_orderID);
//            NSDictionary * param=@{@"orderId":_orderID,@"status":@"6"};
//            [RequstEngine requestHttp:@"1019" paramDic:param blockObject:^(NSDictionary *dic) {
//                DMLog(@"1019----%@",dic);
//                DMLog(@"error-----%@",dic[@"errorMsg"]);
//            }];
        }
            break;
        default:
            break;
    }
}

- (CGSize)sizeWithStrings:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(WIDTH-24, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
