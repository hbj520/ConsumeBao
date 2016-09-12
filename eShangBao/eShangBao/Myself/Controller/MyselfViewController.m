//
//  MyselfViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/13.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "MyselfViewController.h"
#import "HeadTableViewCell.h"
#import "elseMsgTableViewCell.h"
#import "CollectViewController.h"
#import "RecommendViewController.h"
#import "WantRecommendViewController.h"
#import "CoinViewController.h"
#import "SetViewController.h"
#import "MyselfMsgViewController.h"
#import "BusinessViewController.h"
#import "SuggestViewController.h"
#import "InviteViewController.h"
#import "AboutUSViewController.h"
#import "LoginViewController.h"
#import "ShoppingViewController.h"
#import "RecommendLevelTableViewCell.h"
#import "DevelopBusinessViewController.h"
#import "LockVIPViewController.h"
#import "SYQGMJLViewController.h"
#import "SYQFHViewController.h"
#import "AllianceViewController.h"
@interface MyselfViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView * _tableView;
    NSArray  * _imageArr;
    NSArray  * _titleArr;
    
    NSArray  * _imgArr;
    NSArray  * _bannerArr;
    NSString * _imgUrl;//头像图片
    NSString * _nickName;//昵称
    NSString * _phone;//电话号码
    NSString * _bankNo;//银行卡号
    NSString * _goldNum;//通宝币数量
    NSString * _houseFund;//房基金
    NSString * _carFund;//车基金
    NSString * _inviteCode;//邀请码
    NSString * _levelName;//等级名称
    NSString * _nyStatus;
    NSString * _userType;
    NSString * _isShop;//是否是联盟商家
    NSString * _loginName;
    NSString * _firstRefreeNum;//一级
    NSString * _secondRrefeeNum;//二级
    NSString * _thirdRefreeNum;//三级
    NSString * _lastRefreeName;//上级合伙人姓名
    NSArray  * _recommendTitleArr;
    NSString * _partnerAgencyPayStatus;//付款状态
    TBActivityView * activityView;
}

@property(nonatomic,strong)NSMutableArray  * coinArr;

@end

@implementation MyselfViewController

#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    _firstRefreeNum=@"0";
    _secondRrefeeNum=@"0";
    _thirdRefreeNum=@"0";
    _lastRefreeName=@"";
//    _coinArr=[NSMutableArray arrayWithCapacity:0];
    //self.navigationController.fd_prefersNavigationBarHidden=YES;
    [self.view endEditing:YES];
    if (USERID!=nil) {
        NSDictionary * param=@{@"memberId":USERID};
        [RequstEngine requestHttp:@"1003" paramDic:param blockObject:^(NSDictionary *dic) {
            DMLog(@"1003--%@",dic);
            DMLog(@"error--%@",dic[@"errorMsg"]);
            [activityView stopAnimate];
            if ([dic[@"errorCode"] intValue]==00000) {
                _imgUrl=dic[@"member"][@"imgUrl"];
                _nickName=dic[@"member"][@"name"];
                _phone=dic[@"member"][@"phone"];
                _bankNo=dic[@"member"][@"bankNo"];
                _goldNum=dic[@"member"][@"goldNum"];
                _carFund=dic[@"member"][@"carFund"];
                _houseFund=dic[@"member"][@"houseFund"];
                _inviteCode=dic[@"member"][@"inviteCode"];
                _levelName=dic[@"member"][@"levelName"];
                _nyStatus=dic[@"member"][@"partnerAgencyPayStatus"];
                _userType=dic[@"member"][@"type"];
                _loginName=dic[@"member"][@"loginName"];
                _firstRefreeNum=dic[@"member"][@"firstRefreeNum"];
                _secondRrefeeNum=dic[@"member"][@"secondRrefeeNum"];
                _thirdRefreeNum=dic[@"member"][@"thirdRefreeNum"];
                _lastRefreeName=dic[@"member"][@"lastRefreeName"];
                _isShop=dic[@"member"][@"isShop"];
                DMLog(@"nickname--%@",_levelName);
                NSString * goldNum=[NSString stringWithFormat:@"%.2f",[_goldNum floatValue]];
                _coinArr=[NSMutableArray arrayWithObjects:goldNum,@"5万积分可购买商品",@"一次购买不得超过1万元",@"自动转入佣金账户", nil];
                _partnerAgencyPayStatus=dic[@"member"][@"partnerAgencyPayStatus"];
                [[NSUserDefaults standardUserDefaults] setObject:dic[@"member"][@"partnerAgencyPayStatus"] forKey:@"partnerAgencyPayStatus"];
                [[NSUserDefaults standardUserDefaults] setObject:dic[@"member"][@"type"] forKey:@"userType"];
            }
            else
            {
                _imgUrl=@"";
                _nickName=@"";
                _phone=@"";
                _goldNum=@"0";
                _loginName=@"";
                _nickName=@"";
                _levelName=@"";
                _firstRefreeNum=@"0";
                _secondRrefeeNum=@"0";
                _thirdRefreeNum=@"0";
                _lastRefreeName=@"";
//                NSString * goldNum=[NSString stringWithFormat:@"%.2f",[_goldNum floatValue]];
                _coinArr=[NSMutableArray arrayWithObjects:@"",@"5万积分可购买商品",@"一次购买不得超过1万元",@"自动转入佣金账户", nil];


            }
            [_tableView reloadData];
        }];

    }
//    else
//    {
//        [_tableView reloadData];
//    }
    
}

- (void)viewDidLoad {
    
//    self.fd_prefersNavigationBarHidden=YES;
   // self.navigationController.navigationBarHidden=YES;
    //[self.navigationController setNavigationBarHidden:YES];
    
    _firstRefreeNum=@"0";
    _secondRrefeeNum=@"0";
    _thirdRefreeNum=@"0";
    _lastRefreeName=@"";
    _loginName=@"";
    _nickName=@"";
    _levelName=@"";
    _lastRefreeName=@"";
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    
    [activityView startAnimate];
    
    self.view.backgroundColor=BGMAINCOLOR;
    [super viewDidLoad];
    
    //去除返回按钮的文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-20, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    //    //设置返回图标的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
//    self.title=@"我的信息";



    _coinArr=[NSMutableArray arrayWithObjects:@"0",@"5万积分可购买商品",@"一次购买不得超过1万元",@"可转入佣金账户", nil];
    _imageArr=@[@"myBussiness_icon",@"tuijian_icon",@"myCollect_icon",@"gwcheader_icon",@"developMer_icon",@"my_rmarket_icon",@"yjm_icon"];
    _imgArr=@[@"setUp_icon",@"suggest_icon",@"aboutUs_icon"];
    _titleArr=@[@"我是商家",@"我要推荐",@"我的收藏",@"购物车",@"加入联盟商家",@"加入联营超市",@"邀请码"];
    _bannerArr=@[@"设置",@"意见反馈",@"关于我们"];
    _recommendTitleArr=@[@"我的推荐",@"一级",@"二级",@"三级"];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-50) style:0];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=0;
    _tableView.showsVerticalScrollIndicator=NO;
    
//    _tableView.scrollEnabled=NO;
    [self.view addSubview:_tableView];

    // Do any additional setup after loading the view from its nib.
}

# pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        
        return _coinArr.count/4;
    }
    else if(section==1)
    {
        return 5;
    }
    else if (section==2)
    {
        return 7;
    }
    else
    {
        return 3;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        HeadTableViewCell * cell=[HeadTableViewCell nowStatusWithTableView:_tableView coinArr:_coinArr];
        cell.selectionStyle=0;
//
//        DMLog(@"----%@",_imgUrl);
        [cell.headImg setImageWithURLString:_imgUrl placeholderImage:@"头像"];
        cell.titleLabel.text=[NSString stringWithFormat:@"账号: %@",_loginName];
        cell.nameLabel.text=[NSString stringWithFormat:@"姓名: %@",_nickName];
        cell.levelLabel.text=[NSString stringWithFormat:@"会员级别: %@",_levelName];
        if (![NSString isLogin]) {
            cell.loginBtn.hidden=NO;
            [cell.loginBtn addTarget:self action:@selector(gotoLogin) forControlEvents:1<<6];
            cell.titleLabel.hidden=YES;
            cell.nameLabel.hidden=YES;
            cell.levelLabel.hidden=YES;
//            cell.loginBtn.enabled=YES;
        }
        else
        {
            cell.loginBtn.hidden=YES;
            cell.titleLabel.hidden=NO;
            cell.nameLabel.hidden=NO;
            cell.levelLabel.hidden=NO;
            cell.loginBtn.enabled=NO;
            [cell.loginBtn addTarget:self action:@selector(gotoMsg) forControlEvents:1<<6];
        }
        
        
        [cell.chooseButton1 addTarget:self action:@selector(chooseButtonCkick:) forControlEvents:1<<6];
        [cell.chooseButton2 addTarget:self action:@selector(chooseButtonCkick:) forControlEvents:1<<6];
        [cell.chooseButton3 addTarget:self action:@selector(chooseButtonCkick:) forControlEvents:1<<6];
        [cell.chooseButton4 addTarget:self action:@selector(chooseButtonCkick:) forControlEvents:1<<6];
        
        cell.coinArr=_coinArr;
//        cell.dateLabel.text=[NSString stringWithFormat:@"注册日期: %@",]
        return cell;
    }
    
    else if (indexPath.section==1)
    {
        RecommendLevelTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[RecommendLevelTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
        }
        cell.accessoryType=1;
        cell.selectionStyle=0;
        if (indexPath.row==4) {
            cell.iconImg.image=[UIImage imageNamed:@"myTop_icon"];
            cell.iconImg.hidden=NO;
            cell.detailTitleLabel.hidden=YES;
            cell.titleLabel.text=[NSString stringWithFormat:@"我的上级: %@",_lastRefreeName];
            cell.accessoryType=0;
        }
        else
        {
            if (indexPath.row==0) {
                cell.iconImg.hidden=NO;
                cell.iconImg.image=[UIImage imageNamed:@"myTj_icon"];
                cell.titleLabel.text=@"我的推荐";
//                cell.detailTitleLabel.text=@"10";
                cell.detailTitleLabel.hidden=YES;
                 cell.accessoryType=0;
            }
            if (indexPath.row==1) {
                cell.iconImg.hidden=YES;
                
                cell.titleLabel.text=@"一级";
                cell.detailTitleLabel.text=[NSString stringWithFormat:@"%@",_firstRefreeNum];
            }
            if (indexPath.row==2) {
                cell.iconImg.hidden=YES;
                cell.titleLabel.text=@"二级";
                cell.detailTitleLabel.hidden=NO;
                cell.detailTitleLabel.text=[NSString stringWithFormat:@"%@",_secondRrefeeNum];
            }
            if (indexPath.row==3) {
                cell.iconImg.hidden=YES;
                cell.titleLabel.text=@"三级";
                cell.detailTitleLabel.hidden=NO;
                cell.detailTitleLabel.text=[NSString stringWithFormat:@"%@",_thirdRefreeNum];
            }
            
//            cell.titleLabel.text=_recommendTitleArr[indexPath.row-1];

        }
        
        //        cell.textLabel.text=@"ygq";
        return cell;

    }
    else
    {
        elseMsgTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"elseCell"];
        if (!cell) {
            cell=[[elseMsgTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"elseCell"];
        }
        cell.accessoryType=1;
        cell.selectionStyle=0;
        if (indexPath.section==2) {
//            if (([_userType intValue]==2&&[_nyStatus intValue]==1)||([_isShop intValue]==1)) {
//            
//                 
//            
//            
//            }
            cell.headImg.image=[UIImage imageNamed:_imageArr[indexPath.row]];
            cell.titleLabel.text=_titleArr[indexPath.row];
            cell.layer.masksToBounds=YES;
        }
        else
        {
            cell.headImg.image=[UIImage imageNamed:_imgArr[indexPath.row]];
            cell.titleLabel.text=_bannerArr[indexPath.row];
            
//            if (indexPath.row==0) {
//                UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(200, 10, 10, 10)];
//                coverView.backgroundColor=[UIColor redColor];
//                [cell.contentView addSubview:coverView];
//            }
        }
        
        
//        cell.textLabel.text=@"ygq";
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section==0) {
        return 0;
    }
    else
    {
        return H(10);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        return 280;
    }
    else
    {

        if (([_userType intValue]==2&&[_nyStatus intValue]==1)||([_isShop intValue]==1)) {
//            return 44;
            if (indexPath.section==2&&indexPath.row==3) {
                return 0;
            }
            else
            {
                return 44;
            }
        }
        else
        {
            if (indexPath.section==2&&indexPath.row==0) {
                return 0;
            }
            else
            {
                if (indexPath.section==2&&indexPath.row==3) {
                    return 0;
                }
                else
                {
                    return 44;
                }

            }
        }
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==0) {
        if (![NSString isLogin]) {
            [self loginUser];
        }
        else
        {
            MyselfMsgViewController * myselfMsgVC=[[MyselfMsgViewController alloc]init];
            myselfMsgVC.hidesBottomBarWhenPushed=YES;
            myselfMsgVC.partnerAgencyPayStatus=_partnerAgencyPayStatus;
            [self.navigationController pushViewController:myselfMsgVC animated:YES];
        }
        
    }
    if (indexPath.section==1) {
        if (indexPath.row==4) {
            
        }
        else if(indexPath.row==0)
        {
            
        }
        else
        {
            if (![NSString isLogin]) {
                [self loginUser];
            }
            else
            {
                DMLog(@"---%@",MYSTATUS);
                if ([_nyStatus intValue]==1||[_isShop intValue]==1) {
                    RecommendViewController * recommendVC = [[RecommendViewController alloc]init];
                    recommendVC.hidesBottomBarWhenPushed=YES;
                    recommendVC.myImgUrl=_imgUrl;
                    recommendVC.myNickName=_nickName;
                    if (indexPath.row==1) {
                        recommendVC.floor=@"0";
                    }
                    if (indexPath.row==2)
                    {
                        recommendVC.floor=@"1";
                    }
                    if (indexPath.row==3) {
                        recommendVC.floor=@"2";
                    }
                    [self.navigationController pushViewController:recommendVC animated:YES];
                }
                else
                {
                    [UIAlertView alertWithTitle:@"温馨提示" message:@"对不起，您还不是正式的合伙人，不能进行此操作" buttonTitle:nil];
                }
                
            }

        }
        
    }
    if (indexPath.section==2&&indexPath.row==0) {
        if (![NSString isLogin]) {
            [self loginUser];
        }
        else
        {
            if (([_userType intValue]==2&&[_nyStatus intValue]==1)||([_isShop intValue]==1)) {
                BusinessViewController * businessVC=[[BusinessViewController alloc]init];
                businessVC.hidesBottomBarWhenPushed=YES;
                businessVC.useType=_userType;
                businessVC.isShop=_isShop;
                businessVC.partnerAgencyPayStatus=_partnerAgencyPayStatus;
                [self.navigationController pushViewController:businessVC animated:YES];
            }
            else
            {
                [UIAlertView alertWithTitle:@"温馨提示" message:@"对不起，您还不是商家，不能进行此操作" buttonTitle:nil];
                
            }
            
            
        }
       
    }
    if (indexPath.section==2&&indexPath.row==1) {
        if (![NSString isLogin]) {
            [self loginUser];
        }
        else
        {
            if ([_nyStatus intValue]==1) {
            
                WantRecommendViewController * wantVC=[[WantRecommendViewController alloc]init];
                wantVC.hidesBottomBarWhenPushed=YES;
                wantVC.nyStatus=_nyStatus;
                [self.navigationController pushViewController:wantVC animated:YES];
            }
            else
            {
                [UIAlertView alertWithTitle:@"温馨提示" message:@"对不起，您还不是正式的合伙人，不能进行此操作" buttonTitle:nil];
            }
//

        }
    }
    
    if (indexPath.section==2&&indexPath.row==2) {
        if (![NSString isLogin]) {
            [self loginUser];
        }
        else
        {
            CollectViewController*collectVC=[[CollectViewController alloc]init];
            collectVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:collectVC animated:YES];
            
        }
    }
    
//    if (indexPath.section==2&&indexPath.row==3) {
//        if (![NSString isLogin]) {
//            [self loginUser];
//        }
//        else
//        {
//            CoinViewController * coinVC=[[CoinViewController alloc]init];
//            coinVC.hidesBottomBarWhenPushed=YES;
//            coinVC.bankNo=_bankNo;
////            coinVC.goldNum=_goldNum;
//            coinVC.houseFund=_houseFund;
//            coinVC.carFund=_carFund;
//            [self.navigationController pushViewController:coinVC animated:YES];
//        }
//      
//    }
    if (indexPath.section==2&&indexPath.row==3) {
        if (![NSString isLogin]) {
            [self loginUser];
        }
        else
        {
            ShoppingViewController * coinVC=[[ShoppingViewController alloc]init];
            coinVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:coinVC animated:YES];
        }

    }
    if (indexPath.section==2&&indexPath.row==4) {
        if (![NSString isLogin]) {
            [self loginUser];
        }
        else
        {
            if ([_isShop isEqualToString:@"1"]) {
                [UIAlertView alertWithTitle:@"温馨提示" message:@"您已是联盟商家" buttonTitle:nil];
            }
            else
            {
                AllianceViewController * coinVC=[[AllianceViewController alloc]init];
                coinVC.hidesBottomBarWhenPushed=YES;
                coinVC.titleStr=@"万商联盟";
                coinVC.whichPage=@"10";
                coinVC.vctype=@"0";
                [self.navigationController pushViewController:coinVC animated:YES];

            }
        }
        
    }
    if (indexPath.section==2&&indexPath.row==5) {
        if (![NSString isLogin]) {
            [self loginUser];
        }
        else
        {
            if ([_userType intValue]==1&&[_partnerAgencyPayStatus intValue]==1) {
                
                [UIAlertView alertWithTitle:@"温馨提示" message:@"您已经是合伙人,不能再申请联营超市" buttonTitle:nil];
                return;
                
            }
            
            
            if ([_userType intValue]==2&&[_partnerAgencyPayStatus intValue]==1)
            {
                UIAlertView *newAlertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您已经是联营超市，不需要再次申请" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"管理店铺", nil];
                [newAlertView show];
            }
            else
            {
                AllianceViewController * coinVC=[[AllianceViewController alloc]init];
                coinVC.whichPage=@"0";
                coinVC.titleStr=@"联营超市";
                coinVC.vctype=@"0";
                coinVC.hidesBottomBarWhenPushed=YES;
                
                [self.navigationController pushViewController:coinVC animated:YES];
            }
            
        }
        
    }
    if (indexPath.section==2&&indexPath.row==6) {
        if (![NSString isLogin]) {
            [self loginUser];
        }
        else
        {
            InviteViewController * inviteVC=[[InviteViewController alloc]init];
            inviteVC.hidesBottomBarWhenPushed=YES;
            inviteVC.inviteCode=_inviteCode;
            [self.navigationController pushViewController:inviteVC animated:YES];
        }
        
    }
    if (indexPath.section==3&&indexPath.row==0) {
        SetViewController*setVC=[[SetViewController alloc]init];
        setVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:setVC animated:YES];
    }
    if (indexPath.section==3&&indexPath.row==1) {
        
        if (![NSString isLogin]) {
            [self loginUser];
        }
        else
        {
            SuggestViewController * suggestVC=[[SuggestViewController alloc]init];
            suggestVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:suggestVC animated:YES];
        }
        
    }
    if (indexPath.section==3&&indexPath.row==2) {
        AboutUSViewController * aboutVC=[[AboutUSViewController alloc]init];
        aboutVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        
        BusinessViewController * businessVC=[[BusinessViewController alloc]init];
        businessVC.hidesBottomBarWhenPushed=YES;
        businessVC.useType=_userType;
        businessVC.isShop=_isShop;
        businessVC.partnerAgencyPayStatus=_partnerAgencyPayStatus;
        [self.navigationController pushViewController:businessVC animated:YES];
        
        DMLog(@"店铺管理");
    }
}

-(void)chooseButtonCkick:(UIButton *)sender
{
    
    switch (sender.tag) {
        case 1:
        {
            DMLog(@"佣金账户");
            if (![NSString isLogin]) {
                [self loginUser];
            }
            else
            {
                CoinViewController * coinVC=[[CoinViewController alloc]init];
                coinVC.hidesBottomBarWhenPushed=YES;
                coinVC.bankNo=_bankNo;
                coinVC.goldNum=_goldNum;
                coinVC.houseFund=_houseFund;
                coinVC.carFund=_carFund;
                coinVC.memberType=_userType;
                [self.navigationController pushViewController:coinVC animated:YES];

            }
            //            [UIAlertView alertWithTitle:@"温馨提示" message:@"暂未开放此功能，敬请期待" buttonTitle:nil];
        }
            break;
        case 2:
        {
            DMLog(@"福利投资");
            [UIAlertView alertWithTitle:@"温馨提示" message:@"暂未开放此功能，敬请期待" buttonTitle:nil];
        }
            break;
        case 3:
        {
            DMLog(@"收益权");
            if (![NSString isLogin]) {
                
                [self loginUser];
                return;
            }
            SYQGMJLViewController *syqVC=[[SYQGMJLViewController alloc]init];
            syqVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:syqVC animated:YES];
            
        }
            break;
        case 4:
        {
         
            if (![NSString isLogin]) {
                
                [self loginUser];
                return;
            }
            SYQFHViewController *syqfhVC=[[SYQFHViewController alloc]init];
            syqfhVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:syqfhVC animated:YES];
            DMLog(@"收益分红");
        }
            break;
            
        default:
            break;
    }
    
    
}

-(void)gotoLogin
{
    [self loginUser];
}

-(void)gotoMsg
{
    MyselfMsgViewController * myselfMsgVC=[[MyselfMsgViewController alloc]init];
    myselfMsgVC.hidesBottomBarWhenPushed=YES;
    myselfMsgVC.partnerAgencyPayStatus=_partnerAgencyPayStatus;
    [self.navigationController pushViewController:myselfMsgVC animated:YES];

}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    self.navigationController.navigationBarHidden=NO;
//}
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
