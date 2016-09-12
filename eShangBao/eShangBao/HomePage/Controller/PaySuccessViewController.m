//
//  PaySuccessViewController.m
//  eShangBao
//
//  Created by doumee on 16/7/16.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "OrderDataModel.h"
#import "SJXQViewController.h"
#import "LMSJJudgeViewController.h"
@interface PaySuccessViewController ()
{
    OrderInfoModel *infoModel;
}

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"账单详情";
    self.view.backgroundColor=[UIColor whiteColor];
     infoModel=[[OrderInfoModel alloc]init];
    [self backButton];
//    [self loadUI];
    
    [self merchatList];
    // Do any additional setup after loading the view.
}

-(void)merchatList
{
    NSDictionary * param=@{@"orderId":_orderId};
    [RequstEngine requestHttp:@"1020" paramDic:param blockObject:^(NSDictionary *dic) {
        DMLog(@"1020----%@",dic);
        DMLog(@"error-----%@",dic[@"errorMsg"]);
        if ([dic[@"errorCode"] intValue]==0) {
            [infoModel setValuesForKeysWithDictionary:dic[@"goodsOrder"]];
            
//            for (NSDictionary *newDic in infoModel.goodsList) {
            
//                OrderGoodsList *model=[[OrderGoodsList alloc]init];
//                [model setValuesForKeysWithDictionary:newDic];
//                [_chooseGoodsListArr addObject:model];
//            }

            _status=dic[@"goodsOrder"][@"status"];
            [self loadUI];
        }
    }];
}

-(void)loadUI
{
    _shopNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 64+10, WIDTH-15*2, 20)];
    if (infoModel.branchName.length!=0&&infoModel.shopName.length!=0) {
       _shopNameLabel.text=[NSString stringWithFormat:@"     %@(%@) >",infoModel.shopName,infoModel.branchName];
    }
    if (infoModel.branchName.length==0&&infoModel.shopName.length!=0) {
        _shopNameLabel.text=[NSString stringWithFormat:@"     %@ >",infoModel.shopName];
    }
    if (infoModel.branchName.length!=0&&infoModel.shopName.length==0) {
        _shopNameLabel.text=[NSString stringWithFormat:@"     %@ >",infoModel.branchName];
    }
    if (infoModel.branchName.length==0&&infoModel.shopName.length==0) {
        _shopNameLabel.text=@" >";
    }
    _shopNameLabel.textColor=RGBACOLOR(135, 135, 135, 1);
    _shopNameLabel.font=[UIFont systemFontOfSize:14];
    _shopNameLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_shopNameLabel];
    
    UIButton * checkShopBtn=[UIButton buttonWithType:0];
    checkShopBtn.frame=CGRectMake(5, 64+10, WIDTH-15*2, 20);
    [checkShopBtn addTarget:self action:@selector(checkShopMsg) forControlEvents:1<<6];
    [self.view addSubview:checkShopBtn];
    
    UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(_shopNameLabel)+10, WIDTH, 1)];
    lineLabel.backgroundColor=BGMAINCOLOR;
    [self.view addSubview:lineLabel];
    
    _priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(lineLabel)+10, WIDTH, 40)];
    _priceLabel.textAlignment=NSTextAlignmentCenter;
    _priceLabel.textColor=MAINCHARACTERCOLOR;
    _priceLabel.font=[UIFont boldSystemFontOfSize:36];
    _priceLabel.text=[NSString stringWithFormat:@"-%.2f",[infoModel.totalPrice floatValue]];
    [self.view addSubview:_priceLabel];
    
    _otherPayLabel=[[UILabel alloc]init];
    _otherPayLabel.font=[UIFont systemFontOfSize:12];
    
    _otherPayLabel.textColor=RGBACOLOR(135, 135, 135, 1);
    _otherPayLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_otherPayLabel];
    
    _goldNumLabel=[[UILabel alloc]init];
    _goldNumLabel.frame=CGRectMake(15, kDown(_otherPayLabel)+5, WIDTH-15*2, 15);
    _goldNumLabel.font=[UIFont systemFontOfSize:12];
    
    _goldNumLabel.textColor=RGBACOLOR(135, 135, 135, 1);
    _goldNumLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_goldNumLabel];
    
    
    if ([infoModel.goldNum floatValue]==0) {
        _otherPayLabel.frame=CGRectMake(15, kDown(_priceLabel)+5, WIDTH-15*2, 15);
        _goldNumLabel.frame=CGRectMake(15, kDown(_otherPayLabel)+5, WIDTH-15*2, 1);
        _goldNumLabel.text=@"";
        if ([_whichPage intValue]==0) {
            if ([_upOrDown intValue]==21) {
                _otherPayLabel.text=[NSString stringWithFormat:@"线上支付 %.2f",[infoModel.totalPrice floatValue]];
            }
            else
            {
                _otherPayLabel.text=[NSString stringWithFormat:@"支付宝支付 %.2f",[infoModel.totalPrice floatValue]];
            }
            
        }
        if ([_whichPage intValue]==1) {
            _otherPayLabel.text=[NSString stringWithFormat:@"微信支付 %.2f",[infoModel.totalPrice floatValue]];
        }
    }
    else
    {
       
        if ([infoModel.goldNum floatValue]==[infoModel.totalPrice floatValue]) {
            _otherPayLabel.frame=CGRectMake(15, kDown(_priceLabel)+5, WIDTH-15*2, 1);
            _otherPayLabel.text=@"";
            _goldNumLabel.frame=CGRectMake(15, kDown(_otherPayLabel)+5, WIDTH-15*2, 15);
            _goldNumLabel.text=[NSString stringWithFormat:@"通宝币支付 %.2f",[infoModel.goldNum floatValue]];
            
        }
        else
        {
             _otherPayLabel.frame=CGRectMake(15, kDown(_priceLabel)+5, WIDTH-15*2, 15);
            _goldNumLabel.frame=CGRectMake(15, kDown(_otherPayLabel)+5, WIDTH-15*2, 15);
            _goldNumLabel.text=[NSString stringWithFormat:@"通宝币支付 %.2f",[infoModel.goldNum floatValue]];
            if ([_whichPage intValue]==0) {
                if ([_upOrDown intValue]==21) {
                    _otherPayLabel.text=[NSString stringWithFormat:@"线上支付 %.2f",[infoModel.totalPrice floatValue]-[infoModel.goldNum floatValue]];
                }
                else
                {
                    _otherPayLabel.text=[NSString stringWithFormat:@"支付宝支付 %.2f",[infoModel.totalPrice floatValue]-[infoModel.goldNum floatValue]];
                }
                
            }
            if ([_whichPage intValue]==1) {
                _otherPayLabel.text=[NSString stringWithFormat:@"微信支付 %.2f",[infoModel.totalPrice floatValue]-[infoModel.goldNum floatValue]];
            }
        }
    }

    
    _statusLabel=[[UILabel alloc]init];
    _statusLabel.frame=CGRectMake(15, kDown(_goldNumLabel)+10, WIDTH-15*2, 15);
    _statusLabel.font=[UIFont systemFontOfSize:14];
    if ([_status intValue]==5) {
        _statusLabel.text=@"交易完成";
    }
    else if ([_status intValue]==6)
    {
        _statusLabel.text=@"交易已取消";
    }
    else
    {
        _statusLabel.text=@"交易进行中";
    }
    
    _statusLabel.textColor=RGBACOLOR(99, 99, 99, 1);
    _statusLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_statusLabel];
    
    UILabel * line=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(_statusLabel)+5, WIDTH, 1)];
    line.backgroundColor=BGMAINCOLOR;
    [self.view addSubview:line];
    
//    _discountLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH-120-15, kDown(line)+10, 120, 20)];
//    _discountLabel.textAlignment=NSTextAlignmentRight;
//    _discountLabel.textColor=MAINCOLOR;
//    _discountLabel.text=[NSString stringWithFormat:@"+%.2f个币",[infoModel.backGoldNum floatValue]];
//    _discountLabel.font=[UIFont systemFontOfSize:14];
//    [self.view addSubview:_discountLabel];
    
//    UILabel * line1Label=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(_statusLabel)+10, WIDTH, 1)];
//    line1Label.backgroundColor=BGMAINCOLOR;
//    [self.view addSubview:line1Label];
    
    UILabel * msgLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, kDown(line)+10, 65, 20)];
    msgLabel.text=@"商品信息";
    msgLabel.textColor=RGBACOLOR(135, 135, 135, 1);
    msgLabel.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:msgLabel];
    
    _shopNamesLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH-(WIDTH-15*2-65-10)-15, kDown(line)+10, WIDTH-15*2-65-10, 20)];
//    _shopNamesLabel.backgroundColor=[UIColor redColor];
    _shopNamesLabel.textColor=MAINCHARACTERCOLOR;
    _shopNamesLabel.font=[UIFont systemFontOfSize:14];
    _shopNamesLabel.textAlignment=NSTextAlignmentRight;
    if (infoModel.branchName.length!=0&&infoModel.shopName.length!=0) {
        _shopNamesLabel.text=[NSString stringWithFormat:@"%@(%@)",infoModel.shopName,infoModel.branchName];
    }
    if (infoModel.branchName.length==0&&infoModel.shopName.length!=0) {
        _shopNamesLabel.text=[NSString stringWithFormat:@"%@",infoModel.shopName];
    }
    if (infoModel.branchName.length!=0&&infoModel.shopName.length==0) {
        _shopNamesLabel.text=[NSString stringWithFormat:@"%@",infoModel.branchName];
    }
    if (infoModel.branchName.length==0&&infoModel.shopName.length==0) {
        _shopNamesLabel.text=@"";
    }
    [self.view addSubview:_shopNamesLabel];
    
    UILabel * line2Label=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(_shopNamesLabel)+10, WIDTH, 1)];
    line2Label.backgroundColor=BGMAINCOLOR;
    [self.view addSubview:line2Label];
    
    UILabel * label1=[[UILabel alloc]initWithFrame:CGRectMake(15, kDown(line2Label)+10, 65, 20)];
    label1.textColor=RGBACOLOR(135, 135, 135, 1);
    label1.font=[UIFont systemFontOfSize:14];
    label1.text=@"交易单号";
    [self.view addSubview:label1];
    
    _orderNumLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH-(WIDTH-15*2-65-10)-15, kDown(line2Label)+10, WIDTH-15*2-65-10, 20)];
    _orderNumLabel.textAlignment=NSTextAlignmentRight;
    _orderNumLabel.text=[NSString stringWithFormat:@"%@",infoModel.orderId];
    _orderNumLabel.font=[UIFont systemFontOfSize:14];
    _orderNumLabel.textColor=MAINCHARACTERCOLOR;
    [self.view addSubview:_orderNumLabel];
    
    UILabel * label2=[[UILabel alloc]initWithFrame:CGRectMake(15, kDown(label1)+10, 65, 20)];
    label2.textColor=RGBACOLOR(135, 135, 135, 1);
    label2.font=[UIFont systemFontOfSize:14];
    label2.text=@"交易时间";
    [self.view addSubview:label2];
    
     _dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH-(WIDTH-15*2-65-10)-15, kDown(label1)+10, WIDTH-15*2-65-10, 20)];
    _dateLabel.textAlignment=NSTextAlignmentRight;
    _dateLabel.text=[NSString showTimeFormat:infoModel.createDate Format:@"MM-dd HH:mm:ss"];
    _dateLabel.font=[UIFont systemFontOfSize:14];
    _dateLabel.textColor=MAINCHARACTERCOLOR;
    [self.view addSubview:_dateLabel];
    
    UILabel * label3=[[UILabel alloc]initWithFrame:CGRectMake(15, kDown(label2)+10, 65, 20)];
    label3.textColor=RGBACOLOR(135, 135, 135, 1);
    label3.font=[UIFont systemFontOfSize:14];
    label3.text=@"支付方式";
    [self.view addSubview:label3];
    
    _payStyleLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH-(WIDTH-15*2-65-10)-15, kDown(label2)+10, WIDTH-15*2-65-10, 20)];
    _payStyleLabel.textAlignment=NSTextAlignmentRight;
//    if ([_upOrDown intValue]==21) {
//        _payStyleLabel.text=@"线上支付";
//    }
//    else
//    {
//       
//    }
    
//    if ([infoModel.goldNum floatValue]==0) {
//        _payStyleLabel.text=@"微信支付";
//    }
//    else
//    {
//        _payStyleLabel.text=@"微信支付+通宝币支付";
//    }
    
    if ([infoModel.goldNum floatValue]==0) {
        
        if ([_whichPage intValue]==0) {
            if ([_upOrDown intValue]==21) {
                _payStyleLabel.text=@"线上支付";
            }
            else
            {
                _payStyleLabel.text=@"支付宝支付";
            }
            
        }
        if ([_whichPage intValue]==1) {
            _payStyleLabel.text=@"微信支付";
        }
    }
    else
    {
        
        if ([infoModel.goldNum floatValue]==[infoModel.totalPrice floatValue]) {
            _payStyleLabel.text=@"通宝币支付";
            
        }
        else
        {
            //            _otherPayLabel.frame=CGRectMake(15, kDown(_priceLabel)+5, WIDTH-15*2, 15);
            //            _goldNumLabel.frame=CGRectMake(15, kDown(_otherPayLabel)+5, WIDTH-15*2, 15);
            //            _goldNumLabel.text=[NSString stringWithFormat:@"通宝币支付 %.2f",[infoModel.goldNum floatValue]];
            if ([_whichPage intValue]==0) {
                if ([_upOrDown intValue]==21) {
                    _payStyleLabel.text=@"线上支付";
                }
                else
                {
                    _payStyleLabel.text=@"支付宝支付+通宝币支付";
                }
                
            }
            if ([_whichPage intValue]==1) {
                _payStyleLabel.text=@"微信支付+通宝币支付";
            }
        }
    }

    _payStyleLabel.font=[UIFont systemFontOfSize:14];
    _payStyleLabel.textColor=MAINCHARACTERCOLOR;
    [self.view addSubview:_payStyleLabel];
    
    UILabel * line3Label=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(_payStyleLabel)+10, WIDTH, 1)];
    line3Label.backgroundColor=BGMAINCOLOR;
    [self.view addSubview:line3Label];
    
    UIButton * gotoBtn=[UIButton buttonWithType:0];
    if ([_buyOrSeller intValue]==10) {
        gotoBtn.hidden=YES;
    }
    else if([_buyOrSeller intValue]==11)
    {
        gotoBtn.hidden=NO;
    }
    else
    {
        if ([_model.status intValue]==5) {
            if ([_model.isComment intValue]==0) {
                gotoBtn.hidden=NO;
            }
            else
            {
                gotoBtn.hidden=YES;
            }

//
        }
        else
        {
            gotoBtn.hidden=YES;
        }
    }
    gotoBtn.frame=CGRectMake(15, HEIGHT-40-20, WIDTH-15*2, 40);
    gotoBtn.layer.borderColor=BGMAINCOLOR.CGColor;
    gotoBtn.layer.borderWidth=1;
    [gotoBtn setTitle:@"去评价" forState:0];
    [gotoBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
    [gotoBtn addTarget:self action:@selector(gotoComment) forControlEvents:1<<6];
    [self.view addSubview:gotoBtn];

    
}

-(void)checkShopMsg
{
    DMLog(@"查看商家信息");
    SJXQViewController * sjxqVC=[[SJXQViewController alloc]init];
    sjxqVC.shopID=infoModel.shopId;
    [self.navigationController pushViewController:sjxqVC animated:YES];
}

-(void)gotoComment
{
    DMLog(@"去评价");
    LMSJJudgeViewController * lmsjVC=[[LMSJJudgeViewController alloc]init];
    lmsjVC.shopId=infoModel.shopId;
    lmsjVC.price=infoModel.totalPrice;
    lmsjVC.shopName=infoModel.shopName;
    lmsjVC.headImgUrl=infoModel.doorImg;
    lmsjVC.orderId=infoModel.orderId;
    [self.navigationController pushViewController:lmsjVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
