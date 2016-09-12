//
//  BusinessViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/20.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "BusinessViewController.h"
#import "MyIncomeViewController.h"
#import "ManageOrderViewController.h"
#import "ManageGoodsViewController.h"
#import "AddGoodsViewController.h"
#import "MyIncomeViewController.h"
#import "ManageStoreViewController.h"
#import "LockVIPViewController.h"
#import "CashierViewController.h"
#import "MyVIPViewController.h"
@interface BusinessViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSArray  * _imgArr;
    NSString * _remainAccount;//账户余额
    NSString * _monthOrderNum;//月销售量
    NSString * _totalGoldRecept;//通宝币总收入
    NSString * _totalAccount;//总计现金收入
    
    NSString * _shopName;
    NSString * _inviteCode;
    NSString * _returnGoldRate;
    NSString * _shopId;
    NSString * _availableRemainAccount;
    
    BOOL     isSuccess;
    
    TBActivityView *activityView;
}

@end

@implementation BusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    isSuccess=NO;
//    _useType=@"3";
    _totalAccount=@"0";
    self.title=@"我是商家";
    self.view.backgroundColor=BGMAINCOLOR;
    self.fd_prefersNavigationBarHidden=YES;
//    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, H(140)+64) style:0];
//    _tableView.delegate=self;
//    _tableView.dataSource=self;
//    _tableView.separatorStyle=0;
//    _tableView.scrollEnabled=NO;
//    [self.view addSubview:_tableView];
    
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    
    [activityView startAnimate];
    // 加载UI
    [self loadUI];
    
    [self merchatList];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - loadUI
-(void)loadUI
{
    UIView * backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, H(260))];
    [self.view addSubview:backView];
    
    UIImageView * backImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, H(260))];
    backImg.backgroundColor=MAINCOLOR;
    backImg.image=[UIImage imageNamed:@"矩形-2"];
    [backView addSubview:backImg];
    
    UIButton * backBtn=[UIButton buttonWithType:0];
    backBtn.frame=CGRectMake(20, 30, 8, 16);
    [backBtn setImage:[UIImage imageNamed:@"返回_03"] forState:0];
    [backBtn addTarget:self action:@selector(backToLast) forControlEvents:1<<6];
    [backView addSubview:backBtn];
    
    UILabel * titleLabel=[[UILabel alloc]init];
    titleLabel.center=CGPointMake(WIDTH/2, 40);
    titleLabel.bounds=CGRectMake(0, 0, 70, 20);
    titleLabel.text=@"我是商家";
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=[UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [backView addSubview:titleLabel];
    
//    UIImageView * roundImg=[[UIImageView alloc]init];
//    roundImg.center=CGPointMake(WIDTH/2, 27);
//    roundImg.bounds=CGRectMake(0, 0, <#CGFloat width#>, <#CGFloat height#>)
    
    UILabel * clickLabel=[[UILabel alloc]init];
    clickLabel.center=CGPointMake(WIDTH/2, kDown(titleLabel)+H(48));
    clickLabel.bounds=CGRectMake(0, 0, 100, 15);
    clickLabel.font=[UIFont systemFontOfSize:12];
    clickLabel.text=@"可提金额(元)";
    clickLabel.textAlignment=NSTextAlignmentCenter;
    clickLabel.textColor=RGBACOLOR(255, 255, 255, 0.7);
    [backView addSubview:clickLabel];
    
    _withdrawMoneyLabel=[[UILabel alloc]init];
    _withdrawMoneyLabel.center=CGPointMake(WIDTH/2, kDown(clickLabel)+H(30));
    _withdrawMoneyLabel.bounds=CGRectMake(0, 0, WIDTH, 35);
    _withdrawMoneyLabel.font=[UIFont systemFontOfSize:30];
    _withdrawMoneyLabel.text=@"1000";
    _withdrawMoneyLabel.textAlignment=NSTextAlignmentCenter;
    _withdrawMoneyLabel.textColor=[UIColor whiteColor];
    [backView addSubview:_withdrawMoneyLabel];

//    UILabel * withdrawTitleLabel=[[UILabel alloc]init];
//    withdrawTitleLabel.center=CGPointMake(WIDTH/2, kDown(_withdrawMoneyLabel)+10);
//    withdrawTitleLabel.bounds=CGRectMake(0, 0, 100, 15);
//    withdrawTitleLabel.font=[UIFont systemFontOfSize:14];
//    withdrawTitleLabel.text=@"可提金额(元)";
//    withdrawTitleLabel.textAlignment=NSTextAlignmentCenter;
//    withdrawTitleLabel.textColor=RGBACOLOR(255, 255, 255, 0.7);
//    [backView addSubview:withdrawTitleLabel];
    
//    UIView * jumpView=[[UIView alloc]initWithFrame:CGRectMake(95, 80, WIDTH-95*2, 80)];
////    jumpView.backgroundColor=[UIColor cyanColor];
//    [backView addSubview:jumpView];
    
    _jumpBtn=[UIButton buttonWithType:0];
    _jumpBtn.frame=CGRectMake(95, 80, WIDTH-95*2, 80);
//    _jumpBtn.backgroundColor=[UIColor redColor];
    [_jumpBtn addTarget:self action:@selector(jumpToOthers) forControlEvents:1<<6];
    [backView addSubview:_jumpBtn];
    
    UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(0, H(180), WIDTH, H(260)-H(180))];
//    coverView.backgroundColor=[UIColor whiteColor];
    [backView addSubview:coverView];
    
    UILabel * zhetitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(10), WIDTH/3., H(20))];
    zhetitleLabel.textAlignment=NSTextAlignmentCenter;
    zhetitleLabel.text=@"折前金额";
    //    incomeLabel.backgroundColor=[UIColor cyanColor];
    zhetitleLabel.textColor=[UIColor whiteColor];
    zhetitleLabel.alpha=0.7;
    zhetitleLabel.font=[UIFont systemFontOfSize:12];
    [coverView addSubview:zhetitleLabel];
    
    _zheqianLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(zhetitleLabel)+H(10), WIDTH/3., H(20))];
    _zheqianLabel.text=@"0.00";
    _zheqianLabel.textColor=[UIColor whiteColor];
    //    _moneyLabel.backgroundColor=[UIColor cyanColor];
    _zheqianLabel.textAlignment=NSTextAlignmentCenter;
    _zheqianLabel.font=[UIFont boldSystemFontOfSize:16];
    [coverView addSubview:_zheqianLabel];
    
    UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/3.-W(1), H(15), W(1), H(10))];
    lineLabel.backgroundColor=RGBACOLOR(255, 255, 255, 0.7);
    [coverView addSubview:lineLabel];
    
    UILabel * incomeLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/3.-W(1), H(10), WIDTH/3., H(20))];
    incomeLabel.textAlignment=NSTextAlignmentCenter;
    incomeLabel.text=@"累计收入";
//    incomeLabel.backgroundColor=[UIColor cyanColor];
    incomeLabel.textColor=RGBACOLOR(255, 255, 255, 0.7);
    incomeLabel.font=[UIFont systemFontOfSize:12];
    [coverView addSubview:incomeLabel];
    
    _moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/3.-W(1), kDown(incomeLabel)+H(10), WIDTH/3., H(20))];
    _moneyLabel.text=@"0.00";
    _moneyLabel.textColor=[UIColor whiteColor];
    //    _moneyLabel.backgroundColor=[UIColor cyanColor];
    _moneyLabel.textAlignment=NSTextAlignmentCenter;
    _moneyLabel.font=[UIFont boldSystemFontOfSize:16];
    [coverView addSubview:_moneyLabel];
    
    UILabel * lineLabel1=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/3.*2-W(1), H(15), W(1), H(10))];
    lineLabel1.backgroundColor=RGBACOLOR(255, 255, 255, 0.7);
    [coverView addSubview:lineLabel1];

    UILabel * sellLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/3*2-W(1), H(10), WIDTH/3., H(20))];
    sellLabel.text=@"本月销量";
    sellLabel.textAlignment=NSTextAlignmentCenter;
    sellLabel.font=[UIFont systemFontOfSize:12];
    sellLabel.textColor=RGBACOLOR(255, 255, 255, 0.7);
    [coverView addSubview:sellLabel];
    
    
    _countLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/3*2-W(1), kDown(sellLabel)+H(10), WIDTH/3., H(20))];
    _countLabel.textColor=[UIColor whiteColor];
    _countLabel.textAlignment=NSTextAlignmentCenter;
    _countLabel.text=@"0单";
    _countLabel.font=[UIFont boldSystemFontOfSize:16];
    [coverView addSubview:_countLabel];
//    UILabel * lineLabel1=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/3*2-W(1), H(10), W(1), H(20)*2+H(10))];
//    lineLabel1.backgroundColor=BGMAINCOLOR;
//    [coverView addSubview:lineLabel1];

//    _constumeLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_countLabel), H(10), WIDTH/3, H(20))];
//    _constumeLabel.textColor=RGBACOLOR(80, 80, 80, 1);
//    _constumeLabel.textAlignment=NSTextAlignmentCenter;
//    _constumeLabel.text=@"0";
//    _constumeLabel.font=[UIFont boldSystemFontOfSize:16];
//    [coverView addSubview:_constumeLabel];
    
//    UILabel * conLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(sellLabel), kDown(_constumeLabel)+H(10), WIDTH/3, H(20))];
//    conLabel.text=@"通宝币收入";
//    conLabel.textAlignment=NSTextAlignmentCenter;
//    conLabel.font=[UIFont systemFontOfSize:12];
//    conLabel.textColor=RGBACOLOR(128, 128, 128, 1);
//    [coverView addSubview:conLabel];
    
//    UIView * backView=[[UIView alloc]initWithFrame:CGRectMake( 0, kDown(coverView)+H(5), WIDTH, H(60))];
//    backView.backgroundColor=[UIColor whiteColor];
//    [self.view addSubview:backView];
//    
//    UIImageView * addImg=[[UIImageView alloc]initWithFrame:CGRectMake(W(110), H(20), H(20), H(20))];
//    addImg.image=[UIImage imageNamed:@"添加_blue"];
//    addImg.contentMode=2;
//    addImg.layer.masksToBounds=YES;
//    [backView addSubview:addImg];
//    
//    UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(addImg)+W(10), H(20), W(80), H(20))];
//    titleLabel.text=@"添加商品";
//    titleLabel.textColor=RGBACOLOR(0, 126, 255, 1);
//    titleLabel.font=[UIFont systemFontOfSize:16];
////    titleLabel.textColor=RGBACOLOR(80, 80, 80, 1);
//    [backView addSubview:titleLabel];
//    
//    UIButton * addBtn=[[UIButton alloc]initWithFrame:CGRectMake(W(110), 0, W(20)+W(10)+W(80), H(30))];
////    addBtn.backgroundColor=[UIColor cyanColor];
//    [addBtn addTarget:self action:@selector(addMsg:) forControlEvents:1<<6];
//    [backView addSubview:addBtn];
    
    
    
    NSArray * titleArr;
    if ([_useType intValue]==2&&[_isShop intValue]==0) {
        titleArr=@[@"店铺管理",@"订单管理"];
        _imgArr=@[@"店铺管理",@"订单管理"];
//        addBtn.enabled=YES;
//        addImg.image=[UIImage imageNamed:@"添加_blue"];
//        titleLabel.textColor=RGBACOLOR(0, 126, 255, 1);
    }
    if ([_useType intValue]!=2&&[_isShop intValue]==1)
    {
//        addBtn.enabled=NO;
//        addImg.image=[UIImage imageNamed:@"添加_gray"];
//        titleLabel.textColor=RGBACOLOR(173, 173, 173, 1);
        titleArr=@[@"店铺管理",@"订单管理",@"收银台",@"我的会员"];
        _imgArr=@[@"店铺管理",@"订单管理",@"playMoney_icon",@"lockVip_icon-1"];
    }
    if (([_useType intValue]==2&&[_partnerAgencyPayStatus intValue]==0)&&[_isShop intValue]==1) {
//        addBtn.enabled=NO;
//        addImg.image=[UIImage imageNamed:@"添加_gray"];
//        titleLabel.textColor=RGBACOLOR(173, 173, 173, 1);
        titleArr=@[@"店铺管理",@"订单管理",@"收银台",@"我的会员"];
        _imgArr=@[@"店铺管理",@"订单管理",@"playMoney_icon",@"lockVip_icon-1"];
    }

    if (([_useType intValue]==2&&[_partnerAgencyPayStatus intValue]==1)&&[_isShop intValue]==1) {
        titleArr=@[@"店铺管理",@"订单管理",@"收银台",@"我的会员"];
        _imgArr=@[@"店铺管理",@"订单管理",@"playMoney_icon",@"lockVip_icon-1"];
//        addBtn.enabled=YES;
//        addImg.image=[UIImage imageNamed:@"添加_blue"];
//        titleLabel.textColor=RGBACOLOR(0, 126, 255, 1);
    }
    
    
    
//    if ([_useType intValue]==2) {
//        titleArr=@[@"店铺管理",@"商品管理",@"订单管理"];
//        _imgArr=@[@"店铺管理",@"商品管理",@"订单管理"];
//        addBtn.enabled=YES;
//        addImg.image=[UIImage imageNamed:@"添加_blue"];
//        titleLabel.textColor=RGBACOLOR(0, 126, 255, 1);
////        backView.hidden=NO;
//    }
//    if ([_useType intValue]==3)
//    {
////        backView.hidden=YES;
//        addBtn.enabled=NO;
//        addImg.image=[UIImage imageNamed:@"添加_gray"];
//        titleLabel.textColor=RGBACOLOR(173, 173, 173, 1);
//        titleArr=@[@"店铺管理",@"订单管理",@"锁定会员",@"收银台"];
//        _imgArr=@[@"店铺管理",@"订单管理",@"lockVip_icon-1",@"playMoney_icon"];
//    }
//    if ([_useType intValue]==4) {
//        titleArr=@[@"店铺管理",@"商品管理",@"订单管理",@"锁定会员",@"收银台"];
//        _imgArr=@[@"店铺管理",@"商品管理",@"订单管理",@"lockVip_icon-1",@"playMoney_icon"];
////        backView.hidden=NO;
//        addBtn.enabled=YES;
//        addImg.image=[UIImage imageNamed:@"添加_blue"];
//        titleLabel.textColor=RGBACOLOR(0, 126, 255, 1);
//    }

    
    
    UIView * view=[[UIView alloc]init];
    view.frame=CGRectMake(0, kDown(coverView), WIDTH, HEIGHT-H(140)-H(120));
//    if (titleArr.count>3) {
//        if ([_useType intValue]!=2&&[_isShop intValue]==1)
//        {
//            view.frame=CGRectMake(0, kDown(coverView)+H(5), WIDTH, H(85)*2+HEIGHT-H(140)-H(80)-H(120)-H(85));
//        }
//        else
//        {
//            view.frame=CGRectMake(0, kDown(backView)+H(5), WIDTH, H(85)*2+HEIGHT-H(140)-H(80)-H(120)-H(85));
//        }
//        
////        if ([_useType intValue]==3) {
////            view.frame=CGRectMake(0, kDown(coverView)+H(5), WIDTH, H(85)*2);
////        }
////        else
////        {
////            view.frame=CGRectMake(0, kDown(coverView)+H(5), WIDTH, H(85)*2);
////        }
//
//    }
//    else
//    {
//        if ([_useType intValue]!=2&&[_isShop intValue]==1)
//        {
//            view.frame=CGRectMake(0, kDown(coverView)+H(5), WIDTH, H(85)+HEIGHT-H(140)-H(80)-H(120)-H(85));
//        }
//        else
//        {
//            view.frame=CGRectMake(0, kDown(backView)+H(5), WIDTH, H(85)+HEIGHT-H(140)-H(80)-H(120)-H(85));
//        }
//        
////        
////        if ([_useType intValue]==3) {
////            view.frame=CGRectMake(0, kDown(coverView)+H(5), WIDTH, H(85));
////        }
////        else
////        {
////            view.frame=CGRectMake(0, kDown(coverView)+H(5), WIDTH, H(85));
////        }
//        
//    }
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];

   
    
    for (int i=0; i<titleArr.count; i++) {
//        for (int j=0; j<2; j++) {
        UIButton * manageBtn=[UIButton buttonWithType:0];
        manageBtn.frame=CGRectMake(W(12)+W(110)*(i%3), (i/3)*H(100), W(70), H(80));
//         manageBtn.backgroundColor=[UIColor cyanColor];
        [manageBtn addTarget:self action:@selector(manageOrder:) forControlEvents:1<<6];
        manageBtn.tag=i;
        [manageBtn setImage:[UIImage imageNamed:_imgArr[i]] forState:0];
        [view addSubview:manageBtn];
        
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(W(12)+W(110)*(i%3), (i/3)*H(100)+H(65), W(70), H(20))];
        label.text=titleArr[i];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:12];
//        label.backgroundColor=[UIColor cyanColor];
        label.textColor=MAINCHARACTERCOLOR;
        [view addSubview:label];
//        }
    }
    
//    UIImageView * adImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, kDown(view)+H(5), WIDTH, HEIGHT-H(80)-H(30)-H(165)-64-H(5)*6)];
//    adImg.image=[UIImage imageNamed:@"free_banner.jpg"];
////    adImg.contentMode=2;
//    addImg.layer.masksToBounds=YES;
//    [self.view addSubview:adImg];
}

-(void)backToLast
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)jumpToOthers
{
    if (isSuccess==YES) {
        MyIncomeViewController * incomeVC=[[MyIncomeViewController alloc]init];
        incomeVC.returnBate=_returnGoldRate;
        [self.navigationController pushViewController:incomeVC animated:YES];
    }
    else
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"网络异常，请检查后重试" buttonTitle:nil];
    }

}


-(void)merchatList
{
    NSDictionary * param=@{@"shopId":USERID};
    [RequstEngine requestHttp:@"1012" paramDic:param blockObject:^(NSDictionary *dic) {
        DMLog(@"1012---%@",dic);
        DMLog(@"error----%@",dic[@"errorMsg"]);
        if ([dic[@"errorCode"] intValue]==0) {
            
            [activityView stopAnimate];
            isSuccess=YES;
            
            _totalAccount=dic[@"shop"][@"totalAccount"];
            _remainAccount=dic[@"shop"][@"remainAccount"];
            _monthOrderNum=dic[@"shop"][@"monthOrderNum"];
//            _totalAccount=dic[@"shop"][@"totalGoldRecept"];
            _returnGoldRate=dic[@"shop"][@"returnGoldRate"];
            _availableRemainAccount=dic[@"shop"][@"availableRemainAccount"];
//            if (_remainAccount.length==0) {
//                _moneyLabel.text
//            }
            _moneyLabel.text=[NSString stringWithFormat:@"%.2f",[dic[@"shop"][@"totalAccount"] floatValue]];
            _countLabel.text=[NSString stringWithFormat:@"%@单",dic[@"shop"][@"monthOrderNum"]];
            _zheqianLabel.text=[NSString stringWithFormat:@"%.2f",[dic[@"shop"][@"remainAccount"] floatValue]];
            _withdrawMoneyLabel.text=[NSString stringWithFormat:@"%.2f",[dic[@"shop"][@"availableRemainAccount"] floatValue]];
            _shopName=dic[@"shop"][@"shopName"];
            _inviteCode=dic[@"shop"][@"inviteCode"];
            _shopId=dic[@"shop"][@"shopId"];
        }
        
        else
        {
            [activityView stopAnimate];
        }
        
        [_tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:3 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text=@"可提现余额";
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    
    cell.detailTextLabel.text=[NSString stringWithFormat:@"￥%.2f",[_availableRemainAccount floatValue]];
    cell.detailTextLabel.textColor=RGBACOLOR(255, 97, 0, 1);
    cell.detailTextLabel.font=[UIFont boldSystemFontOfSize:24];
    cell.selectionStyle=0;
    cell.accessoryType=1;
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return H(140);
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    
//}
#pragma mark - 按钮绑定的方法
-(void)addMsg:(UIButton *)sender
{
    DMLog(@"添加商品");
    AddGoodsViewController * addGoodsVC=[[AddGoodsViewController alloc]init];
    [self.navigationController pushViewController:addGoodsVC animated:YES];
}

-(void)manageOrder:(UIButton*)sender
{
    if ([_useType intValue]==2&&[_isShop intValue]==0) {
        switch (sender.tag) {
            case 0:
                DMLog(@"店铺管理");
            {
                ManageStoreViewController * manageVC=[[ManageStoreViewController alloc]init];
                manageVC.isShop=_isShop;
                [self.navigationController pushViewController:manageVC animated:YES];
            }
                break;
                
//            case 1:
//                DMLog(@"商品管理");
//            {
//                ManageGoodsViewController * goodsVC=[[ManageGoodsViewController alloc]init];
//                [self.navigationController pushViewController:goodsVC animated:YES];
//            }
//                break;
                
            case 1:
                DMLog(@"订单管理");
            {
                ManageOrderViewController * manageVC=[[ManageOrderViewController alloc]init];
                [self.navigationController pushViewController:manageVC animated:YES];
            }
                break;

            default:
                break;
        }

    }
    if ([_useType intValue]!=2&&[_isShop intValue]==1) {
        switch (sender.tag) {
            case 0:
                DMLog(@"店铺管理");
            {
                ManageStoreViewController * manageVC=[[ManageStoreViewController alloc]init];
                manageVC.isShop = _isShop;
                [self.navigationController pushViewController:manageVC animated:YES];
            }
                break;
                
            case 1:
                DMLog(@"订单管理");
            {
                ManageOrderViewController * goodsVC=[[ManageOrderViewController alloc]init];
                [self.navigationController pushViewController:goodsVC animated:YES];
            }
                break;
                
//            case 3:
//                DMLog(@"锁定会员");
//            {
//                LockVIPViewController * manageVC=[[LockVIPViewController alloc]init];
//                [self.navigationController pushViewController:manageVC animated:YES];
//            }
//                break;
            case 2:
                DMLog(@"收银台");
            {
                if (_shopId.length==0||_inviteCode.length==0||_shopName.length==0) {
                    [UIAlertView alertWithTitle:@"温馨提示" message:@"网络状况不佳，请返回后刷新重试" buttonTitle:nil];
                    return;
                }
                CashierViewController * cashierVC=[[CashierViewController alloc]init];
                cashierVC.shopName=_shopName;
                cashierVC.inviteCode=_inviteCode;
                cashierVC.returnGoldRate=_returnGoldRate;
                cashierVC.shopId=_shopId;
                [self.navigationController pushViewController:cashierVC animated:YES];
            }
                break;
            case 3:
            {
                MyVIPViewController * myVC=[[MyVIPViewController alloc]init];
                myVC.shopId=_shopId;
                [self.navigationController pushViewController:myVC animated:YES];
            }
                
                break;
            default:
                break;
        }

    }
    if (([_useType intValue]==2&&[_partnerAgencyPayStatus intValue]==0)&&[_isShop intValue]==1) {
        switch (sender.tag) {
            case 0:
                DMLog(@"店铺管理");
            {
                ManageStoreViewController * manageVC=[[ManageStoreViewController alloc]init];
                manageVC.isShop = _isShop;
                [self.navigationController pushViewController:manageVC animated:YES];
            }
                break;
                
            case 1:
                DMLog(@"订单管理");
            {
                ManageOrderViewController * manageVC=[[ManageOrderViewController alloc]init];
                [self.navigationController pushViewController:manageVC animated:YES];
            }
                break;
                //            case 4:
                //                DMLog(@"锁定会员");
                //            {
                //                LockVIPViewController * manageVC=[[LockVIPViewController alloc]init];
                //                [self.navigationController pushViewController:manageVC animated:YES];
                //            }
                //
                //                break;
                
            case 2:
                DMLog(@"收银台");
            {
                if (_shopId.length==0||_inviteCode.length==0||_shopName.length==0) {
                    [UIAlertView alertWithTitle:@"温馨提示" message:@"网络状况不佳，请返回后刷新重试" buttonTitle:nil];
                    return;
                }
                CashierViewController * cashierVC=[[CashierViewController alloc]init];
                cashierVC.shopName=_shopName;
                cashierVC.inviteCode=_inviteCode;
                cashierVC.returnGoldRate=_returnGoldRate;
                cashierVC.shopId=_shopId;
                [self.navigationController pushViewController:cashierVC animated:YES];
            }
                
                break;
                
            case 3:
            {
                MyVIPViewController * myVC=[[MyVIPViewController alloc]init];
                myVC.shopId=_shopId;
                [self.navigationController pushViewController:myVC animated:YES];
            }
                
                break;
            default:
                break;
        }

    }
    if (([_useType intValue]==2&&[_partnerAgencyPayStatus intValue]==1)&&[_isShop intValue]==1) {
        switch (sender.tag) {
            case 0:
                DMLog(@"店铺管理");
            {
                ManageStoreViewController * manageVC=[[ManageStoreViewController alloc]init];
                manageVC.isShop = _isShop;
                [self.navigationController pushViewController:manageVC animated:YES];
            }
                break;
                
//            case 1:
//                DMLog(@"商品管理");
//            {
//                ManageGoodsViewController * goodsVC=[[ManageGoodsViewController alloc]init];
//                [self.navigationController pushViewController:goodsVC animated:YES];
//            }
//                break;
                
            case 1:
                DMLog(@"订单管理");
            {
                ManageOrderViewController * manageVC=[[ManageOrderViewController alloc]init];
                [self.navigationController pushViewController:manageVC animated:YES];
            }
                break;
//            case 4:
//                DMLog(@"锁定会员");
//            {
//                LockVIPViewController * manageVC=[[LockVIPViewController alloc]init];
//                [self.navigationController pushViewController:manageVC animated:YES];
//            }
//
//                break;
                
            case 2:
                DMLog(@"收银台");
            {
                
                if (_shopId.length==0||_inviteCode.length==0||_shopName.length==0) {
                    [UIAlertView alertWithTitle:@"温馨提示" message:@"网络状况不佳，请返回后刷新重试" buttonTitle:nil];
                    return;
                }
                CashierViewController * cashierVC=[[CashierViewController alloc]init];
                cashierVC.shopName=_shopName;
                cashierVC.inviteCode=_inviteCode;
                cashierVC.returnGoldRate=_returnGoldRate;
                cashierVC.shopId=_shopId;
                [self.navigationController pushViewController:cashierVC animated:YES];
            }
                
                break;
            case 3:
            {
                MyVIPViewController * myVC=[[MyVIPViewController alloc]init];
                myVC.shopId=_shopId;
                [self.navigationController pushViewController:myVC animated:YES];
            }
                break;
            default:
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
