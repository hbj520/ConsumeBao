//
//  CollectionViewController.m
//  eShangBao
//
//  Created by doumee on 16/7/2.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "CollectionViewController.h"
#import "WXApi.h"
#import "LoginViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "LMSJJudgeViewController.h"
#import "SetPsdViewController.h"
#import "PaySuccessViewController.h"
@interface CollectionViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    BOOL                    _chooseVouchersPay;
    TBActivityView * activityView;
    
    // 支付所用参数
    
    NSString * useShopId;
    NSString * weixinCoinMount;
    NSString * weixinMount;
    
    NSString * alipayCoinMount;
    NSString * alipayMount;
    NSString * biPwd;
}

@property(nonatomic,strong)UILabel * shopNameLabel;

@property(nonatomic,strong)UILabel * rebateLabel;

@property(nonatomic,strong)UILabel * moneyLabel;

@property(nonatomic,strong)UIButton * weixinBtn;

@property(nonatomic,strong)UIButton * alipayBtn;

@property(nonatomic,strong)UITextField * weixinTF;

@property(nonatomic,strong)UITextField * weixinCoinTF;

@property(nonatomic,strong)UITextField * alipayTF;

@property(nonatomic,strong)UITextField * alipayCoinTF;

@property(nonatomic,strong)UIButton    * ensureBtn;

@property(nonatomic,strong)UIButton    * backBtn;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden=YES;
   // self.navigationController.navigationBarHidden=
    self.view.backgroundColor=BGMAINCOLOR;
    
    [self loadUI];
    
    [self getMsg];
    
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    
    activityView.rectBackgroundColor=MAINCOLOR;
    
    activityView.showVC=self;
    [self.view addSubview:activityView];
    
    [activityView startAnimate];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeStatus) name:@"transferSuccess" object:nil];
    _chooseVouchersPay=YES;
    // Do any additional setup after loading the view.
}




-(void)changeStatus
{
    PaySuccessViewController * payVC=[[PaySuccessViewController alloc]init];
    payVC.orderId=ORDERID;
    payVC.hidesBottomBarWhenPushed=YES;
    payVC.whichPage=@"1";
    payVC.buyOrSeller=@"11";
    payVC.upOrDown=@"22";
    [self.navigationController pushViewController:payVC animated:YES];
    
//    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getMsg
{
    NSDictionary * param=@{@"memberId":USERID};
    [RequstEngine requestHttp:@"1003" paramDic:param blockObject:^(NSDictionary *dic) {
        [activityView stopAnimate];
        DMLog(@"1003-----%@",dic);
        if ([dic[@"errorCode"] intValue]==0) {
            _moneyLabel.text=[NSString stringWithFormat:@"剩余通宝币: %.2f",[dic[@"member"][@"goldNum"] floatValue]];
        }
    }];
}

-(void)loadUI
{
    _backBtn=[UIButton buttonWithType:0];
    _backBtn.frame=CGRectMake(15, 30, W(20), H(20));
    [_backBtn addTarget:self action:@selector(backToLast) forControlEvents:1<<6];
    [_backBtn setImage:[UIImage imageNamed:@"loginBack"] forState:0];
    [self.view addSubview:_backBtn];
    
    _shopNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 70, WIDTH-15*2, 25)];
//    _shopNameLabel.text=@"收款方:好又多超市";
    if ([_whichPage isEqualToString:@"扫描"]) {
        _shopNameLabel.text=[NSString stringWithFormat:@"收款方: %@",_shopName];
    }
    else
    {
        _shopNameLabel.text=[NSString stringWithFormat:@"收款方: %@",_infoModel.shopName];
    }
    
    _shopNameLabel.textAlignment=NSTextAlignmentCenter;
    _shopNameLabel.font=[UIFont boldSystemFontOfSize:20];
    [self.view addSubview:_shopNameLabel];
    
    _rebateLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, kDown(_shopNameLabel)+15, WIDTH-15*2, 20)];
//    _rebateLabel.text=@"活动送比例: 10%";
    if ([_whichPage isEqualToString:@"扫描"]) {
        _rebateLabel.text=[NSString stringWithFormat:@"活动送币比例: %.1f%@",[_returnBate floatValue]*100,@"%"];
    }
    else
    {
        _rebateLabel.text=[NSString stringWithFormat:@"活动送币比例: %.1f%@",[_infoModel.returnGoldRate floatValue]*100,@"%"];
    }
    
    _rebateLabel.textColor=MAINCHARACTERCOLOR;
    _rebateLabel.font=[UIFont systemFontOfSize:14];
    _rebateLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_rebateLabel];
    
    _moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, kDown(_rebateLabel)+10, WIDTH-15*2, 20)];
    _moneyLabel.textAlignment=NSTextAlignmentCenter;
    _moneyLabel.textColor=MAINCHARACTERCOLOR;
//    _moneyLabel.text=@"支付总额: ￥1100.00";
    _moneyLabel.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_moneyLabel];
    
    UIView * coverView =[[UIView alloc]initWithFrame:CGRectMake(0, kDown(_moneyLabel)+30, WIDTH, 180)];
    coverView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:coverView];
    
    
    _weixinBtn=[UIButton buttonWithType:0];
    _weixinBtn.frame=CGRectMake(15, 32, 40, 40);
    [_weixinBtn addTarget:self action:@selector(chooseWeixin) forControlEvents:1<<6];
    [_weixinBtn setImage:[UIImage imageNamed:@"yx_clk"] forState:0];
    [coverView addSubview:_weixinBtn];
    
    UIImageView * weixinImg=[[UIImageView alloc]initWithFrame:CGRectMake(kRight(_weixinBtn)+10, 10, 30, 30)];
    weixinImg.image=[UIImage imageNamed:@"weixinpay_icon"];
    [coverView addSubview:weixinImg];
    
    UILabel * weixinLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(weixinImg)+10, 15, 100, 20)];
    weixinLabel.textColor=MAINCHARACTERCOLOR;
    weixinLabel.text=@"微信支付";
    weixinLabel.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:weixinLabel];

    UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_weixinBtn)+10, 44, WIDTH-15-10-40, 1)];
    lineLabel.backgroundColor=BGMAINCOLOR;
    [coverView addSubview:lineLabel];
    
    _weixinTF=[[UITextField alloc]initWithFrame:CGRectMake(WIDTH-15-100, 10, 100, 24)];
    _weixinTF.layer.borderColor=RGBACOLOR(221, 221, 221, 1).CGColor;
    _weixinTF.layer.borderWidth=1;
    _weixinTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, _weixinTF.frame.size.height)];
    _weixinTF.leftViewMode = UITextFieldViewModeAlways;
    _weixinTF.keyboardType=UIKeyboardTypeDecimalPad;
    _weixinTF.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:_weixinTF];
    
    UIImageView * weixinCoinImg=[[UIImageView alloc]initWithFrame:CGRectMake(kRight(_weixinBtn)+10, 10+kDown(lineLabel), 30, 30)];
    weixinCoinImg.image=[UIImage imageNamed:@"xfb_icon"];
    [coverView addSubview:weixinCoinImg];
    
    UILabel * weixinCoinLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(weixinImg)+10, 15+kDown(lineLabel), 100, 20)];
    weixinCoinLabel.textColor=MAINCHARACTERCOLOR;
    weixinCoinLabel.text=@"通宝币";
    weixinCoinLabel.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:weixinCoinLabel];
    
    UILabel * lineLabel1=[[UILabel alloc]initWithFrame:CGRectMake(0, 44+kDown(lineLabel), WIDTH, 1)];
    lineLabel1.backgroundColor=BGMAINCOLOR;
    [coverView addSubview:lineLabel1];
    
    _weixinCoinTF=[[UITextField alloc]initWithFrame:CGRectMake(WIDTH-15-100, 10+kDown(lineLabel), 100, 24)];
    _weixinCoinTF.layer.borderColor=RGBACOLOR(221, 221, 221, 1).CGColor;
    _weixinCoinTF.layer.borderWidth=1;
    _weixinCoinTF.delegate=self;
    _weixinCoinTF.tag=10;
    _weixinCoinTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, _weixinCoinTF.frame.size.height)];
    _weixinCoinTF.leftViewMode = UITextFieldViewModeAlways;
    _weixinCoinTF.keyboardType=UIKeyboardTypeDecimalPad;
    _weixinCoinTF.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:_weixinCoinTF];
    
    _alipayBtn=[UIButton buttonWithType:0];
//    _alipayBtn.backgroundColor=[UIColor redColor];
    _alipayBtn.frame=CGRectMake(15, 32+kDown(lineLabel1), 40, 40);
    [_alipayBtn addTarget:self action:@selector(chooseAlipay) forControlEvents:1<<6];
    [_alipayBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
    [coverView addSubview:_alipayBtn];
    
    UIImageView * alipayImg=[[UIImageView alloc]initWithFrame:CGRectMake(kRight(_alipayBtn)+10, 10+kDown(lineLabel1), 30, 30)];
    alipayImg.image=[UIImage imageNamed:@"zfbpay_icon"];
    [coverView addSubview:alipayImg];
    
    UILabel * alipayLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(weixinImg)+10, 15+kDown(lineLabel1), 100, 20)];
    alipayLabel.textColor=MAINCHARACTERCOLOR;
    alipayLabel.text=@"支付宝支付";
    alipayLabel.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:alipayLabel];
    
    UILabel * lineLabel2=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_alipayBtn)+10, 44+kDown(lineLabel1), WIDTH-15-10-40, 1)];
    lineLabel2.backgroundColor=BGMAINCOLOR;
    [coverView addSubview:lineLabel2];
    
    _alipayTF=[[UITextField alloc]initWithFrame:CGRectMake(WIDTH-15-100, 10+kDown(lineLabel1), 100, 24)];
    _alipayTF.layer.borderColor=RGBACOLOR(221, 221, 221, 1).CGColor;
    _alipayTF.layer.borderWidth=1;
    _alipayTF.delegate=self;
    _alipayTF.tag=11;
    _alipayTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, _alipayTF.frame.size.height)];
    _alipayTF.leftViewMode = UITextFieldViewModeAlways;
    _alipayTF.keyboardType=UIKeyboardTypeDecimalPad;
    _alipayTF.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:_alipayTF];
    
    UIImageView * alipayCoinImg=[[UIImageView alloc]initWithFrame:CGRectMake(kRight(_weixinBtn)+10, 10+kDown(lineLabel2), 30, 30)];
    alipayCoinImg.image=[UIImage imageNamed:@"xfb_icon"];
    [coverView addSubview:alipayCoinImg];
    
    UILabel * alipayCoinLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(alipayCoinImg)+10, 15+kDown(lineLabel2), 100, 20)];
    alipayCoinLabel.textColor=MAINCHARACTERCOLOR;
    alipayCoinLabel.text=@"通宝币";
    alipayCoinLabel.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:alipayCoinLabel];
    
    _alipayCoinTF=[[UITextField alloc]initWithFrame:CGRectMake(WIDTH-15-100, 10+kDown(lineLabel2), 100, 24)];
    _alipayCoinTF.layer.borderColor=RGBACOLOR(221, 221, 221, 1).CGColor;
    _alipayCoinTF.layer.borderWidth=1;
    _alipayCoinTF.delegate=self;
    _alipayCoinTF.tag=12;
    _alipayCoinTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, _alipayCoinTF.frame.size.height)];
    _alipayCoinTF.leftViewMode = UITextFieldViewModeAlways;
    _alipayCoinTF.keyboardType=UIKeyboardTypeDecimalPad;
    _alipayCoinTF.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:_alipayCoinTF];

    _ensureBtn=[UIButton buttonWithType:0];
    _ensureBtn.frame=CGRectMake(15, kDown(coverView)+20, WIDTH-15*2, 40);
    _ensureBtn.backgroundColor=MAINCOLOR;
    _ensureBtn.layer.cornerRadius=5;
    _ensureBtn.layer.masksToBounds=YES;
    [_ensureBtn addTarget:self action:@selector(ensurePayOrder) forControlEvents:1<<6];
    [_ensureBtn setTitle:@"确认支付" forState:0];
    [_ensureBtn setTitleColor:[UIColor whiteColor] forState:0];
    _ensureBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_ensureBtn];
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==10) {
        [UIView animateWithDuration:0.26 animations:^{
            self.view.frame=CGRectMake(0, -40, WIDTH, HEIGHT);
        }];
    }
    if (textField.tag==11) {
        [UIView animateWithDuration:0.26 animations:^{
            self.view.frame=CGRectMake(0, -80, WIDTH, HEIGHT);
        }];
    }
    if (textField.tag==12) {
        [UIView animateWithDuration:0.26 animations:^{
            self.view.frame=CGRectMake(0, -120, WIDTH, HEIGHT);
        }];
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.26 animations:^{
        self.view.frame=CGRectMake(0, 0, WIDTH, HEIGHT);
    }];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    [self.view endEditing:YES];
    switch (buttonIndex) {
        case 0:
            
            break;
            
        case 1:
        {
            [self.view endEditing:YES];
            biPwd=[alertView textFieldAtIndex:0].text;
            if (alertView.tag==10) {
                // 用通宝币
                if ([weixinMount floatValue]==0) {
                    //全用通宝币
                    [activityView startAnimate];
                    NSDictionary * param=@{@"shopId":useShopId,@"price":weixinMount,@"goldNum":weixinCoinMount,@"payMethod":@"0",@"payPwd":biPwd};
                    [RequstEngine requestHttp:@"1082" paramDic:param blockObject:^(NSDictionary *dic) {
                        DMLog(@"1082--%@",dic);
                        DMLog(@"error---%@",dic[@"errorMsg"]);
                        if ([dic[@"errorCode"] intValue]==00000) {
                            [activityView stopAnimate];
//                            _ensureBtn.enabled=YES;
//                            [UIAlertView alertWithTitle:@"温馨提示" message:@"付款成功" buttonTitle:nil];
                            NSDictionary * param=@{@"orderId":dic[@"orderId"]};
                            
                            [RequstEngine requestHttp:@"1086" paramDic:param blockObject:^(NSDictionary *dics) {
                                DMLog(@"1086---%@",dics);
                                DMLog(@"error---%@",dics[@"errorMsg"]);
                                if ([dics[@"errorCode"] intValue]==00000) {
                                    
                                    PaySuccessViewController * payVC=[[PaySuccessViewController alloc]init];
                                    payVC.orderId=dic[@"orderId"];
                                    payVC.hidesBottomBarWhenPushed=YES;
                                    payVC.whichPage=@"2";
                                    payVC.buyOrSeller=@"11";
                                    payVC.upOrDown=@"22";//线上or线下
                                    [self.navigationController pushViewController:payVC animated:YES];
                                    
                                }
                                else
                                {
                                    [UIAlertView alertWithTitle:@"温馨提示" message:dics[@"errorMsg"] buttonTitle:nil];
                                    
                                    
                                }
                            }];
                            
                        }
                        else if ([dic[@"errorCode"] isEqualToString:@"00018"])
                        {
                            [activityView stopAnimate];
                            [self.view endEditing:YES];
                            UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:dic[@"errorMsg"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
                            alertView.delegate=self;
                            alertView.tag=12;
                            [alertView show];
                        }
                        else
                        {
                            [activityView stopAnimate];
                            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                        }
                        
                        
                    }];
                    
                }
                else
                {
                    //既用通宝币又用微信
                    [activityView startAnimate];
                    NSDictionary * param=@{@"shopId":useShopId,@"price":weixinMount,@"goldNum":weixinCoinMount,@"payMethod":@"0",@"payPwd":biPwd};
                    [RequstEngine requestHttp:@"1082" paramDic:param blockObject:^(NSDictionary *dic) {
                        DMLog(@"1082--%@",dic);
                        DMLog(@"error---%@",dic[@"errorMsg"]);
                        if ([dic[@"errorCode"] intValue]==00000) {
                            
                            [[NSUserDefaults standardUserDefaults] setObject:dic[@"orderId"] forKey:@"orderId"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            NSDictionary * param=@{@"type":@"0",@"orderId":dic[@"orderId"],@"tradeType":@"APP"};
                            [RequstEngine requestHttp:@"1059" paramDic:param blockObject:^(NSDictionary *dic) {
                                DMLog(@"1059---%@",dic);
                                DMLog(@"error---%@",dic[@"errorMsg"]);
                                if ([dic[@"errorCode"] intValue]==00000) {
                                    
                                    //发起微信支付，设置参数
                                    
                                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"type"];
                                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"types"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                    
                                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"page"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                    
                                    [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"which"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                    PayReq *request = [[PayReq alloc] init];
                                    NSString *stamp = dic[@"data"][@"param"][@"timestamp"];
                                    request.openID= dic[@"data"][@"param"][@"appid"];
                                    request.partnerId =dic[@"data"][@"param"][@"partnerid"];
                                    request.prepayId= dic[@"data"][@"param"][@"prepayid"];
                                    request.package = dic[@"data"][@"param"][@"packageStr"];
                                    request.nonceStr= dic[@"data"][@"param"][@"noncestr"];
                                    request.sign=dic[@"data"][@"param"][@"sign"];
                                    request.timeStamp=stamp.intValue;
                                    [activityView stopAnimate];
                                    //            调用微信
                                    [WXApi sendReq:request];
                                    
                                    DMLog(@"partid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",request.partnerId,request.prepayId,request.nonceStr,(long)request.timeStamp,request.package,request.sign );
                                    
                                    
                                }
                               
                                else
                                {
                                    [activityView stopAnimate];
                                    [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                                }
                                
                            }];
                            
                        }
                        else if ([dic[@"errorCode"] isEqualToString:@"00018"])
                        {
                            [activityView stopAnimate];
                            [self.view endEditing:YES];
                            UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:dic[@"errorMsg"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
                            alertView.tag=12;
                            alertView.delegate=self;
                            [alertView show];
                        }

                        else
                        {
                            [activityView stopAnimate];
                            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                        }
                        
                        
                    }];
                    
                }
                

            }
            else if(alertView.tag==11)
            {
                //支付宝
                
                // 全用通宝币支付
                if ([alipayMount floatValue]==0) {
                    NSDictionary * param=@{@"shopId":useShopId,@"price":alipayMount,@"goldNum":alipayCoinMount,@"payMethod":@"1",@"payPwd":biPwd};
                    [RequstEngine requestHttp:@"1082" paramDic:param blockObject:^(NSDictionary *dic) {
                        DMLog(@"1082--%@",dic);
                        DMLog(@"error---%@",dic[@"errorMsg"]);
                        if ([dic[@"errorCode"] intValue]==00000) {
                            [activityView stopAnimate];
                            NSDictionary * param=@{@"orderId":dic[@"orderId"]};
                            [RequstEngine requestHttp:@"1086" paramDic:param blockObject:^(NSDictionary *dics) {
                                DMLog(@"1086---%@",dics);
                                DMLog(@"error---%@",dics[@"errorMsg"]);
                                if ([dics[@"errorCode"] intValue]==00000) {
                                    
                                    PaySuccessViewController * payVC=[[PaySuccessViewController alloc]init];
                                    payVC.orderId=dic[@"orderId"];
                                    payVC.hidesBottomBarWhenPushed=YES;
                                    payVC.whichPage=@"2";
                                    payVC.buyOrSeller=@"11";
                                    payVC.upOrDown=@"22";//线上or线下
                                    [self.navigationController pushViewController:payVC animated:YES];
                                    
                                }
                                else
                                {
                                    [UIAlertView alertWithTitle:@"温馨提示" message:dics[@"errorMsg"] buttonTitle:nil];
                                    
                                    
                                }
                            }];
 
                        }
                        
                        else if ([dic[@"errorCode"] isEqualToString:@"00018"])
                        {
                            [activityView stopAnimate];
                            [self.view endEditing:YES];
                            UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:dic[@"errorMsg"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
                            alertView.tag=12;
                            alertView.delegate=self;
                            [alertView show];
                        }

                        else
                        {
                            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                        }
                        
                        
                    }];
                    
                }
                else
                {
                    // 两者都有
                    NSDictionary * param=@{@"shopId":useShopId,@"price":alipayMount,@"goldNum":alipayCoinMount,@"payMethod":@"1",@"payPwd":biPwd};
                    [RequstEngine requestHttp:@"1082" paramDic:param blockObject:^(NSDictionary *dic) {
                        DMLog(@"1082--%@",dic);
                        DMLog(@"error---%@",dic[@"errorMsg"]);
                        [activityView stopAnimate];
                        if ([dic[@"errorCode"] intValue]==00000) {
                            NSString * orderString=dic[@"param"][@"paramStr"];
                            NSString * appScheme = @"eShangBao";
                            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                                if ([resultDic[@"resultStatus"] intValue]==9000) {
                                    
                                    PaySuccessViewController * payVC=[[PaySuccessViewController alloc]init];
                                    payVC.orderId=dic[@"orderId"];
                                    payVC.hidesBottomBarWhenPushed=YES;
                                    payVC.whichPage=@"2";
                                    payVC.buyOrSeller=@"11";
                                    payVC.upOrDown=@"22";//线上or线下
                                    [self.navigationController pushViewController:payVC animated:YES];
                                }
                                else
                                {
                                    [UIAlertView alertWithTitle:@"温馨提示" message:@"订单支付失败" buttonTitle:nil];
                                }
                                

                            }];
//                            [[NSUserDefaults standardUserDefaults] setObject:dic[@"orderId"] forKey:@"orderId"];
//                            [[NSUserDefaults standardUserDefaults] synchronize];
//                            //                    if ([dic[@"errorCode"] intValue]==00000) {
//                            NSString *partner = @"2088121834499540";
//                            NSString *seller = @"535259521@qq.com";
//                            NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAKNWTgfc/1+1y2t+nMfSqB3KOJ+Waf/XIs4UUTTA6uL/21fJEu1L4bHwiCv7rr7gC0enAkzGpOqW5BeHSvYCiLi3GykGr5LJKp6wPvmK/T8rmu6RC5/jMHY9rOcSF+f/R3ubRnBgRQeheWcILvg6099Y+9YZqiU1cDM5gvPk/5drAgMBAAECgYEAgFucapWDooVM3KbdMjMbpn16Tf94QXOhiG1y+4/3hngmuS/szcpqDNnHSTk6NAoBE0ftiMQ6aZg2mz7Y68dGBRGBd8j4N1wiGq36nCEVIK8NtMeb7QWTS+AtH9of7Gc9bfqonD14kH+KTtzGlaH4fITgvLN4QsrPy4B3BsOEIPECQQDPtMrA97LI4gSW4E17vtfyM88NGBxNKoaSxPReOhXSIN+nvJie7p9b3g6SXcaeE67Ahuh2q83aERXWD6QaE5gtAkEAyVCM7MrzajOXgQWgdaIvklOMpSlsQZHaiO5zFs3VKbZBfAfJEkk5qAW0x78l8DpOnJYLh4LE0OAh2dHRb21U9wJAZQZGZ70SlGp6WPgYN8wHNKLGXlQPz+iTM+fgA8S0wFOE9QziHstpb0F+TOqXpGNmZ/Y2MyI1KY+N02QgKR7GsQJBAK2iikpaqiR5pz0ja0jKwJlG8tIprjPH52Oftyh+FFNL3aNq26Sn/9DKSyjV15Uh1Vf9mqggxD0cdFX5QNkIxfUCQGZ/+x06MH2fyH0kOr9IDxMwylTZRkLDjlvZs3Tv4CZ5RZbaaREcJ8Hmcf+QNTbXtNE9k8nGw/yQlDLmvhkI3fo=";
//                            if ([partner length] == 0 || [seller length] == 0)
//                            {
//                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                                message:@"缺少partner或者seller。"
//                                                                               delegate:self
//                                                                      cancelButtonTitle:@"确定"
//                                                                      otherButtonTitles:nil];
//                                [alert show];
//                                return;
//                            }
//                            
//                            //        NSLog(@"++++***%@,%@",_orderNo,_urlString);
//                            Order *order = [[Order alloc] init];
//                            order.partner = partner;
//                            order.seller = seller;
//                            order.tradeNO = [NSString stringWithFormat:@"PRONO%@",dic[@"orderId"]]; //订单ID(由商家□自□行制定)
//                            order.productName = @"商品支付"; //商品标题
//                            order.productDescription = @"充值"; //商品描述
//                            order.amount =_alipayTF.text;  //商 品价格
//                            order.notifyURL =@"http://120.27.148.135/consumption_interface/AliPayResultDo"; //回调URL
//                            order.service = @"mobile.securitypay.pay";
//                            order.paymentType = @"1";
//                            order.inputCharset = @"utf-8";
//                            order.itBPay = @"30m";
//                            order.showUrl = @"m.alipay.com";
//                            
//                            //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
//                            NSString *appScheme = @"eShangBao";
//                            
//                            //将商品信息拼接成字符串
//                            NSString *orderSpec = [order description];
//                            //    NSLog(@"orderSpec = %@",orderSpec);
//                            
//                            //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//                            id<DataSigner> signer = CreateRSADataSigner(privateKey);
//                            NSString *signedString = [signer signString:orderSpec];
//                            
//                            //将签名成功字符串格式化为订单字符串,请严格按照该格式
//                            NSString *orderString = nil;
//                            if (signedString != nil) {
//                                orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                                               orderSpec, signedString, @"RSA"];
//                                
//                                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//                                    if ([resultDic[@"resultStatus"] intValue]==9000) {
//                                        NSDictionary * param=@{@"orderId":dic[@"orderId"]};
//                                        [RequstEngine requestHttp:@"1086" paramDic:param blockObject:^(NSDictionary *dics) {
//                                            DMLog(@"1086---%@",dics);
//                                            DMLog(@"error---%@",dics[@"errorMsg"]);
//                                            if ([dics[@"errorCode"] intValue]==00000) {
////                                                [UIAlertView alertWithTitle:@"温馨提示" message:@"付款成功" UIViewController:self];
//                                               
//                                                PaySuccessViewController * payVC=[[PaySuccessViewController alloc]init];
//                                                payVC.orderId=dic[@"orderId"];
//                                                payVC.hidesBottomBarWhenPushed=YES;
//                                                payVC.whichPage=@"0";
//                                                payVC.buyOrSeller=@"11";
//                                                payVC.upOrDown=@"22";//线上or线下
//                                                [self.navigationController pushViewController:payVC animated:YES];                                           }
//                                            else
//                                            {
//                                                [UIAlertView alertWithTitle:@"温馨提示" message:dics[@"errorMsg"] buttonTitle:nil];
//                                            }
//                                        }];
//                                    }
//                                    
//                                    
//                                }];
//                            }
//                            
                            
                        }
                        
                        else if ([dic[@"errorCode"] isEqualToString:@"00018"])
                        {
                            [activityView stopAnimate];
                            [self.view endEditing:YES];
                            UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:dic[@"errorMsg"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
                            alertView.tag=12;
                            alertView.delegate=self;
                            [alertView show];
                        }

                        else
                        {
                            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                        }
                        
                        
                    }];
                    
                }
                

            }
            else
            {
                DMLog(@"跳去设置密码页");
                [self.view endEditing:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*1), dispatch_get_current_queue(), ^{

                    SetPsdViewController * setVC=[[SetPsdViewController alloc]init];
                    [self.navigationController pushViewController:setVC animated:YES];
                    //                    }];
                });

            }
        }
            
            break;
        default:
            break;
    }
}
-(void)chooseWeixin
{
    DMLog(@"选择微信");
    _chooseVouchersPay=YES;
    [_weixinBtn setImage:[UIImage imageNamed:@"yx_clk"] forState:0];
    [_alipayBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
}

-(void)chooseAlipay
{
    DMLog(@"选择支付宝");
    _chooseVouchersPay=NO;
    [_weixinBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
    [_alipayBtn setImage:[UIImage imageNamed:@"yx_clk"] forState:0];
}

-(void)ensurePayOrder
{
    [UIView animateWithDuration:0.26 animations:^{
        self.view.frame=CGRectMake(0, 0, WIDTH, HEIGHT);
    }];
    [self.view endEditing:YES];
    
    _ensureBtn.enabled=NO;
//    NSString * shopId;
    if ([_whichPage isEqualToString:@"扫描"]) {
        useShopId=_shopId;
    }
    else
    {
        useShopId=_infoModel.shopId;
    }
    if (_weixinTF.text.length==0&&_weixinCoinTF.text.length==0&&_alipayTF.text.length==0&&_alipayCoinTF.text.length==0) {
        _ensureBtn.enabled=YES;
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入需要支付的价格" buttonTitle:nil];
    }
    else
    {
        
//        NSString * coinMount;
        if (_weixinCoinTF.text.length==0) {
            weixinCoinMount=@"0";
        }
        else
        {
            weixinCoinMount=_weixinCoinTF.text;
        }
        
        if (_alipayCoinTF.text.length==0) {
            alipayCoinMount=@"0";
        }
        else
        {
            alipayCoinMount=_alipayCoinTF.text;
        }
        
        if (_chooseVouchersPay==YES) {
            DMLog(@"选择了微信支付");
            
//            NSString * weixinMount;
            if (_weixinTF.text.length==0) {
                weixinMount=@"0";
            }
            else
            {
                weixinMount=_weixinTF.text;
            }
            
            // 如果全用微信，不用弹框
            if ([weixinCoinMount floatValue]==0) {
                [activityView startAnimate];
                NSDictionary * param=@{@"shopId":useShopId,@"price":weixinMount,@"goldNum":weixinCoinMount,@"payMethod":@"0",@"payPwd":@""};
                [RequstEngine requestHttp:@"1082" paramDic:param blockObject:^(NSDictionary *dic) {
                    DMLog(@"1082--%@",dic);
                    DMLog(@"error---%@",dic[@"errorMsg"]);
                    if ([dic[@"errorCode"] intValue]==00000) {
                        
                        [[NSUserDefaults standardUserDefaults] setObject:dic[@"orderId"] forKey:@"orderId"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        NSDictionary * param=@{@"type":@"0",@"orderId":dic[@"orderId"],@"tradeType":@"APP"};
                        [RequstEngine requestHttp:@"1059" paramDic:param blockObject:^(NSDictionary *dic) {
                            DMLog(@"1059---%@",dic);
                            DMLog(@"error---%@",dic[@"errorMsg"]);
                            if ([dic[@"errorCode"] intValue]==00000) {
                                
                                //发起微信支付，设置参数
                                [activityView stopAnimate];
                                _ensureBtn.enabled=YES;
                                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"type"];
                                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"types"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"page"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"which"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                PayReq *request = [[PayReq alloc] init];
                                NSString *stamp = dic[@"data"][@"param"][@"timestamp"];
                                request.openID= dic[@"data"][@"param"][@"appid"];
                                request.partnerId =dic[@"data"][@"param"][@"partnerid"];
                                request.prepayId= dic[@"data"][@"param"][@"prepayid"];
                                request.package = dic[@"data"][@"param"][@"packageStr"];
                                request.nonceStr= dic[@"data"][@"param"][@"noncestr"];
                                request.sign=dic[@"data"][@"param"][@"sign"];
                                request.timeStamp=stamp.intValue;
                                [activityView stopAnimate];
                                //            调用微信
                                [WXApi sendReq:request];
                                
                                DMLog(@"partid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",request.partnerId,request.prepayId,request.nonceStr,(long)request.timeStamp,request.package,request.sign );
                                
                                
                            }
                            else
                            {
                                [activityView stopAnimate];
                                [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                            }
                            
                        }];
                        
                    }
                    else
                    {
                        [activityView stopAnimate];
                        [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                    }
                    
                    
                }];

            }
            else
            {
                _ensureBtn.enabled=YES;
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"请输入通宝币支付密码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
                [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
                dialog.tag=10;
                [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeASCIICapable];
                
                //设置输入框的键盘类型
                UITextField *tf = [dialog textFieldAtIndex:0];
                tf.layer.cornerRadius=3;
                tf.layer.masksToBounds=YES;
                tf.secureTextEntry=YES;
                [dialog show];

              
                
            }
            
            
        }
        else
        {
            if (_alipayTF.text.length==0) {
                alipayMount=@"0";
            }
            else
            {
                alipayMount=_alipayTF.text;
            }
            //全用支付宝付，不需要弹框
            if ([alipayCoinMount floatValue]==0) {
                NSDictionary * param=@{@"shopId":useShopId,@"price":alipayMount,@"goldNum":alipayCoinMount,@"payMethod":@"1",@"payPwd":@""};
                [RequstEngine requestHttp:@"1082" paramDic:param blockObject:^(NSDictionary *dic) {
                    DMLog(@"1082--%@",dic);
                    DMLog(@"error---%@",dic[@"errorMsg"]);
                    [activityView stopAnimate];
                    _ensureBtn.enabled=YES;
                    if ([dic[@"errorCode"] intValue]==00000) {
                        
                        NSString * orderString=dic[@"param"][@"paramStr"];
                        NSString * appScheme = @"eShangBao";
//                        NSString * signedString = [self urlEncodedString:orderString];
                        DMLog(@"orderStr-------%@",orderString);
                        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                            if ([resultDic[@"resultStatus"] intValue]==9000) {
                                
//                                [UIAlertView alertWithTitle:@"温馨提示" message:@"订单支付成功" buttonTitle:nil];
                                PaySuccessViewController * payVC=[[PaySuccessViewController alloc]init];
                                payVC.orderId=dic[@"orderId"];
                                payVC.hidesBottomBarWhenPushed=YES;
                                payVC.whichPage=@"2";
                                payVC.buyOrSeller=@"11";
                                payVC.upOrDown=@"22";//线上or线下
                                [self.navigationController pushViewController:payVC animated:YES];
                            }
                            else
                            {
                                [UIAlertView alertWithTitle:@"温馨提示" message:@"订单支付失败" buttonTitle:nil];
                            }
                            
                            
                        }];

//                        [[NSUserDefaults standardUserDefaults] setObject:dic[@"orderId"] forKey:@"orderId"];
//                        [[NSUserDefaults standardUserDefaults] synchronize];
//                        //                    if ([dic[@"errorCode"] intValue]==00000) {
//                        NSString *partner = @"2088121834499540";
//                        NSString *seller = @"535259521@qq.com";
//                        NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAKNWTgfc/1+1y2t+nMfSqB3KOJ+Waf/XIs4UUTTA6uL/21fJEu1L4bHwiCv7rr7gC0enAkzGpOqW5BeHSvYCiLi3GykGr5LJKp6wPvmK/T8rmu6RC5/jMHY9rOcSF+f/R3ubRnBgRQeheWcILvg6099Y+9YZqiU1cDM5gvPk/5drAgMBAAECgYEAgFucapWDooVM3KbdMjMbpn16Tf94QXOhiG1y+4/3hngmuS/szcpqDNnHSTk6NAoBE0ftiMQ6aZg2mz7Y68dGBRGBd8j4N1wiGq36nCEVIK8NtMeb7QWTS+AtH9of7Gc9bfqonD14kH+KTtzGlaH4fITgvLN4QsrPy4B3BsOEIPECQQDPtMrA97LI4gSW4E17vtfyM88NGBxNKoaSxPReOhXSIN+nvJie7p9b3g6SXcaeE67Ahuh2q83aERXWD6QaE5gtAkEAyVCM7MrzajOXgQWgdaIvklOMpSlsQZHaiO5zFs3VKbZBfAfJEkk5qAW0x78l8DpOnJYLh4LE0OAh2dHRb21U9wJAZQZGZ70SlGp6WPgYN8wHNKLGXlQPz+iTM+fgA8S0wFOE9QziHstpb0F+TOqXpGNmZ/Y2MyI1KY+N02QgKR7GsQJBAK2iikpaqiR5pz0ja0jKwJlG8tIprjPH52Oftyh+FFNL3aNq26Sn/9DKSyjV15Uh1Vf9mqggxD0cdFX5QNkIxfUCQGZ/+x06MH2fyH0kOr9IDxMwylTZRkLDjlvZs3Tv4CZ5RZbaaREcJ8Hmcf+QNTbXtNE9k8nGw/yQlDLmvhkI3fo=";
//                        if ([partner length] == 0 || [seller length] == 0)
//                        {
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                            message:@"缺少partner或者seller。"
//                                                                           delegate:self
//                                                                  cancelButtonTitle:@"确定"
//                                                                  otherButtonTitles:nil];
//                            [alert show];
//                            return;
//                        }
//                        
//                        //        NSLog(@"++++***%@,%@",_orderNo,_urlString);
//                        Order *order = [[Order alloc] init];
//                        order.partner = partner;
//                        order.seller = seller;
//                        order.tradeNO = [NSString stringWithFormat:@"PRONO%@",dic[@"orderId"]]; //订单ID(由商家□自□行制定)
//                        order.productName = @"商品支付"; //商品标题
//                        order.productDescription = @"充值"; //商品描述
//                        order.amount =_alipayTF.text;  //商 品价格
//                        order.notifyURL =@"http://120.27.148.135/consumption_interface/AliPayResultDo"; //回调URL
//                        order.service = @"mobile.securitypay.pay";
//                        order.paymentType = @"1";
//                        order.inputCharset = @"utf-8";
//                        order.itBPay = @"30m";
//                        order.showUrl = @"m.alipay.com";
//                        
//                        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
//                        NSString *appScheme = @"eShangBao";
//                        
//                        //将商品信息拼接成字符串
//                        NSString *orderSpec = [order description];
//                        //    NSLog(@"orderSpec = %@",orderSpec);
//                        
//                        //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//                        id<DataSigner> signer = CreateRSADataSigner(privateKey);
//                        NSString *signedString = [signer signString:orderSpec];   
//
//                        //将签名成功字符串格式化为订单字符串,请严格按照该格式
//                        NSString *orderString = nil;
//                        if (signedString != nil) {
//                            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                                           orderSpec, signedString, @"RSA"];
//                            DMLog(@"------%@",orderString);
//                            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//                                
//                                DMLog(@"------%@",resultDic);
//                                if ([resultDic[@"resultStatus"] intValue]==9000) {
//                                    NSDictionary * param=@{@"orderId":dic[@"orderId"]};
//                                    [RequstEngine requestHttp:@"1086" paramDic:param blockObject:^(NSDictionary *dics) {
//                                        DMLog(@"1086---%@",dics);
//                                        DMLog(@"error---%@",dics[@"errorMsg"]);
//                                        if ([dics[@"errorCode"] intValue]==00000) {
//                                            
//                                            PaySuccessViewController * payVC=[[PaySuccessViewController alloc]init];
//                                            payVC.orderId=dic[@"orderId"];
//                                            payVC.hidesBottomBarWhenPushed=YES;
//                                            payVC.whichPage=@"0";
//                                            payVC.buyOrSeller=@"11";
//                                            payVC.upOrDown=@"22";//线上or线下
//                                            [self.navigationController pushViewController:payVC animated:YES];
//
//                                        }
//                                        else
//                                        {
//                                            [UIAlertView alertWithTitle:@"温馨提示" message:dics[@"errorMsg"] buttonTitle:nil];
//                                        }
//                                    }];
//                                }
//                                
//                                
//                            }];
//                        }
                        
                        
                    }
                    else
                    {
                        [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                    }
                    
                    
                }];

            }
            else
            {
                _ensureBtn.enabled=YES;
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"请输入通宝币支付密码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
                [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
                dialog.tag=11;
                [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeASCIICapable];
                
                //设置输入框的键盘类型
                UITextField *tf = [dialog textFieldAtIndex:0];
                tf.layer.cornerRadius=3;
                tf.layer.masksToBounds=YES;
                tf.secureTextEntry=YES;
                [dialog show];
                
            }
            
//            if (_alipayTF.text.length==0&&_alipayCoinTF.text.length==0) {
//                [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入需要支付的价格" buttonTitle:nil];
//                
//            }
//            else
//            {
//               
//            }
            
            DMLog(@"选择了支付宝支付");
        }

    }
    
}

- (NSString*)urlEncodedString:(NSString *)string
{
    NSString * encodedString = (__bridge_transfer  NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
    
    return encodedString;
}

-(void)backToLast
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
