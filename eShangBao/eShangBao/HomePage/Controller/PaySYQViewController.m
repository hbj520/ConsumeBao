//
//  PaySYQViewController.m
//  eShangBao
//
//  Created by doumee on 16/7/5.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "PaySYQViewController.h"

@interface PaySYQViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    NSArray     * _titleArr;
    NSString    * _bankName;
    NSString    * _bankNO;
    NSString    * _weixin;
    NSString    * _alipay;
    NSString    * _contact;
    
    NSString    * _bankUserName;
    NSString    * _alipayUserName;
    NSString    * _weixinUserName;
}

@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,strong)UILabel        * helpLabel;

@end

@implementation PaySYQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBACOLOR(250, 251, 252, 1);
    self.title=@"支付";
    [self backButton];
    
    _bankNO=@"";
    _bankName=@"";
    _alipay=@"";
    _weixin=@"";
    _bankUserName=@"";
    _alipayUserName=@"";
    _titleArr=@[@"开户行",@"卡号",@"支付宝(推荐)",@"账号",@"微信",@"账号1"];
    _dataArr=[NSMutableArray arrayWithCapacity:0];
    [self loadUI];
    [self getMsg];
    [self createAlertView];
    // Do any additional setup after loading the view.
}

-(void)createAlertView
{
    
    
    _bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _bgView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_bgView];
    
    UIImageView *bgImageView=[[UIImageView alloc]initWithFrame:_bgView.bounds];
    bgImageView.backgroundColor=[UIColor blackColor];
    bgImageView.alpha=0.5;
    [_bgView addSubview:bgImageView];
    
    UIView *alertView=[[UIAlertView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth-80, 100)];
    alertView.backgroundColor=[UIColor whiteColor];
    alertView.layer.cornerRadius=5;
    alertView.layer.masksToBounds=YES;
    alertView.center=CGPointMake(KScreenWidth/2., KScreenHeight/2.);
    [_bgView addSubview:alertView];
    
    
    NSString *labelStr=[NSString stringWithFormat:@"您已经成功申请认购%@份收益权，稍后会有客服和您联系，您也可主动联系客服完成支付操作,尽快享受收益权分红",_rgNum];
    //float strH=[NSString calculatemySizeWithFont:14. Text:labelStr width:KScreenWidth-110];
    
    UILabel *alertLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenWidth-110, 100)];
    alertLabel.font=[UIFont systemFontOfSize:14.];
    alertLabel.numberOfLines=0;
    alertLabel.textAlignment=0;
    alertLabel.textColor=MAINCHARACTERCOLOR;
    alertLabel.text=labelStr;
    [alertView addSubview:alertLabel];
    
    UIButton *delegateButton=[UIButton buttonWithType:0];
    [delegateButton setBackgroundImage:[UIImage imageNamed:@"登录1_06"] forState:0];
    delegateButton.frame=CGRectMake(CGRectGetMaxX(alertView.frame)-35, CGRectGetMinY(alertView.frame)-35, 30, 30);
    [delegateButton addTarget:self action:@selector(delegateButtonClick) forControlEvents:1<<6];
    [_bgView addSubview:delegateButton];

}

-(void)delegateButtonClick
{
    [_bgView removeFromSuperview];
}


-(void)getMsg
{

    [RequstEngine requestHttp:@"1088" paramDic:nil blockObject:^(NSDictionary *dic) {
        DMLog(@"1088---%@",dic);
        if ([dic[@"errorCode"] intValue]==0) {
            _bankName=dic[@"record"][@"bankName"];
            _bankNO=dic[@"record"][@"bankNo"];
            _weixin=dic[@"record"][@"weixinNo"];
            _alipay=dic[@"record"][@"alipayNo"];
            _bankUserName=dic[@"record"][@"bankPN"];
            _alipayUserName=dic[@"record"][@"alipayPN"];
            _dataArr=[NSMutableArray arrayWithObjects:_bankName,_bankNO,@"",_weixin,@"",_alipay, nil];
            _helpLabel.text=[NSString stringWithFormat:@"如需要帮助或有疑问，欢迎致电%@",dic[@"record"][@"linkPhone"]];
            [_tableView reloadData];
            
        }
        else
        {
            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
        }
    }];
    
}
-(void)loadUI
{
    UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 65)];
    coverView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:coverView];
    
    UILabel * btLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 5, WIDTH-2*15, 50)];
    btLabel.text=[NSString stringWithFormat:@"恭喜您成功认购%d份收益权。为了您尽早享受收益权分红，请尽快付款。",[_rgNum intValue]];
    btLabel.textColor=MAINCHARACTERCOLOR;
    btLabel.font=[UIFont systemFontOfSize:14];
    btLabel.numberOfLines=0;
    [coverView addSubview:btLabel];
    
    UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, kDown(coverView)+12, 200, 20)];
    titleLabel.text=@"账号信息";
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.textColor=RGBACOLOR(172, 172, 172, 1);
    [self.view addSubview:titleLabel];

    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, kDown(titleLabel)+10, WIDTH, KScreenHeight-180) style:0];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=0;
    //_tableView.scrollEnabled=NO;
    _tableView.rowHeight=40;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _helpLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, kDown(_tableView)+10, WIDTH-12*2, 40)];
    _helpLabel.textColor=RGBACOLOR(172, 172, 172, 1);
    _helpLabel.font=[UIFont systemFontOfSize:14];
    _helpLabel.text=@"如需要帮助或有疑问，欢迎致电";
    _tableView.tableFooterView=_helpLabel;
    
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    else
    {
        return 10;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section==0) {
//        return 3;
//    }
//    else
//    {
//        return 2;
//    }
//    return _dataArr.count;
    
    return 3;
}


-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"systemCell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"systemCell"];
    }
    
    
    cell.selectionStyle=0;
//    cell.textLabel.text=_titleArr[indexPath.section][indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    cell.textLabel.textColor=MAINCHARACTERCOLOR;
    
//    cell.detailTextLabel.text=_dataArr[indexPath.section][indexPath.row];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor=RGBACOLOR(172, 172, 172, 1);
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.textLabel.text=@"开户行";
            cell.detailTextLabel.text=_bankName;
        }
        if (indexPath.row==1) {
            cell.textLabel.text=@"户名";
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",_bankUserName];
        }
        if (indexPath.row==2) {
            cell.textLabel.text=@"卡号";
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",_bankNO];
        }
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            cell.textLabel.text=@"支付宝(推荐)";
//            cell.detailTextLabel.text=_bankName;
        }
        if (indexPath.row==1) {
            cell.textLabel.text=@"户名";
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",_alipayUserName];
        }
        if (indexPath.row==2) {
            cell.textLabel.text=@"卡号";
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",_alipay];
        }
    }
    if (indexPath.section==2) {
        if (indexPath.row==0) {
            cell.textLabel.text=@"微信";
//            cell.detailTextLabel.text=_bankName;
        }
        if (indexPath.row==1) {
            cell.textLabel.text=@"户名";
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",_weixinUserName];
        }
        if (indexPath.row==2) {
            cell.textLabel.text=@"卡号";
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",_weixin];
        }
    }
    UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 39, WIDTH-15, 1)];
    lineLabel.backgroundColor=BGMAINCOLOR;
    [cell.contentView addSubview:lineLabel];
    return cell;
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
