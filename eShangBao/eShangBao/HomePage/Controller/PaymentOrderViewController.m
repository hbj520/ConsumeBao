//
//  PaymentOrderViewController.m
//  eShangBao
//
//  Created by doumee on 16/7/1.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "PaymentOrderViewController.h"
#import "SubmitTableViewCell.h"
#import "DeliveryAddressViewController.h"
#import "PaymentOrderTableViewCell.h"
#import "WXApi.h"
#import "LoginViewController.h"
#import "OrderDetailViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
@interface PaymentOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    double                  totale;
    NSString                *addressID;//地址ID
    NSString                *newpayMethod;//支付方式
    TBActivityView          *activityView;
    UIButton                *doneInKeyboardButton;
    NSString*               _goldNum;//当前输入的通币
    NSString                *biPwd;//通宝币支付密码
    float                     myGoldNum;//我的通币
    BOOL                    _chooseVouchersPay;
    NSMutableArray          * _goodsList;
}

@property(nonatomic,strong)UILabel * orderNameLabel;

@property(nonatomic,strong)UILabel * orderPriceLabel;//订单价格

@property(nonatomic,strong)UIButton * weixinBtn;//微信支付按钮

@property(nonatomic,strong)UIButton * alipayBtn;//支付宝支付按钮

@property(nonatomic,strong)UIButton * ensureBtn;//确认支付按钮
@end

@implementation PaymentOrderViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [_tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _goodsList=[NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor=BGMAINCOLOR;
    self.title=@"支付订单";
    
    
    [self backButton];
    [self loadUI];
    [self createMyAddressRequest];
    _chooseVouchersPay=YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backToBusiness) name:@"backToBusiness" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(inspectOrder) name:@"inspectOrder" object:nil];
    
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    [activityView stopAnimate];
    // Do any additional setup after loading the view.
}

-(void)backToBusiness
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
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

-(void)loadUI
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 68) style:0];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=0;
    _tableView.rowHeight=68;
    _tableView.scrollEnabled=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.view addSubview:_tableView];
    
    UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(_tableView)+10, WIDTH, 60)];
    coverView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:coverView];
    
    _orderNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 5, WIDTH-15*2, 20)];
//    _orderNameLabel.text=@"订单名称: 绿牌伏特加 MOOAOHDFKHJADSF";
    _orderNameLabel.text=[NSString stringWithFormat:@"订单名称: %@",_groundingModel.goodsName];
    _orderNameLabel.textColor=MAINCHARACTERCOLOR;
    _orderNameLabel.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:_orderNameLabel];
    
    _orderPriceLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, kDown(_orderNameLabel)+10, WIDTH-15*2, 20)];
//    _orderPriceLabel.text=@"订单金额: ￥1000.00";
    _orderPriceLabel.text=[NSString stringWithFormat:@"订单金额: ￥%@",_groundingModel.price];
    _orderPriceLabel.textColor=MAINCOLOR;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:_orderPriceLabel.text];
    //设置：在0-3个单位长度内的内容显示成红色
    [str addAttribute:NSForegroundColorAttributeName value:MAINCHARACTERCOLOR range:NSMakeRange(0, 5)];
    _orderPriceLabel.attributedText = str;
    _orderPriceLabel.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:_orderPriceLabel];
    
    UIView * backView=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(coverView)+10, WIDTH, 100)];
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    
    UIImageView * weixinImg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 30, 30)];
    weixinImg.image=[UIImage imageNamed:@"chatWX"];
    [backView addSubview:weixinImg];
    
    UILabel * weixinLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(weixinImg)+10, 15, 100, 20)];
    weixinLabel.textColor=MAINCHARACTERCOLOR;
    weixinLabel.text=@"微信支付";
    weixinLabel.font=[UIFont systemFontOfSize:14];
    [backView addSubview:weixinLabel];
    
    _weixinBtn=[UIButton buttonWithType:0];
    _weixinBtn.frame=CGRectMake(WIDTH-15-30, 8, 40, 40);
    [_weixinBtn addTarget:self action:@selector(chooseWeixin) forControlEvents:1<<6];
    [_weixinBtn setImage:[UIImage imageNamed:@"yx_clk"] forState:0];
    [backView addSubview:_weixinBtn];
    
    UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 49, WIDTH, 1)];
    lineLabel.backgroundColor=BGMAINCOLOR;
    [backView addSubview:lineLabel];
    
    UIImageView * alipayImg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10+kDown(lineLabel), 30, 30)];
    alipayImg.image=[UIImage imageNamed:@"zfb_icon"];
    [backView addSubview:alipayImg];
    
    UILabel * alipayLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(weixinImg)+10, 15+kDown(lineLabel), 100, 20)];
    alipayLabel.textColor=MAINCHARACTERCOLOR;
    alipayLabel.text=@"支付宝支付";
    alipayLabel.font=[UIFont systemFontOfSize:14];
    [backView addSubview:alipayLabel];
    
    _alipayBtn=[UIButton buttonWithType:0];
    _alipayBtn.frame=CGRectMake(WIDTH-15-30, 3+kDown(lineLabel), 40, 40);
    [_alipayBtn addTarget:self action:@selector(chooseAlipay) forControlEvents:1<<6];
    [_alipayBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
    [backView addSubview:_alipayBtn];
    
    
    _ensureBtn=[UIButton buttonWithType:0];
    _ensureBtn.frame=CGRectMake(15, kDown(backView)+100, WIDTH-15*2, 40);
    [_ensureBtn setTitle:@"确认支付" forState:0];
    [_ensureBtn setTitleColor:[UIColor whiteColor] forState:0];
    _ensureBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    _ensureBtn.backgroundColor=MAINCOLOR;
    _ensureBtn.layer.cornerRadius=5;
    _ensureBtn.layer.masksToBounds=YES;
    [_ensureBtn addTarget:self action:@selector(ensurePayOrder) forControlEvents:1<<6];
    [self.view addSubview:_ensureBtn];


    NSString  *goodsId=[NSString stringWithFormat:@"%@",_groundingModel.goodsId];
//    NSString  *chooseNum=[NSString stringWithFormat:@"%@",_groundingModel.chooseNum];
    NSDictionary *chooseDic=@{@"goodsId":goodsId,@"goodsNum":@"1"};
    [_goodsList addObject:chooseDic];
}

-(void)createMyAddressRequest
{
    
    NSDictionary *pagination=@{@"page":@"1",@"rows":@"1",@"firstQueryTime":@""};
    [RequstEngine pagingRequestHttp:@"1017" paramDic:nil pageDic:pagination blockObject:^(NSDictionary *dic) {
        
        [activityView stopAnimate];
        if ([dic[@"errorCode"] intValue]==0) {
            
            for (NSDictionary *newDic in dic[@"recordList"]) {
                
                _chooseAddr=[[AddressModel alloc]init];
                [_chooseAddr setValuesForKeysWithDictionary:newDic];
                addressID=_chooseAddr.addrId;
                [_tableView reloadData];
            }
            
            
        }
        DMLog(@"1017----%@",dic);
        
        
    }];
    
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSArray *cellArr=[[NSBundle mainBundle] loadNibNamed:@"SubmitTableViewCell" owner:nil options:nil];
    PaymentOrderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SubmitTableViewCell"];

    if (!cell) {
        cell=[[PaymentOrderTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"SubmitTableViewCell"];
    }
    cell.selectionStyle=0;
    cell.accessoryType=1;
    if (_chooseAddr!=nil) {
    
        cell.nameLabel.text=_chooseAddr.name;
        cell.phoneLabel.text=_chooseAddr.phone;
        cell.addressLabel.text=[NSString stringWithFormat:@"%@%@",_chooseAddr.positon,_chooseAddr.details];
    }else{
        
        
        cell.nameLabel.text=@"";
        cell.phoneLabel.text=@"请选择收货地址";
        cell.addressLabel.text=@"";
        
    }

    return cell;


}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeliveryAddressViewController *deliveryAddressVC=[[DeliveryAddressViewController alloc]init];
    deliveryAddressVC.addressType=2;
    [self.navigationController pushViewController:deliveryAddressVC animated:YES];
}


#pragma mark - Button way
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

-(void)setChooseAddr:(AddressModel *)chooseAddr
{
    
    
    _chooseAddr=chooseAddr;
    [_tableView reloadData];
    addressID=chooseAddr.addrId;
    
    DMLog(@"%@",chooseAddr);
}


-(void)ensurePayOrder
{
    _ensureBtn.enabled=NO;
   [activityView startAnimate];
    if (_chooseAddr.addrId.length==0) {
        _ensureBtn.enabled=YES;
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请选择收货地址" buttonTitle:nil];
        return;
    }
    
    if (_chooseVouchersPay==YES) {
        DMLog(@"选择了微信支付");
        
        NSDictionary * param=@{@"goodsList":_goodsList,@"addrId":addressID,@"goldNum":@"",@"payMethod":@"0",@"sendDate":@"",@"payPwd":@""};
        [RequstEngine requestHttp:@"1074" paramDic:param blockObject:^(NSDictionary *dic) {
            DMLog(@"1074--%@",dic);
            DMLog(@"error---%@",dic[@"errorMsg"]);
            
            if ([dic[@"errorCode"] intValue]==00000) {
                
                [[NSUserDefaults standardUserDefaults] setObject:dic[@"orderId"] forKey:@"orderId"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSDictionary * param=@{@"type":@"0",@"orderId":dic[@"orderId"],@"tradeType":@"APP"};
                [activityView startAnimate];
                [RequstEngine requestHttp:@"1059" paramDic:param blockObject:^(NSDictionary *dic) {
                    DMLog(@"1059---%@",dic);
                    DMLog(@"error---%@",dic[@"errorMsg"]);
                    [activityView stopAnimate];
                    
                    _ensureBtn.enabled=YES;
                    if ([dic[@"errorCode"] intValue]==00000) {
                        
                        //发起微信支付，设置参数
                        
                        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"type"];
                        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"types"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"page"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
//                        
//                        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"which"];
//                        [[NSUserDefaults standardUserDefaults] synchronize];
                        PayReq *request = [[PayReq alloc] init];
                        NSString *stamp = dic[@"data"][@"param"][@"timestamp"];
                        request.openID= dic[@"data"][@"param"][@"appid"];
                        request.partnerId =dic[@"data"][@"param"][@"partnerid"];
                        request.prepayId= dic[@"data"][@"param"][@"prepayid"];
                        request.package = dic[@"data"][@"param"][@"packageStr"];
                        request.nonceStr= dic[@"data"][@"param"][@"noncestr"];
                        request.sign=dic[@"data"][@"param"][@"sign"];
                        request.timeStamp=stamp.intValue;
                        
                        //            调用微信
                        [WXApi sendReq:request];
                        
                        DMLog(@"partid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",request.partnerId,request.prepayId,request.nonceStr,(long)request.timeStamp,request.package,request.sign );
                        
                        
                    }
                    else
                    {
                        _ensureBtn.enabled=YES;
                        [activityView stopAnimate];
                        [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                    }
                    
                }];
                
            }
            else
            {
                _ensureBtn.enabled=YES;
                [activityView stopAnimate];
                [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
            }
            
            
        }];

    }
    else
    {

        
        
        NSDictionary * param=@{@"goodsList":_goodsList,@"addrId":_chooseAddr.addrId,@"goldNum":@"",@"payMethod":@"0",@"sendDate":@"",@"payPwd":@""};
        [RequstEngine requestHttp:@"1074" paramDic:param blockObject:^(NSDictionary *dic) {
            DMLog(@"1074--%@",dic);
            DMLog(@"error---%@",dic[@"errorMsg"]);
            if ([dic[@"errorCode"] intValue]==00000) {
                _ensureBtn.enabled=YES;
                [activityView stopAnimate];
                
                NSString * orderString=dic[@"param"][@"paramStr"];
                NSString * appScheme = @"eShangBao";
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    if ([resultDic[@"resultStatus"] intValue]==9000) {
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
//                        [UIAlertView alertWithTitle:@"温馨提示" message:@"订单支付成功" buttonTitle:nil];
                    }
                    else
                    {
                        [UIAlertView alertWithTitle:@"温馨提示" message:@"订单支付失败" buttonTitle:nil];
                    }
                    
                    
                }];

//                [[NSUserDefaults standardUserDefaults] setObject:dic[@"orderId"] forKey:@"orderId"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                //                    if ([dic[@"errorCode"] intValue]==00000) {
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
//                order.tradeNO = [NSString stringWithFormat:@"PRONO%@",dic[@"orderId"]]; //订单ID(由商家□自□行制定)
//                order.productName = @"余额充值"; //商品标题
//                order.productDescription = @"充值"; //商品描述
//                order.amount =dic[@"totalPrice"];  //商 品价格
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
//                        if ([resultDic[@"resultStatus"] intValue]==9000) {
//                            NSDictionary * param=@{@"status":@"1",@"orderId":dic[@"orderId"]};
//                            [RequstEngine requestHttp:@"1019" paramDic:param blockObject:^(NSDictionary *dic) {
//                                DMLog(@"1019---%@",dic);
//                                DMLog(@"error---%@",dic[@"errorMsg"]);
//                                if ([dic[@"errorCode"] intValue]==00000) {
//                                    [self.navigationController popToRootViewControllerAnimated:YES];
//                                }
//                                else
//                                {
//                                    [[NSNotificationCenter defaultCenter]postNotificationName:@"cleanMsg" object:nil];
//                                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
//                                    
//                                }
//                            }];
//                        }
//                        
//                        
//                    }];
//                }
                
                
            }
            else
            {
                _ensureBtn.enabled=YES;
                [activityView stopAnimate];
                [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
            }
            
            
        }];

        DMLog(@"选择了支付宝支付");
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
