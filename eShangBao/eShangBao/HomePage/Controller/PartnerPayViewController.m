//
//  PartnerPayViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/16.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "PartnerPayViewController.h"
#import "LevelTableViewCell.h"
#import "WXApi.h"
#import "LoginViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "WebViewController.h"
@interface PartnerPayViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int _choose;
    int _payStyle;
    NSMutableArray * _nameArr;//等级名称
    NSMutableArray * _priceArr;//价格
    NSMutableArray * _levelArr;//等级
    UITableView * _tableView;
    
    NSInteger _selectRow;//选中的行数
    NSString * _partnerLevel;
    NSString * _price;
    BOOL _isSelect;
    UIScrollView * _scrollerView;//
    TBActivityView *activityView;
}

@end

@implementation PartnerPayViewController

-(void)viewWillAppear:(BOOL)animated
{
    _nameArr=[NSMutableArray arrayWithCapacity:0];
    _priceArr=[NSMutableArray arrayWithCapacity:0];
    _levelArr=[NSMutableArray arrayWithCapacity:0];
    if (![NSString isLogin]) {
        [self loginUser];
    }
    else
    {
        NSDictionary * param=@{@"type":@"0",@"minLevel":@""};
        [RequstEngine requestHttp:@"1023" paramDic:param blockObject:^(NSDictionary *dic) {
            DMLog(@"1023==%@",dic);
            if (_nameArr.count>0) {
                [_nameArr removeAllObjects];
                [_priceArr removeAllObjects];
            }
            for (NSDictionary * dict in dic[@"categoryList"]) {
                levelModel * model=[[levelModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [_nameArr addObject:dict[@"name"]];
                [_priceArr addObject:dict[@"price"]];
                [_levelArr addObject:dict[@"levelId"]];
                _partnerLevel=_levelArr[0];
                _price=_priceArr[0];
                [_tableView reloadData];
            }
            [self loadUI];
        }];

    }

   
}

- (void)viewDidLoad
{
    _choose=3;
    _payStyle=0;
    [super viewDidLoad];
    [self backButton];
    _isSelect=NO;
    self.title=@"支付";
    

    
    self.view.backgroundColor=RGBACOLOR(249, 249, 249, 1);
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backTO) name:@"become" object:nil];
    // 加载UI
//    [self loadUI];
    // Do any additional setup after loading the view.
}

-(void)backTO
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)loginUser
{
    LoginViewController * loginVC=[[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}
-(void)loadUI
{
    if (!_scrollerView) {
        _scrollerView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _scrollerView.contentSize=CGSizeMake(WIDTH, H(75)+H(10)+H(60)*_nameArr.count+H(10)+H(60)*3+140);
        _scrollerView.showsHorizontalScrollIndicator = NO;
        _scrollerView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_scrollerView];
        
        DMLog(@"____%@,%@,%@",_nameArr,_priceArr,_levelArr);
        UIImageView * adImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, H(75))];
        adImg.image=[UIImage imageNamed:@"zhb_bg.jpg"];
        adImg.contentMode=2;
        [_scrollerView addSubview:adImg];
        
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, kDown(adImg)+H(10), WIDTH, H(50)*_nameArr.count) style:0];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.rowHeight=H(50);
        _tableView.separatorStyle=0;
        [_scrollerView addSubview:_tableView];
        
        
        UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(_tableView)+H(10), WIDTH, H(60)*3)];
        coverView.backgroundColor=[UIColor whiteColor];
        [_scrollerView addSubview:coverView];
        
        UIImageView * zfbImg=[[UIImageView alloc]initWithFrame:CGRectMake(W(12), H(10), W(40), H(40))];
        zfbImg.image=[UIImage imageNamed:@"chatWX"];
        [coverView addSubview:zfbImg];
        
        UILabel * zfbLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(zfbImg)+W(20), H(10), W(70), H(15))];
        zfbLabel.text=@"立即支付";
        zfbLabel.textColor=MAINCHARACTERCOLOR;
        zfbLabel.font=[UIFont systemFontOfSize:14];
        [coverView addSubview:zfbLabel];
        
        UILabel * tuijianLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(zfbImg)+W(20), kDown(zfbLabel)+H(10), W(180), H(15))];
        tuijianLabel.text=@"推荐有微信账号的用户使用";
        tuijianLabel.font=[UIFont systemFontOfSize:14];
        tuijianLabel.textColor=GRAYCOLOR;
        [coverView addSubview:tuijianLabel];
        
        //    UIImageView * img=[[UIImageView alloc]initWithFrame:CGRectMake(kRight(tuijianLabel)+W(10), H(2), W(40), H(56))];
        //    img.image=[UIImage imageNamed:@"yx_clk"];
        //    img.contentMode=3;
        //    [coverView addSubview:img];
        
        _weixinBtn = [UIButton buttonWithType:0];
        _weixinBtn.frame=CGRectMake(kRight(tuijianLabel)+W(20), H(10), W(40), H(40));
        [_weixinBtn addTarget:self action:@selector(chooseWeixin) forControlEvents:1<<6];
        [_weixinBtn setImage:[UIImage imageNamed:@"yx_clk"] forState:0];
        [coverView addSubview:_weixinBtn];
        
        UILabel* line=[[UILabel alloc]initWithFrame:CGRectMake(0, H(49)+H(10), WIDTH, H(1))];
        line.backgroundColor=BGMAINCOLOR;
        [coverView addSubview:line];
        
        UIImageView * zfbImgs=[[UIImageView alloc]initWithFrame:CGRectMake(W(12), H(10)+kDown(line), W(40), H(40))];
        zfbImgs.image=[UIImage imageNamed:@"zfb_icon"];
        [coverView addSubview:zfbImgs];
        
        UILabel * zfbLabels=[[UILabel alloc]initWithFrame:CGRectMake(kRight(zfbImg)+W(20), H(10)+kDown(line), W(70), H(15))];
        zfbLabels.text=@"立即支付";
        zfbLabels.textColor=MAINCHARACTERCOLOR;
        zfbLabels.font=[UIFont systemFontOfSize:14];
        [coverView addSubview:zfbLabels];
        
        UILabel * tuijianLabels=[[UILabel alloc]initWithFrame:CGRectMake(kRight(zfbImg)+W(20), kDown(zfbLabel)+H(10)+kDown(line), W(190), H(15))];
        tuijianLabels.text=@"推荐有支付宝账号的用户使用";
        tuijianLabels.font=[UIFont systemFontOfSize:14];
        tuijianLabels.textColor=GRAYCOLOR;
        [coverView addSubview:tuijianLabels];
        
        //    UIImageView * img=[[UIImageView alloc]initWithFrame:CGRectMake(kRight(tuijianLabel)+W(10), H(2), W(40), H(56))];
        //    img.image=[UIImage imageNamed:@"yx_clk"];
        //    img.contentMode=3;
        //    [coverView addSubview:img];
        
        _zhifubaoBtn = [UIButton buttonWithType:0];
        _zhifubaoBtn.frame=CGRectMake(kRight(tuijianLabel)+W(20), H(10)+kDown(line), W(40), H(40));
        [_zhifubaoBtn addTarget:self action:@selector(chooseZfb) forControlEvents:1<<6];
        [_zhifubaoBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
        [coverView addSubview:_zhifubaoBtn];
        
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(_zhifubaoBtn)+H(10)*2-H(6), WIDTH, H(1))];
        lineLabel.backgroundColor=BGMAINCOLOR;
        [coverView addSubview:lineLabel];
        
        
        UIImageView * outlineImg=[[UIImageView alloc]initWithFrame:CGRectMake(W(12), kDown(lineLabel)+H(10), W(40), H(40))];
        outlineImg.image=[UIImage imageNamed:@"outline_icon"];
        [coverView addSubview:outlineImg];
        
        UILabel * outLineLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(zfbImg)+W(20), kDown(lineLabel)+H(10), W(70), H(15))];
        outLineLabel.text=@"线下支付";
        outLineLabel.textColor=MAINCHARACTERCOLOR;
        outLineLabel.font=[UIFont systemFontOfSize:14];
        [coverView addSubview:outLineLabel];
        
        UILabel * oLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(zfbImg)+W(20), kDown(outLineLabel)+H(10), W(180), H(15))];
        oLabel.text=@"联系后台管理员来完成支付";
        oLabel.font=[UIFont systemFontOfSize:14];
        oLabel.textColor=GRAYCOLOR;
        [coverView addSubview:oLabel];
        
        //    UIImageView * img=[[UIImageView alloc]initWithFrame:CGRectMake(kRight(tuijianLabel)+W(10), H(2), W(40), H(56))];
        //    img.image=[UIImage imageNamed:@"yx_clk"];
        //    img.contentMode=3;
        //    [coverView addSubview:img];
        
        _payinCashBtn = [UIButton buttonWithType:0];
        _payinCashBtn.frame=CGRectMake(kRight(tuijianLabel)+W(20), kDown(lineLabel)+H(10), W(40), H(40));
        [_payinCashBtn addTarget:self action:@selector(chooseOutline) forControlEvents:1<<6];
        [_payinCashBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
        [coverView addSubview:_payinCashBtn];
        
        
        _sureBtn=[UIButton buttonWithType:0];
        _sureBtn.frame=CGRectMake(W(150), kDown(coverView)+18, 20, 20);
//        _sureBtn.layer.borderWidth=1;
//        _sureBtn.layer.cornerRadius=2;
//        _sureBtn.layer.masksToBounds=YES;
        [_sureBtn setBackgroundImage:[UIImage imageNamed:@"uncheck"] forState:0];
        [_sureBtn addTarget:self action:@selector(changeColor) forControlEvents:1<<6];
//        _sureBtn.layer.borderColor=RGBACOLOR(128, 128, 128, 1).CGColor;
        [_scrollerView addSubview:_sureBtn];
        
        UILabel * sureLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_sureBtn)+W(5), kDown(coverView)+18, W(30), 20)];
        sureLabel.text=@"同意";
        sureLabel.textColor=RGBACOLOR(128, 128, 128, 1);
        sureLabel.font=[UIFont systemFontOfSize:14];
        [_scrollerView addSubview:sureLabel];
        
        UIButton * xieyiBtn=[[UIButton alloc]initWithFrame:CGRectMake(kRight(sureLabel), kDown(coverView)+18, W(115), 20)];
        //    xieyiBtn.textColor=RGBACOLOR(251, 73, 8, 1);
        [xieyiBtn setTitle:@"《万商联盟协议》" forState:0];
        [xieyiBtn addTarget:self action:@selector(gotoXieyi) forControlEvents:1<<6];
        xieyiBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [xieyiBtn setTitleColor:RGBACOLOR(251, 73, 8, 1) forState:0];
        //    xieyiBtn.text=@"《万商联盟协议》";
        [_scrollerView addSubview:xieyiBtn];
        
        _accomplishBtn=[UIButton buttonWithType:0];
        _accomplishBtn.layer.cornerRadius=3;
        _accomplishBtn.layer.masksToBounds=YES;
        _accomplishBtn.frame=CGRectMake(W(20), kDown(_sureBtn)+H(30), WIDTH-W(20)*2, 40);
        _accomplishBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
        //    [_accomplishBtn addTarget:self action:@selector(accomplish) forControlEvents:1<<6];
        [_accomplishBtn setTitle:@"完成" forState:0];
        [_accomplishBtn addTarget:self action:@selector(accomplish) forControlEvents:1<<6];
        [_accomplishBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_scrollerView addSubview:_accomplishBtn];
        
        activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
        activityView.rectBackgroundColor=MAINCOLOR;
        activityView.showVC=self;
        [self.view addSubview:activityView];
    }
    

    
}


-(void)gotoXieyi
{
    NSDictionary * param=@{@"requestType":@"1"};
    [RequstEngine requestHttp:@"1044" paramDic:param blockObject:^(NSDictionary *dic) {
        DMLog(@"1044----%@",dic);
        DMLog(@"error----%@",dic[@"errorMsg"]);
        if ([dic[@"errorCode"] intValue]==0) {
            WebViewController *advertringVC=[[WebViewController alloc]init];
            advertringVC.hidesBottomBarWhenPushed=YES;
            //            advertringVC.adModel=model;
            //            advertringVC.add=0;
            advertringVC.content=dic[@"data"][@"content"];
            [self.navigationController pushViewController:advertringVC animated:YES];
        }
    }];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nameArr.count;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LevelTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[LevelTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle=0;
    cell.titleLabel.text=_nameArr[indexPath.row];
    cell.detailTitleLabel.text=[NSString stringWithFormat:@"支付金额: ￥%@",_priceArr[indexPath.row]];
    cell.levelLabel.text=_levelArr[indexPath.row];
    [cell.chooseBtn addTarget:self action:@selector(changeLevel:) forControlEvents:1<<6];
    cell.chooseBtn.tag=indexPath.row;
    if (indexPath.row==_selectRow) {
        [cell.chooseBtn setImage:[UIImage imageNamed:@"yx_clk"] forState:0];
    }
    else
    {
        [cell.chooseBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LevelTableViewCell * cell=[tableView cellForRowAtIndexPath:indexPath];
    _partnerLevel=cell.levelLabel.text;
    _selectRow=indexPath.row;
    _price=_priceArr[indexPath.row];
    [_tableView reloadData];
}
#pragma mark - 按钮绑定的方法
-(void)chooseGold
{
    _choose=1;
    [_goldBtn setImage:[UIImage imageNamed:@"yx_clk"] forState:0];
    [_platinumBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
    [_diamondBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
}

-(void)choosePlatinum
{
    _choose=2;
    [_goldBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
    [_platinumBtn setImage:[UIImage imageNamed:@"yx_clk"] forState:0];
    [_diamondBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
}

-(void)chooseDiamon
{
    _choose=3;
    [_goldBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
    [_platinumBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
    [_diamondBtn setImage:[UIImage imageNamed:@"yx_clk"] forState:0];
}

-(void)changeColor
{
    static int i=0;
    i++;
    if (i%2==1) {
        _isSelect=YES;
        [_sureBtn setBackgroundImage:[UIImage imageNamed:@"checked"] forState:0];
    }
    else
    {
        _isSelect=NO;
        [_sureBtn setBackgroundImage:[UIImage imageNamed:@"uncheck"] forState:0];
    }
    
}

-(void)changeLevel:(UIButton *)sender
{
    _partnerLevel=_levelArr[sender.tag];
    _selectRow=sender.tag;
    _price=_priceArr[sender.tag];
    [_tableView reloadData];
}

-(void)chooseWeixin
{
    _payStyle=0;
    [_weixinBtn setImage:[UIImage imageNamed:@"yx_clk"] forState:0];
    [_zhifubaoBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
    [_payinCashBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
    
}

-(void)chooseOutline
{
    _payStyle=1;
    [_weixinBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
    [_zhifubaoBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
    [_payinCashBtn setImage:[UIImage imageNamed:@"yx_clk"] forState:0];
    
}

-(void)chooseZfb
{
    _payStyle=2;
    [_weixinBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
    [_payinCashBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
    [_zhifubaoBtn setImage:[UIImage imageNamed:@"yx_clk"] forState:0];
    
}


-(void)accomplish
{
//    if (_levelArr.count>0) {
//        _partnerLevel=_levelArr[0];
//    }
//    else
//    {
//        _partnerLevel=@"";
//    }
    _accomplishBtn.enabled=NO;

    [activityView startAnimate];
    if (_isSelect==NO) {
        _accomplishBtn.enabled=YES;
        [activityView stopAnimate];
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请先同意万商联盟协议再付款" buttonTitle:nil];
    }
    else
    {
        if (_payStyle==0) {
            DMLog(@"成为合伙人");
            DMLog(@"---%@,%@,%d,%@",_name,_idcard,_payStyle,_inviteCode);
            if (_whichPage==0)
            {
                NSDictionary * param=@{@"name":_name,@"idcardno":_idcard,@"partnerLevel":_partnerLevel,@"payMethod":[NSString stringWithFormat:@"%d",_payStyle],@"inviteCode":_inviteCode,@"payType":[NSString stringWithFormat:@"%d",_payStyle]};
                [RequstEngine requestHttp:@"1024" paramDic:param blockObject:^(NSDictionary *dic) {
                    DMLog(@"1024--%@",dic);
                    DMLog(@"error---%@",dic[@"errorMsg"]);
                    if ([dic[@"errorCode"] intValue]==00000) {
//                        [activityView stopAnimate];
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
                                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"types"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"page"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"which"];
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
                               
                                //            调用微信
                                [WXApi sendReq:request];
                                
                                DMLog(@"partid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",request.partnerId,request.prepayId,request.nonceStr,(long)request.timeStamp,request.package,request.sign );
//                                NSDictionary * param=@{@"name":_name,@"idcardno":_idcard,@"partnerLevel":_partnerLevel,@"payMethod":[NSString stringWithFormat:@"%d",_payStyle],@"inviteCode":_inviteCode,@"payType":[NSString stringWithFormat:@"%d",_payStyle]};
//                                [RequstEngine requestHttp:@"1024" paramDic:param blockObject:^(NSDictionary *dic) {
//                                    DMLog(@"1024--%@",dic);
//                                    DMLog(@"error---%@",dic[@"errorMsg"]);
//                                    if ([dic[@"errorCode"] intValue]==00000) {
//                                        [[NSUserDefaults standardUserDefaults] setObject:dic[@"orderId"] forKey:@"orderId"];
//                                        [[NSUserDefaults standardUserDefaults] synchronize];
//
//                                    }
//                                }];
                                
                            }
                            else
                            {
                                _accomplishBtn.enabled=YES;
                                [activityView stopAnimate];
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
            else
            {
                NSDictionary * param=@{@"name":_tuiName,@"idcardno":_idNumber,@"partnerLevel":_partnerLevel,@"payMethod":[NSString stringWithFormat:@"%d",_payStyle],@"type":_etype,@"payType":[NSString stringWithFormat:@"%d",_payStyle],@"phone":_phone,@"captcha":@"2",@"loginName":_loginName};
                [RequstEngine requestHttp:@"1028" paramDic:param blockObject:^(NSDictionary *dic) {
                    DMLog(@"1028--%@",dic);
                    if ([dic[@"errorCode"] intValue]==00000) {
//                        [activityView stopAnimate];
//                        [UIAlertView alertWithTitle:@"温馨提示" message:@"提交申请成功，正在等待审核" buttonTitle:nil];
//                        [self.navigationController popToRootViewControllerAnimated:YES];
                        [[NSUserDefaults standardUserDefaults] setObject:dic[@"orderId"] forKey:@"orderId"];
                        [[NSUserDefaults standardUserDefaults] setObject:dic[@"memberId"] forKey:@"memberId"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        NSDictionary * param=@{@"type":@"1",@"orderId":dic[@"orderId"],@"tradeType":@"APP"};
                        [RequstEngine requestHttp:@"1059" paramDic:param blockObject:^(NSDictionary *dic) {
                            DMLog(@"1059---%@",dic);
                            DMLog(@"error---%@",dic[@"errorMsg"]);
                            if ([dic[@"errorCode"] intValue]==00000) {
                                _accomplishBtn.enabled=YES;
                                //发起微信支付，设置参数
                                [activityView stopAnimate];
                                
                                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"type"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"page"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"which"];
                                
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
                                //            调用微信
                                [WXApi sendReq:request];                                
                                
                                DMLog(@"partid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",request.partnerId,request.prepayId,request.nonceStr,(long)request.timeStamp,request.package,request.sign );
                                
                                
                            }
                            else
                            {
                                _accomplishBtn.enabled=YES;
                                [activityView stopAnimate];
                                [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                            }
                            
                        }];
                        
                    }
                    else
                    {
                        _accomplishBtn.enabled=YES;
                        [activityView stopAnimate];
                        [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                    }
                    
                    
                }];
                
            }

        }
        else if(_payStyle==1)
        {
            DMLog(@"线下支付");
            if (_whichPage==0) {
                NSDictionary * param=@{@"name":_name,@"idcardno":_idcard,@"partnerLevel":_partnerLevel,@"payMethod":[NSString stringWithFormat:@"%d",_payStyle],@"inviteCode":_inviteCode,@"payType":[NSString stringWithFormat:@"%d",_payStyle]};
                [RequstEngine requestHttp:@"1024" paramDic:param blockObject:^(NSDictionary *dic) {
                    DMLog(@"1024--%@",dic);
                    DMLog(@"error---%@",dic[@"errorMsg"]);
                    if ([dic[@"errorCode"] intValue]==00000) {
                        [activityView stopAnimate];
                        [UIAlertView alertWithTitle:@"温馨提示" message:@"申请已提交，正在等待审核" buttonTitle:nil];
                        [self.navigationController popToRootViewControllerAnimated:YES];

                        
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
                NSDictionary * param=@{@"name":_tuiName,@"idcardno":_idNumber,@"partnerLevel":_partnerLevel,@"payMethod":[NSString stringWithFormat:@"%d",_payStyle],@"type":_etype,@"payType":[NSString stringWithFormat:@"%d",_payStyle],@"phone":_phone,@"captcha":@"2",@"loginName":_loginName};
                [RequstEngine requestHttp:@"1028" paramDic:param blockObject:^(NSDictionary *dic) {
                    DMLog(@"1028--%@",dic);
                    if ([dic[@"errorCode"] intValue]==00000) {
                        [activityView stopAnimate];
                         _accomplishBtn.enabled=YES;
                        [UIAlertView alertWithTitle:@"温馨提示" message:@"申请已提交，正在等待审核" buttonTitle:nil];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                    else
                    {
                        _accomplishBtn.enabled=YES;
                        [activityView stopAnimate];
                        [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                    }
                    
                    
                }];

            }
           
        }
        else
        {
            // 首页进入
            if (_whichPage==0) {
                NSDictionary * param=@{@"name":_name,@"idcardno":_idcard,@"partnerLevel":_partnerLevel,@"payMethod":@"0",@"inviteCode":_inviteCode,@"payType":[NSString stringWithFormat:@"%d",_payStyle]};
                [RequstEngine requestHttp:@"1024" paramDic:param blockObject:^(NSDictionary *dic) {
                    DMLog(@"1024--%@",dic);
                    DMLog(@"error---%@",dic[@"errorMsg"]);
                    if ([dic[@"errorCode"] intValue]==00000) {
                        [activityView stopAnimate];
                        _accomplishBtn.enabled=YES;
                        
                        NSString * orderString=dic[@"param"][@"paramStr"];
                        NSString * appScheme = @"eShangBao";
                        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                            if ([resultDic[@"resultStatus"] intValue]==9000) {
                                
                                [self.navigationController popToRootViewControllerAnimated:YES];
//                                [UIAlertView alertWithTitle:@"温馨提示" message:@"订单支付成功" buttonTitle:nil];
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
//                        order.tradeNO = dic[@"orderId"]; //订单ID(由商家□自□行制定)
//                        order.productName = @"余额充值"; //商品标题
//                        order.productDescription = @"充值"; //商品描述
////                        order.amount =@"0.01";  //商 品价格
//                        order.amount=_price;
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
//                                    NSDictionary * param=@{@"type":@"1",@"orderId":dic[@"orderId"]};
//                                    [RequstEngine requestHttp:@"1026" paramDic:param blockObject:^(NSDictionary *dic) {
//                                        DMLog(@"1026---%@",dic);
//                                        DMLog(@"error---%@",dic[@"errorMsg"]);
//                                        if ([dic[@"errorCode"] intValue]==00000) {
//                                            [self.navigationController popToRootViewControllerAnimated:YES];
//                                        }
//                                        else
//                                        {
//                                            [[NSNotificationCenter defaultCenter]postNotificationName:@"cleanMsg" object:nil];
//                                            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
//                                            
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
                        _accomplishBtn.enabled=YES;
                        [activityView stopAnimate];
                        [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                    }
                    
                    
                }];
                
            }
            else
            {
                // 推荐合伙人
                NSDictionary * param=@{@"name":_tuiName,@"idcardno":_idNumber,@"partnerLevel":_partnerLevel,@"payMethod":@"0",@"type":_etype,@"payType":[NSString stringWithFormat:@"%d",_payStyle],@"phone":_phone,@"captcha":@"2",@"loginName":_loginName};
                [RequstEngine requestHttp:@"1028" paramDic:param blockObject:^(NSDictionary *dics) {
                    DMLog(@"1028--%@",dics);
                    DMLog(@"error----%@",dics[@"errorMsg"]);
                    if ([dics[@"errorCode"] intValue]==00000) {
                        [activityView stopAnimate];
                        _accomplishBtn.enabled=YES;
                        
                        NSString * orderString=dics[@"param"][@"paramStr"];
                        NSString * appScheme = @"eShangBao";
                        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                            if ([resultDic[@"resultStatus"] intValue]==9000) {
                                
                                [self.navigationController popToRootViewControllerAnimated:YES];
//                                [UIAlertView alertWithTitle:@"温馨提示" message:@"订单支付成功" buttonTitle:nil];
                            }
                            else
                            {
                                [UIAlertView alertWithTitle:@"温馨提示" message:@"订单支付失败" buttonTitle:nil];
                            }
                            
                            
                        }];

//                        [[NSUserDefaults standardUserDefaults] setObject:dics[@"orderId"] forKey:@"orderId"];
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
//                        order.tradeNO = dics[@"orderId"]; //订单ID(由商家□自□行制定)
//                        order.productName = @"余额充值"; //商品标题
//                        order.productDescription = @"充值"; //商品描述
////                        order.amount =@"0.01";  //商 品价格
//                        order.amount = _price;
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
//                                    NSDictionary * param=@{@"memberId":USERID,@"orderId":dics[@"orderId"]};
//                                    [RequstEngine requestHttp:@"1029" paramDic:param blockObject:^(NSDictionary *dic) {
//                                        DMLog(@"1026---%@",dic);
//                                        DMLog(@"error---%@",dic[@"errorMsg"]);
//                                        if ([dic[@"errorCode"] intValue]==00000) {
//                                            [self.navigationController popToRootViewControllerAnimated:YES];
//                                        }
//                                        else
//                                        {
//                                            [[NSNotificationCenter defaultCenter]postNotificationName:@"cleanMsg" object:nil];
//                                            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
//                                            
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
                        _accomplishBtn.enabled=YES;
                        [activityView stopAnimate];
                        [UIAlertView alertWithTitle:@"温馨提示" message:dics[@"errorMsg"] buttonTitle:nil];
                    }
                    
                    
                }];

            }

        }
       
    }
    
}

-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                DMLog(@"支付成功");
                break;
            default:
                DMLog(@"支付失败");
                break;
        }
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
