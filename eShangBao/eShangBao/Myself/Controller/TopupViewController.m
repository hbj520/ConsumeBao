
//
//  TopupViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "TopupViewController.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
//#import "WXApiRequestHandler.h"
#import "WXApi.h"
@interface TopupViewController ()<UITextFieldDelegate>
{
    UITextField * _countTF;
    int _choose;//判断选择微信还是支付宝支付
    TBActivityView *activityView;
}

@end

@implementation TopupViewController

- (void)viewDidLoad {
    _choose=0;
    [super viewDidLoad];
    [self backButton];
    self.title=@"充值";
    self.view.backgroundColor=BGMAINCOLOR;
    
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    
    // 加载UI
    [self loadUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backTO) name:@"backTopup" object:nil];
    // Do any additional setup after loading the view.
}

-(void)backTO
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadUI
{
    UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(10)+64, W(100), H(20))];
    titleLabel.text=@"充值方式";
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.textColor=MAINCHARACTERCOLOR;
    [self.view addSubview:titleLabel];
    
    UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(titleLabel)+H(10), WIDTH, H(44)*2)];
    coverView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:coverView];
    
    UIImageView * weixinImg=[[UIImageView alloc]initWithFrame:CGRectMake(W(12), H(6), W(30), H(30))];
    weixinImg.image=[UIImage imageNamed:@"chatWX"];
    [coverView addSubview:weixinImg];
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(kRight(weixinImg)+W(5), H(10), W(80), H(20))];
    label.textColor=MAINCHARACTERCOLOR;
    label.text=@"微信支付";
    label.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:label];
    
    _weixinBtn = [UIButton buttonWithType:0];
    _weixinBtn.frame=CGRectMake(kRight(label)+W(140), H(2), W(40), H(40));
    [_weixinBtn addTarget:self action:@selector(chooseWeixin) forControlEvents:1<<6];
    [_weixinBtn setImage:[UIImage imageNamed:@"yx_clk"] forState:0];
    [coverView addSubview:_weixinBtn];
    
    UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
    lineLabel.backgroundColor=BGMAINCOLOR;
    [coverView addSubview:lineLabel];
    
    UIImageView * zfbImg=[[UIImageView alloc]initWithFrame:CGRectMake(W(12), H(44)+H(6), W(30), H(30))];
    zfbImg.image=[UIImage imageNamed:@"zfb_icon"];
    [coverView addSubview:zfbImg];
    
    UILabel * label1=[[UILabel alloc]initWithFrame:CGRectMake(kRight(zfbImg)+W(5), H(44)+H(10), W(80), H(20))];
    label1.textColor=MAINCHARACTERCOLOR;
    label1.text=@"支付宝支付";
    label1.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:label1];
    
    _zfbBtn = [UIButton buttonWithType:0];
    _zfbBtn.frame=CGRectMake(kRight(label)+W(140), H(44)+H(2), W(40), H(40));
    [_zfbBtn addTarget:self action:@selector(chooseZfb) forControlEvents:1<<6];
    [_zfbBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
    [coverView addSubview:_zfbBtn];
    
    UIView * backView=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(coverView)+H(20), WIDTH, H(44))];
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    
    UILabel * praciseLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(10), W(65), H(22))];
    praciseLabel.text=@"购买个数";
    praciseLabel.textColor=MAINCHARACTERCOLOR;
    praciseLabel.font=[UIFont systemFontOfSize:14];
    [backView addSubview:praciseLabel];

    _countTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(praciseLabel)+W(20), 0, WIDTH-W(65)-W(12)*2-W(20), H(44))];
    _countTF.delegate=self;
    _countTF.returnKeyType=UIReturnKeyDone;
    _countTF.keyboardType=UIKeyboardTypeNumberPad;
    _countTF.textColor=MAINCHARACTERCOLOR;
    _countTF.placeholder=@"请输入购买个数";
    [_countTF addTarget:self action:@selector(changeCounts:) forControlEvents:UIControlEventEditingChanged];
    _countTF.font=[UIFont systemFontOfSize:14];
    [backView addSubview:_countTF];
    
    _payCountLabel=[[UILabel alloc]initWithFrame:CGRectMake( W(12), kDown(backView)+H(10), WIDTH-W(12)*2, H(20))];
    _payCountLabel.textColor=RGBACOLOR(255, 97, 0, 1);
    _payCountLabel.textAlignment=NSTextAlignmentRight;
    NSMutableAttributedString *attributeString=[[NSMutableAttributedString alloc]initWithString:@"请支付:￥0元"];
    [attributeString addAttribute:NSForegroundColorAttributeName value:MAINCHARACTERCOLOR range:NSMakeRange(0,4)];
    _payCountLabel.attributedText=attributeString;
    _payCountLabel.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_payCountLabel];
    
    _accomplishBtn=[UIButton buttonWithType:0];
    _accomplishBtn.frame=CGRectMake(W(20), H(430)+64, WIDTH-W(20)*2, 40);
    _accomplishBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    [_accomplishBtn addTarget:self action:@selector(jump) forControlEvents:1<<6];
    [_accomplishBtn setTitle:@"立即充值" forState:0];
    _accomplishBtn.layer.cornerRadius=3;
    _accomplishBtn.layer.masksToBounds=YES;
    [_accomplishBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:_accomplishBtn];
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
-(void)changeCounts:(UITextField *)textField
{
//    _payCountLabel.text=[NSString stringWithFormat:@"请支付:￥%@元",textField.text];
    if (textField.text.length==0) {
        NSMutableAttributedString *attributeString=[[NSMutableAttributedString alloc]initWithString:@"请支付:￥0元"];
        [attributeString addAttribute:NSForegroundColorAttributeName value:MAINCHARACTERCOLOR range:NSMakeRange(0,4)];
        _payCountLabel.attributedText=attributeString;
    }
    else
    {
        NSMutableAttributedString *attributeString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"请支付:￥%@元",textField.text]];
        [attributeString addAttribute:NSForegroundColorAttributeName value:MAINCHARACTERCOLOR range:NSMakeRange(0,4)];
        _payCountLabel.attributedText=attributeString;
    }
    
}
#pragma mark - 按钮绑定的方法
-(void)chooseWeixin
{
    _choose=0;
    [_weixinBtn setImage:[UIImage imageNamed:@"yx_clk"] forState:0];
    [_zfbBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
}

-(void)chooseZfb
{
    _choose=1;
    [_weixinBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
    [_zfbBtn setImage:[UIImage imageNamed:@"yx_clk"] forState:0];
}

-(void)jump
{
    [activityView startAnimate];
    _accomplishBtn.enabled=NO;
    DMLog(@"立即充值");
    if (_choose==0) {
//        NSString *res = [WXApiRequestHandler jumpToBizPay];
//        if( ![@"" isEqual:res] ){
//            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alter show];
//        }
        if (_countTF.text.length==0) {
            _accomplishBtn.enabled=YES;
            [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入通宝币数量" buttonTitle:nil];
        }
        else
        {
            NSDictionary * param=@{@"goldNum":_countTF.text};
            [RequstEngine requestHttp:@"1062" paramDic:param blockObject:^(NSDictionary *dic) {
                DMLog(@"1062---%@",dic);
                DMLog(@"error---%@",dic[@"errorMsg"]);
                if ([dic[@"errorCode"] intValue]==00000) {
                    [activityView stopAnimate];
                    [[NSUserDefaults standardUserDefaults] setObject:dic[@"orderId"] forKey:@"orderId"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    NSDictionary * param=@{@"type":@"1",@"orderId":dic[@"orderId"],@"tradeType":@"APP"};
                    [RequstEngine requestHttp:@"1059" paramDic:param blockObject:^(NSDictionary *dic) {
                        DMLog(@"1059---%@",dic);
                        DMLog(@"error---%@",dic[@"errorMsg"]);
                        if ([dic[@"errorCode"] intValue]==00000) {
                            [activityView stopAnimate];
                            //发起微信支付，设置参数
                            _accomplishBtn.enabled=YES;
                            
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"type"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"page"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            [[NSUserDefaults standardUserDefaults] setObject:@"4" forKey:@"which"];
                            //                        [[NSUserDefaults standardUserDefaults] setObject:dic[@"memberId"] forKey:@"memberId"];
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
                            [WXApi sendReq:request];
                            
                            DMLog(@"partid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",request.partnerId,request.prepayId,request.nonceStr,(long)request.timeStamp,request.package,request.sign );
                            
                            
                        }
                        else
                        {
                            [activityView stopAnimate];
                            _accomplishBtn.enabled=YES;
                            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                        }

                    }];
                }
                else
                {
                    [activityView stopAnimate];
                    _accomplishBtn.enabled=YES;
                    [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                }
            }];

        }
       
    }
    else
    {
        NSDictionary * param=@{@"goldNum":_countTF.text};
        [RequstEngine requestHttp:@"1062" paramDic:param blockObject:^(NSDictionary *dic) {

            DMLog(@"1062---%@",dic);
            DMLog(@"error---%@",dic[@"errorMsg"]);
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"orderId"] forKey:@"orderId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if ([dic[@"errorCode"] intValue]==00000) {
                [activityView stopAnimate];
                _accomplishBtn.enabled=YES;
                
                NSString * orderString=dic[@"param"][@"paramStr"];
                NSString * appScheme = @"eShangBao";
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    if ([resultDic[@"resultStatus"] intValue]==9000) {
                        
                         [self.navigationController popViewControllerAnimated:YES];
//                        [UIAlertView alertWithTitle:@"温馨提示" message:@"订单支付成功" buttonTitle:nil];
                    }
                    else
                    {
                        [UIAlertView alertWithTitle:@"温馨提示" message:@"订单支付失败" buttonTitle:nil];
                    }
                    
                    
                }];

//                NSString *partner = @"2088121834499540";
//                NSString *seller = @"535259521@qq.com";
//                NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAKNWTgfc/1+1y2t+nMfSqB3KOJ+Waf/XIs4UUTTA6uL/21fJEu1L4bHwiCv7rr7gC0enAkzGpOqW5BeHSvYCiLi3GykGr5LJKp6wPvmK/T8rmu6RC5/jMHY9rOcSF+f/R3ubRnBgRQeheWcILvg6099Y+9YZqiU1cDM5gvPk/5drAgMBAAECgYEAgFucapWDooVM3KbdMjMbpn16Tf94QXOhiG1y+4/3hngmuS/szcpqDNnHSTk6NAoBE0ftiMQ6aZg2mz7Y68dGBRGBd8j4N1wiGq36nCEVIK8NtMeb7QWTS+AtH9of7Gc9bfqonD14kH+KTtzGlaH4fITgvLN4QsrPy4B3BsOEIPECQQDPtMrA97LI4gSW4E17vtfyM88NGBxNKoaSxPReOhXSIN+nvJie7p9b3g6SXcaeE67Ahuh2q83aERXWD6QaE5gtAkEAyVCM7MrzajOXgQWgdaIvklOMpSlsQZHaiO5zFs3VKbZBfAfJEkk5qAW0x78l8DpOnJYLh4LE0OAh2dHRb21U9wJAZQZGZ70SlGp6WPgYN8wHNKLGXlQPz+iTM+fgA8S0wFOE9QziHstpb0F+TOqXpGNmZ/Y2MyI1KY+N02QgKR7GsQJBAK2iikpaqiR5pz0ja0jKwJlG8tIprjPH52Oftyh+FFNL3aNq26Sn/9DKSyjV15Uh1Vf9mqggxD0cdFX5QNkIxfUCQGZ/+x06MH2fyH0kOr9IDxMwylTZRkLDjlvZs3Tv4CZ5RZbaaREcJ8Hmcf+QNTbXtNE9k8nGw/yQlDLmvhkI3fo=";
//                if ([partner length] == 0 || [seller length] == 0)
//                {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                    message:@"缺少partner或者seller。"
//                                                                   delegate:self
//                                                          cancelButtonTitle:@"确定"
//                                                          otherButtonTitles:nil];
//                    [alert show];
//                    return;
//                }
//                
//                //        NSLog(@"++++***%@,%@",_orderNo,_urlString);
//                Order *order = [[Order alloc] init];
//                order.partner = partner;
//                order.seller = seller;
//                order.tradeNO = dic[@"orderId"]; //订单ID(由商家□自□行制定)
//                order.productName = @"充值"; //商品标题
//                order.productDescription = @"充值"; //商品描述
//                order.amount =_countTF.text;  //商 品价格
////                order.amount =@"0.01";  //商 品价格
//                order.notifyURL =@"http://120.27.148.135/consumption_interface/AliPayResultDo"; //回调URL
//                order.service = @"mobile.securitypay.pay";
//                order.paymentType = @"1";
//                order.inputCharset = @"utf-8";
//                order.itBPay = @"30m";
//                order.showUrl = @"m.alipay.com";
//                
//                //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
//                NSString *appScheme = @"eShangBao";
//                
//                //将商品信息拼接成字符串
//                NSString *orderSpec = [order description];
//                //    NSLog(@"orderSpec = %@",orderSpec);
//                
//                //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//                id<DataSigner> signer = CreateRSADataSigner(privateKey);
//                NSString *signedString = [signer signString:orderSpec];
//                
//                //将签名成功字符串格式化为订单字符串,请严格按照该格式
//                NSString *orderString = nil;
//                if (signedString != nil) {
//                    orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                                   orderSpec, signedString, @"RSA"];
//                    
//                    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//                        DMLog(@"resultDic---%@",resultDic);
//                        DMLog(@"----%@",resultDic[@"memo"]);
//                        if ([resultDic[@"resultStatus"] intValue]==9000) {
//                            NSDictionary * param=@{@"orderId":dic[@"orderId"],@"payType":@"2"};
//                            [RequstEngine requestHttp:@"1063" paramDic:param blockObject:^(NSDictionary *dic) {
//                                DMLog(@"1063---%@",dic);
//                                DMLog(@"error---%@",dic[@"errorMsg"]);
//                                if ([dic[@"errorCode"]intValue]==00000) {
//                                    [self.navigationController popViewControllerAnimated:YES];
//                                }
//                                else
//                                {
//                                    [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
//                                }
//
//                            }];
//                        }
//                        
//
//                    }];
//                }
                

            }
            else
            {
                [activityView stopAnimate];
                _accomplishBtn.enabled=YES;
                [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
            }

            
        }];
        
    }
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
