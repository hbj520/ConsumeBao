//
//  PayOrderViewController.m
//  eShangBao
//
//  Created by Dev on 16/1/22.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "PayOrderViewController.h"
#import "WXApiRequestHandler.h"
#import "DataMD5.h"
#import "WXApi.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "OrderDetailViewController.h"
#import "OrderViewController.h"
@interface PayOrderViewController ()
{
    int _choose;
    TBActivityView *activityView;
}

@end

@implementation PayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title=@"支付订单";                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    _choose=0;
    _payBtn.layer.cornerRadius=5;
    _payBtn.layer.masksToBounds=YES;
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    [activityView stopAnimate];
//    _orderName=
    _orderMoneyNum.text=[NSString stringWithFormat:@"%.2f",[_totalPrice floatValue]];;
    _needMoneyNum.text=[NSString stringWithFormat:@"%.2f",[_totalPrice floatValue]];
    _orderName.text=_shopName;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(inspectOrder) name:@"inspectOrder" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backToBusiness) name:@"backToBusiness" object:nil];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 通知方法
-(void)inspectOrder
{
    DMLog(@"查看订单");
    OrderDetailViewController * orderVC=[[OrderDetailViewController alloc]init];
    orderVC.orderID=ORDERID;
    NSMutableArray *navCtrArray=[NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [navCtrArray removeLastObject];
    [navCtrArray addObject:orderVC];
    [self.navigationController setViewControllers:navCtrArray];
    [self.navigationController pushViewController:orderVC animated:YES];
    
    
}

-(void)backToBusiness
{
    DMLog(@"返回商家");
     [[NSNotificationCenter defaultCenter]postNotificationName:@"cleanMsg" object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
//     [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}
- (IBAction)payButtonClick:(id)sender {
    
    _payBtn.enabled=NO;
    if (_choose==0) {
        [activityView startAnimate];
          NSDictionary * param=@{@"type":@"0",@"orderId":_orderID,@"tradeType":@"APP"};
        [RequstEngine requestHttp:@"1059" paramDic:param blockObject:^(NSDictionary *dic) {
            DMLog(@"1059---%@",dic);
            DMLog(@"error---%@",dic[@"errorMsg"]);
            [activityView stopAnimate];
            if ([dic[@"errorCode"] intValue]==00000) {
                //发起微信支付，设置参数
                _payBtn.enabled=YES;
                [[NSUserDefaults standardUserDefaults] setObject:_orderID forKey:@"orderId"];
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"type"];
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"page"];
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
                //  调用微信
                [WXApi sendReq:request];
                
                DMLog(@"partid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",request.partnerId,request.prepayId,request.nonceStr,(long)request.timeStamp,request.package,request.sign );

            }else{
                
                _payBtn.enabled=YES;
                [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                
            }
        }];
    }
    else
    {
        _payBtn.enabled=YES;
        
//        NSString * orderString=dic[@"param"][@"paramStr"];
        NSString * appScheme = @"eShangBao";
        [[AlipaySDK defaultService] payOrder:_paramStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            if ([resultDic[@"resultStatus"] intValue]==9000) {
                
                if (_jumpWhichPage==0) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"cleanMsg" object:nil];
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                }
                else
                {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }


//                [UIAlertView alertWithTitle:@"温馨提示" message:@"订单支付成功" buttonTitle:nil];
            }
            else
            {
                [UIAlertView alertWithTitle:@"温馨提示" message:@"订单支付失败" buttonTitle:nil];
            }
            
            
        }];

//        [[NSUserDefaults standardUserDefaults] setObject:_orderID forKey:@"orderId"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        //                    if ([dic[@"errorCode"] intValue]==00000) {
//        NSString *partner = @"2088121834499540";
//        NSString *seller = @"535259521@qq.com";
//        NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAKNWTgfc/1+1y2t+nMfSqB3KOJ+Waf/XIs4UUTTA6uL/21fJEu1L4bHwiCv7rr7gC0enAkzGpOqW5BeHSvYCiLi3GykGr5LJKp6wPvmK/T8rmu6RC5/jMHY9rOcSF+f/R3ubRnBgRQeheWcILvg6099Y+9YZqiU1cDM5gvPk/5drAgMBAAECgYEAgFucapWDooVM3KbdMjMbpn16Tf94QXOhiG1y+4/3hngmuS/szcpqDNnHSTk6NAoBE0ftiMQ6aZg2mz7Y68dGBRGBd8j4N1wiGq36nCEVIK8NtMeb7QWTS+AtH9of7Gc9bfqonD14kH+KTtzGlaH4fITgvLN4QsrPy4B3BsOEIPECQQDPtMrA97LI4gSW4E17vtfyM88NGBxNKoaSxPReOhXSIN+nvJie7p9b3g6SXcaeE67Ahuh2q83aERXWD6QaE5gtAkEAyVCM7MrzajOXgQWgdaIvklOMpSlsQZHaiO5zFs3VKbZBfAfJEkk5qAW0x78l8DpOnJYLh4LE0OAh2dHRb21U9wJAZQZGZ70SlGp6WPgYN8wHNKLGXlQPz+iTM+fgA8S0wFOE9QziHstpb0F+TOqXpGNmZ/Y2MyI1KY+N02QgKR7GsQJBAK2iikpaqiR5pz0ja0jKwJlG8tIprjPH52Oftyh+FFNL3aNq26Sn/9DKSyjV15Uh1Vf9mqggxD0cdFX5QNkIxfUCQGZ/+x06MH2fyH0kOr9IDxMwylTZRkLDjlvZs3Tv4CZ5RZbaaREcJ8Hmcf+QNTbXtNE9k8nGw/yQlDLmvhkI3fo=";
//        if ([partner length] == 0 || [seller length] == 0)
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                            message:@"缺少partner或者seller。"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil];
//            [alert show];
//            return;
//        }
//        
//        //        NSLog(@"++++***%@,%@",_orderNo,_urlString);
//        Order *order = [[Order alloc] init];
//        order.partner = partner;
//        order.seller = seller;
//        order.tradeNO = [NSString stringWithFormat:@"PRONO%@",_orderID]; //订单ID(由商家□自□行制定)
//        order.productName = @"余额充值"; //商品标题
//        order.productDescription = @"充值"; //商品描述
//        order.amount =_totalPrice;  //商 品价格
//        order.notifyURL =@"http://120.27.148.135/consumption_interface/AliPayResultDo"; //回调URL
//        order.service = @"mobile.securitypay.pay";
//        order.paymentType = @"1";
//        order.inputCharset = @"utf-8";
//        order.itBPay = @"30m";
//        order.showUrl = @"m.alipay.com";
//        
//        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
//        NSString *appScheme = @"eShangBao";
//        
//        //将商品信息拼接成字符串
//        NSString *orderSpec = [order description];
//        //    NSLog(@"orderSpec = %@",orderSpec);
//        
//        //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//        id<DataSigner> signer = CreateRSADataSigner(privateKey);
//        NSString *signedString = [signer signString:orderSpec];
//        
//        //将签名成功字符串格式化为订单字符串,请严格按照该格式
//        NSString *orderString = nil;
//        if (signedString != nil) {
//            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                           orderSpec, signedString, @"RSA"];
//            
//            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//                
//                DMLog(@"dic*****%@",resultDic);
//                if ([resultDic[@"resultStatus"] intValue]==9000) {
//                    NSDictionary * param=@{@"orderId":_orderID,@"status":@"1"};
//                    [RequstEngine requestHttp:@"1019" paramDic:param blockObject:^(NSDictionary *dic) {
//                        DMLog(@"1019---%@",dic);
//                        DMLog(@"error---%@",dic[@"errorMsg"]);
//                        if ([dic[@"errorCode"] intValue]==00000) {
//                            if (_jumpWhichPage==0) {
//                                [[NSNotificationCenter defaultCenter]postNotificationName:@"cleanMsg" object:nil];
//                                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
//                            }
//                            else
//                            {
//                                [self.navigationController popToRootViewControllerAnimated:YES];
//                            }
//                            
//                        }
//                        else
//                        {
//                            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
//                            
//                        }
//                    }];
//                }
//                
//                
//            }];
//        }

    }
//    NSDictionary * param=@{@"type":@"0",@"orderId":_orderID};
//    [RequstEngine requestHttp:@"1059" paramDic:param blockObject:^(NSDictionary *dic) {
//        DMLog(@"1059---%@",dic);
//        DMLog(@"error---%@",dic[@"errorMsg"]);
//        if ([dic[@"errorCode"] intValue]==00000) {
//            if (_choose==0) {
////                DMLog(@"微信支付");
////                NSString *res = [WXApiRequestHandler jumpToBizPay:dic[@"data"][@"prepayId"] sign:dic[@"data"][@"sign"] noncestr:dic[@"data"][@"nonceStr"]];
////                if( ![@"" isEqual:res] ){
////                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
////                    [alter show];
////                }
//                //发起微信支付，设置参数
//                [[NSUserDefaults standardUserDefaults] setObject:_orderID forKey:@"orderId"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//
//                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"type"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                
//                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"page"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//
//                PayReq *request = [[PayReq alloc] init];
//                NSString *stamp = dic[@"data"][@"param"][@"timestamp"];
//                request.openID= dic[@"data"][@"param"][@"appid"];
//                request.partnerId =dic[@"data"][@"param"][@"partnerid"];
//                request.prepayId= dic[@"data"][@"param"][@"prepayid"];
//                request.package = dic[@"data"][@"param"][@"packageStr"];
//                request.nonceStr= dic[@"data"][@"param"][@"noncestr"];
//                request.sign=dic[@"data"][@"param"][@"sign"];
//                request.timeStamp=stamp.intValue;
////                //将当前事件转化成时间戳
////                NSDate *datenow = [NSDate date];
////                NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
////                UInt32 timeStamp =[timeSp intValue];
////                request.timeStamp= timeStamp;
////                DataMD5 *md5 = [[DataMD5 alloc] init];
////                request.sign=[md5 createMD5SingForPay:@"wx503097df712d5a58" partnerid:request.partnerId prepayid:request.prepayId package:request.package noncestr:request.nonceStr timestamp:request.timeStamp];
//                //            调用微信
//                [WXApi sendReq:request];
//
//                DMLog(@"partid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",request.partnerId,request.prepayId,request.nonceStr,(long)request.timeStamp,request.package,request.sign );
//            }
//            else
//            {
//                DMLog(@"支付宝支付");
//                
//                    [[NSUserDefaults standardUserDefaults] setObject:_orderID forKey:@"orderId"];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
////                    if ([dic[@"errorCode"] intValue]==00000) {
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
//                        order.tradeNO = _orderID; //订单ID(由商家□自□行制定)
//                        order.productName = @"余额充值"; //商品标题
//                        order.productDescription = @"充值"; //商品描述
//                        order.amount =_totalPrice;  //商 品价格
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
//                            
//                            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//                                if ([resultDic[@"resultStatus"] intValue]==9000) {
//                                    NSDictionary * param=@{@"orderId":_orderID,@"status":@"1"};
//                                    [RequstEngine requestHttp:@"1019" paramDic:param blockObject:^(NSDictionary *dic) {
//                                        DMLog(@"1019---%@",dic);
//                                        DMLog(@"error---%@",dic[@"errorMsg"]);
//                                    }];
//                                }
//
//                                
//                            }];
//                        }
//                        
//                        
////                    }
//                
////                }];
//
//            }
//
//        }
//    }];
}
- (IBAction)choosePayWayBtn:(id)sender {
    
    UIButton *newBtn=(UIButton *)sender;
    switch (newBtn.tag) {
        case 1:
        {
            _choose=0;
            _ChatChooseImage.image=[UIImage imageNamed:@"3-(2)选择_03"];
            _zfbChooseImage.image=[UIImage imageNamed:@"3-(2)选择_06"];
            DMLog(@"微信");
        }
            break;
        case 2:
        {
            _choose=1;
            _ChatChooseImage.image=[UIImage imageNamed:@"3-(2)选择_06"];
            _zfbChooseImage.image=[UIImage imageNamed:@"3-(2)选择_03"];
            DMLog(@"支付宝");
        }
            break;
            
        default:
            break;
    }
    
    
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
