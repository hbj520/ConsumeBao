//
//  SJXQViewController.m
//  eShangBao
//
//  Created by doumee on 16/6/30.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "SJXQViewController.h"
#import "SJXQMsgTableViewCell.h"
#import "SJXQCommentTableViewCell.h"
#import "HHRTableViewCell.h"
#import "ScanerVC.h"
#import "SellerDataModel.h"
#import "SJCLocation.h"
#import "SJPLViewController.h"
#import "CollectionViewController.h"
#import "ReturnBateTableViewCell.h"
@interface SJXQViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView                       * _tableView;
    TBActivityView                    *activityView;
    SellerInfoModel                   *infoModel;
    NSString                          *totalCount;
    
    UIView                            *bgView;
    int                               _count;
}

@property(nonatomic,strong)NSMutableArray *storeCommentsArr;

@property(nonatomic,retain)UIButton * backBtn;

@property(nonatomic,strong)UIButton * collectBtn;

@property(nonatomic,strong)UIButton * searchBtn;

@property(nonatomic,strong)UIView   * coverView;

@property (nonatomic,retain)NSString * isCollected;

@property(nonatomic,strong)UILabel  * titleLabel;
@end

@implementation SJXQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _storeCommentsArr=[NSMutableArray arrayWithCapacity:0];
    self.fd_prefersNavigationBarHidden=YES;
    [self backBtn];
//    self.navigationController.navigationBarHidden=YES;
    
    infoModel=[[SellerInfoModel alloc]init];
    self.view.backgroundColor=BGMAINCOLOR;

    [self loadUI];
    [self requsetShopInfo];
    [self requestCommentsList];
    _count=0;
    
    
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    [activityView startAnimate];
    
    // Do any additional setup after loading the view.
}

-(void)loadUI
{
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, -20, WIDTH, HEIGHT-25) style:1];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=0;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [self.view addSubview:_coverView];
    
    _backBtn=[UIButton buttonWithType:0];
    _backBtn.frame=CGRectMake(15, 30, W(20), H(20));
    [_backBtn addTarget:self action:@selector(backToLast) forControlEvents:1<<6];
    [_backBtn setImage:[UIImage imageNamed:@"返回_03"] forState:0];
    [_coverView addSubview:_backBtn];
    
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 30, WIDTH-100, 20)];
    _titleLabel.textColor=[UIColor whiteColor];
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.font=[UIFont systemFontOfSize:16];
//    _titleLabel.alpha=0;
    [_coverView addSubview:_titleLabel];
    
    _collectBtn=[UIButton buttonWithType:0];
    _collectBtn.frame=CGRectMake(WIDTH-50, 20, 40, 40);
    [_collectBtn addTarget:self action:@selector(collectTheGoods) forControlEvents:1<<6];
    
    
    [_coverView addSubview:_collectBtn];
    
//    _searchBtn=[UIButton buttonWithType:0];
//    _searchBtn.frame=CGRectMake(kRight(_collectBtn), 20, 40, 40);
//    [_searchBtn addTarget:self action:@selector(searchGoods) forControlEvents:1<<6];
//    [_searchBtn setImage:[UIImage imageNamed:@"search"] forState:0];
//    [_coverView addSubview:_searchBtn];
    [self createFootView];
    
    
    
    
}
-(void)createFootView
{
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight-44, WIDTH, 44)];
    view.backgroundColor=[UIColor whiteColor];
    
//    UIButton * button=[UIButton buttonWithType:0];
//    button.frame=CGRectMake(12, 10, WIDTH-12*2, 44);
//    button.backgroundColor=MAINCOLOR;
//    [button setTitle:@"去买单" forState:0];
//    [button addTarget:self action:@selector(gotoPayOrder) forControlEvents:1<<6];
//    [button setTitleColor:[UIColor whiteColor] forState:0];
//    button.titleLabel.font=[UIFont systemFontOfSize:14];
//    button.layer.cornerRadius=5;
//    button.layer.masksToBounds=YES;
//    [view addSubview:button];
//    [self.view addSubview:view];
    
    _returnBateLabel1=[[UILabel alloc]initWithFrame:CGRectMake(15, 12, 160, 20)];
    _returnBateLabel1.textColor=RGBACOLOR(255, 97, 0, 1);
//    _returnBateLabel1.text=[NSString stringWithFormat:@"返币:%.1f%@",[infoModel.returnGoldRate floatValue]*100,@"%"];
    _returnBateLabel1.font=[UIFont boldSystemFontOfSize:18];
    [view addSubview:_returnBateLabel1];
    
    _button=[UIButton buttonWithType:0];
    _button.frame=CGRectMake(WIDTH-85, 0, 85, 44);
    _button.backgroundColor=MAINCOLOR;
    [_button setTitle:@"优惠买单" forState:0];
    _button.enabled=NO;
    [_button addTarget:self action:@selector(gotoPayOrder) forControlEvents:1<<6];
    [_button setTitleColor:[UIColor whiteColor] forState:0];
    _button.titleLabel.font=[UIFont boldSystemFontOfSize:18];
    [view addSubview:_button];
    
    _jiantouImg=[[UIImageView alloc]initWithFrame:CGRectMake(kLeft(_button)-30, 14, 16, 16)];
    _jiantouImg.image=[UIImage imageNamed:@"图层-up"];
    [view addSubview:_jiantouImg];
    
    UIButton * spreadBtn=[UIButton buttonWithType:0];
    spreadBtn.frame=CGRectMake(0, 0, WIDTH-85, 44);
    [spreadBtn addTarget:self action:@selector(spreadView) forControlEvents:1<<6];
    [view addSubview:spreadBtn];
    
    [self.view addSubview:view];
}

-(void)requsetShopInfo{
    
    NSDictionary *param=@{@"shopId":_shopID};
    [RequstEngine requestHttp:@"1012" paramDic:param blockObject:^(NSDictionary *dic) {
        DMLog(@"1012------%@",dic);
        [activityView stopAnimate];
        if ([dic[@"errorCode"] intValue]==0) {
            _button.enabled=YES;
            [infoModel setValuesForKeysWithDictionary:dic[@"shop"]];
            _isCollected=dic[@"shop"][@"isCollected"];
            if ([_isCollected intValue]==0) {
                
                [_collectBtn setImage:[UIImage imageNamed:@"dianzan_btn"] forState:0];
                
            }else{
                
                [_collectBtn setImage:[UIImage imageNamed:@"dianan_red"] forState:0];
            }

            [_tableView reloadData];
            _returnBateLabel1.text=[NSString stringWithFormat:@"返币:%.1f%@",[infoModel.returnGoldRate floatValue]*100,@"%"];
//            [self loadUI];
        }
        else
        {
            
            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
}

-(void)requestCommentsList
{
//    
    NSDictionary *param=@{@"shopId":_shopID,@"scoreLevel":@"0"};
    NSDictionary *pagination=@{@"page":@"1",@"rows":@"3",@"firstQueryTime":@""};
    [RequstEngine pagingRequestHttp:@"1013" paramDic:param pageDic:pagination blockObject:^(NSDictionary *dic) {
        
        [activityView stopAnimate];

        DMLog(@"1013----%@",dic);
        DMLog(@"error----%@",dic[@"errorMsg"]);
        if ([dic[@"errorCode"] intValue]==0) {
            
            for (NSDictionary *newDic in dic[@"recordList"]) {
                
                CommentList *commentModel=[[CommentList alloc]init];
                [commentModel setValuesForKeysWithDictionary:newDic];
                [_storeCommentsArr addObject:commentModel];
                
            }
            
            totalCount=dic[@"totalCount"];
//            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
//            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            [_tableView reloadData];
            
        }
    }];

}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 1;
    if (section==0) {
        return 1;
    }
    else if (section==1)
    {
        return 1;
    }
    else if (section==2)
    {
        return _storeCommentsArr.count;
    }
    else
    {
        return 1;
    }
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        SJXQMsgTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"sjxqCell"];
        if (!cell) {
            cell=[[SJXQMsgTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"sjxqCell"];
        }

        [cell.locationBtn addTarget:self action:@selector(businessLocation) forControlEvents:1<<6];
        [cell.dailBtn addTarget:self action:@selector(dailBusiness) forControlEvents:1<<6];
        cell.infoModel=infoModel;
        cell.selectionStyle=0;
        return cell;
    }
    else if (indexPath.section==1)
    {
        ReturnBateTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"returnCell"];
        if (!cell) {
            cell=[[ReturnBateTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"returnCell"];
        }

        cell.returnBateLabel.text=[NSString stringWithFormat:@"返币:%.1f%@",[infoModel.returnGoldRate floatValue]*100,@"%"];
//        cell.orderNumLabel.text=[NSString stringWithFormat:@"已领%@",infoModel.monthOrderNum];
        if (infoModel.startBusinessTime.length==0&&infoModel.endBusinessTime.length==0) {
            cell.timeLabel.hidden=YES;
        }
        else
        {
            cell.timeLabel.hidden=NO;
            cell.timeLabel.text=[NSString stringWithFormat:@"每天%@-%@可用",infoModel.startBusinessTime,infoModel.endBusinessTime];
        }
        
        cell.selectionStyle=0;
        return cell;

    }
    else if (indexPath.section==2)
    {
        
        CommentList *commentModel=_storeCommentsArr[indexPath.row];
        HHRTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"HHRPLCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"HHRTableViewCell" owner:nil options:nil] objectAtIndex:2];
        }
        cell.storeComment=commentModel;
        cell.selectionStyle=0;
        return cell;
    }
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text=[NSString stringWithFormat:@"营业时间：%@-%@",infoModel.startBusinessTime,infoModel.endBusinessTime];
    //cell.textLabel.text=@"营业时间：08:00-22:00";
    cell.textLabel.textColor=MAINCHARACTERCOLOR;
    cell.textLabel.font=[UIFont systemFontOfSize:12];
    cell.selectionStyle=0;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        float addressH=[NSString calculatemySizeWithFont:18. Text:infoModel.shopAddr width:KScreenWidth-16];
        return 340+addressH+60;
    }
    else if (indexPath.section==2)
    {
        CommentList *model=_storeCommentsArr[indexPath.row];
        float strH=[NSString calculatemySizeWithFont:14. Text:model.content width:KScreenWidth-63];
        return 60+strH;

    }
    else if (indexPath.section==1)
    {
        return 75;
    }
    
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2||section==3) {
        return 54;
    }
    else if (section==1)
    {
        return 10;
    }
    else
    {
        return 1;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        
        UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
        view.backgroundColor=BGMAINCOLOR;
        
        UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, WIDTH, 44)];
        coverView.backgroundColor=[UIColor whiteColor];
        [view addSubview:coverView];
        
        UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, WIDTH, 44)];
        titleLabel.backgroundColor=[UIColor whiteColor];
        titleLabel.text=@"评论详情";
        titleLabel.font=[UIFont systemFontOfSize:14];
        titleLabel.textColor=RGBACOLOR(136, 136, 136, 1);
        [coverView addSubview:titleLabel];
        
        UILabel * titleLabelBottom=[[UILabel alloc]initWithFrame:CGRectMake(0, view.bounds.size.height, WIDTH, 1)];
        titleLabelBottom.backgroundColor=BGMAINCOLOR;
        [coverView addSubview:titleLabelBottom];
        
        return view;
    }
    else if (section==3)
    {
        UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 54)];
        view.backgroundColor=BGMAINCOLOR;
        
        UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, WIDTH, 44)];
        coverView.backgroundColor=[UIColor whiteColor];
        [view addSubview:coverView];
        
        UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, WIDTH, 44)];
        titleLabel.backgroundColor=[UIColor whiteColor];
        titleLabel.text=@"温馨提示";
        titleLabel.font=[UIFont systemFontOfSize:14];
        titleLabel.textColor=RGBACOLOR(136, 136, 136, 1);
        [coverView addSubview:titleLabel];
        
        UILabel * lineLabel2=[[UILabel alloc]initWithFrame:CGRectMake(0, 53, WIDTH, 1)];
        lineLabel2.backgroundColor=BGMAINCOLOR;
        [view addSubview:lineLabel2];
        return view;
    }
    
    else
    {
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        if ([totalCount intValue]>3) {
            
            return 44;
            
        }
        return 1;
    }
    else if (section==3)
    {
        return 60;
    }
    return 1;
}
-(UIView * )tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==2) {
        
        UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
        view.backgroundColor=[UIColor whiteColor];
        
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 1, WIDTH, 1)];
        lineLabel.backgroundColor=BGMAINCOLOR;
        [view addSubview:lineLabel];
        
        UIButton * checkBtn=[UIButton buttonWithType:0];
        checkBtn.frame=view.frame;
        [checkBtn setTitle:@"查看全部评论" forState:0];
        [checkBtn addTarget:self action:@selector(checkAllComment) forControlEvents:1<<6];
        [checkBtn setTitleColor:RGBACOLOR(136, 136, 136, 1) forState:0];
        checkBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [view addSubview:checkBtn];
        
        UILabel * lineLabel2=[[UILabel alloc]initWithFrame:CGRectMake(0, 43, WIDTH, 1)];
        lineLabel2.backgroundColor=BGMAINCOLOR;
        [view addSubview:lineLabel2];
        return view;
        
    }
    else
    {
        return nil;
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    NSLog(@"offset---scroll:%f",_tableView.contentOffset.y);
    UIColor *color=MAINCOLOR;
    CGFloat offset=scrollView.contentOffset.y;
    if (offset<=0) {
        _coverView.backgroundColor=[color colorWithAlphaComponent:0];
        _titleLabel.text=@"";
        _titleLabel.backgroundColor=[color colorWithAlphaComponent:0];

    }else {
        CGFloat alpha=1-((90+60-offset)/64);

        _coverView.backgroundColor=[color colorWithAlphaComponent:alpha];
       
    }
    
    if (offset>120+60&&offset<150+60) {
        
        if (infoModel.branchName.length==0&&infoModel.shopName.length!=0) {
            _titleLabel.text=infoModel.shopName;
        }
        if (infoModel.branchName.length!=0&&infoModel.shopName.length!=0) {
            _titleLabel.text=[NSString stringWithFormat:@"%@(%@)",infoModel.shopName,infoModel.branchName];
        }
        if (infoModel.branchName.length!=0&&infoModel.shopName.length==0) {
            _titleLabel.text=infoModel.branchName;
        }
        if (infoModel.branchName.length==0&&infoModel.shopName.length==0) {
            _titleLabel.text=@"";
        }

//        _titleLabel.text=[NSString stringWithFormat:@"%@(%@)",infoModel.shopName,infoModel.branchName];
//        _titleLabel.alpha=(offset-120)/30;
        CGFloat alpha=1-((120-offset)/64);
        _titleLabel.textColor=[[UIColor whiteColor] colorWithAlphaComponent:alpha];
        
        
    }
    
    
    
    
}
#pragma mark - Action Way
-(void)backToLast
{
    DMLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)checkAllComment
{
    DMLog(@"查看全部评论");
    
    SJPLViewController *sjplVC=[[SJPLViewController alloc]init];
    sjplVC.shopId=infoModel.shopId;
    [self.navigationController pushViewController:sjplVC animated:YES];
    
}


-(void)gotoPayOrder
{
    DMLog(@"去买单");
    if (![NSString isLogin]) {
        [self loginUser];
    }
    else
    {
        CollectionViewController * collectionVC=[[CollectionViewController alloc]init];
        //    collectionVC.headImgUrl=_headImgUrl;
        //    collectionVC.loginName=_loginName;
        //    collectionVC.phone=_phone;
        collectionVC.infoModel=infoModel;
        [self.navigationController pushViewController:collectionVC animated:YES];

    }
    
    
//    ScanerVC * scan=[[ScanerVC alloc]init];
//    scan.whichPage=@"13";
//    scan.infoModel=infoModel;
//    [self.navigationController pushViewController:scan animated:YES];
}

-(void)collectTheGoods
{
    if (![NSString isLogin]) {
        [self loginUser];
    }
    else
    {
        if ([_isCollected intValue]==0)
        {
            
            NSDictionary *param=@{@"objectId":infoModel.shopId,@"type":@"0"};
            [RequstEngine requestHttp:@"1007" paramDic:param blockObject:^(NSDictionary *dic) {
                
                
                DMLog(@"-%@",dic);
                if ([dic[@"errorCode"] intValue]==0) {
                    //                    [UIAlertView alertWithTitle:@"温馨提示" message:@"收藏成功" buttonTitle:nil];
                    
                    [_collectBtn setImage:[UIImage imageNamed:@"dianan_red"] forState:0];
                    //❤️跳动的动画
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.3];
                    CGAffineTransform trasform = CGAffineTransformMakeScale(1.4, 1.4);
                    _collectBtn.transform = trasform;
                    [UIView commitAnimations];
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.3];
                    [UIView setAnimationDelay:0.3];
                    trasform = CGAffineTransformMakeScale(1, 1);
                    _collectBtn.transform = trasform;;
                    [UIView commitAnimations];
                    _isCollected=@"1";
                    
                }else{
                    
                    [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                    
                }
            }];
        }else{
            
            NSDictionary * param=@{@"objectId":infoModel.shopId};
            [RequstEngine requestHttp:@"1051" paramDic:param blockObject:^(NSDictionary *dic) {
                DMLog(@"1051--%@",dic);
                DMLog(@"error--%@",dic[@"errorMsg"]);
                if ([dic[@"errorCode"] intValue]==00000) {
                    
                    [_collectBtn setImage:[UIImage imageNamed:@"dianzan_btn"] forState:0];
                    //❤️跳动的动画
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.3];
                    CGAffineTransform trasform = CGAffineTransformMakeScale(1.4, 1.4);
                    _collectBtn.transform = trasform;
                    [UIView commitAnimations];
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.3];
                    [UIView setAnimationDelay:0.3];
                    trasform = CGAffineTransformMakeScale(1, 1);
                    _collectBtn.transform = trasform;;
                    [UIView commitAnimations];
                    _isCollected=@"0";
                    
                }
                else
                {
                    [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                }
            }];
            
            
            
        }

    }
    DMLog(@"收藏");
    
    
    
}
//
//-(void)searchGoods
//{
//    DMLog(@"搜索");
//}

-(void)businessLocation
{
    DMLog(@"定位商家");
    
    if (!bgView) {
        
        bgView=[[UIView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:bgView];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:bgView.bounds];
        imageView.backgroundColor=[UIColor blackColor];
        imageView.alpha=0.7;
        [bgView addSubview:imageView];
        
        SJCLocation *locationView=[[SJCLocation alloc]initWithFrame:CGRectMake(0, 10, KScreenWidth-20, 350)];
        locationView.center=CGPointMake(KScreenWidth/2, KScreenHeight/2);
        locationView.storeName=infoModel.shopName;
        [locationView locationLatitude:infoModel.latitude locationLongitude:infoModel.longitude];
        
        [bgView addSubview:locationView];

        UIButton *delegateButton=[UIButton buttonWithType:0];
        [delegateButton setBackgroundImage:[UIImage imageNamed:@"登录1_06"] forState:0];
        delegateButton.frame=CGRectMake(KScreenWidth-35, CGRectGetMinY(locationView.frame)-35, 30, 30);
        [delegateButton addTarget:self action:@selector(delegateButtonClick) forControlEvents:1<<6];
        [bgView addSubview:delegateButton];
        
    }
    else{
        
        bgView.hidden=NO;
    }
    
}
-(void)delegateButtonClick
{
    bgView.hidden=YES;
}

-(void)dailBusiness
{
    DMLog(@"联系商家");
    if (infoModel.branchName.length==0) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"暂无门店电话" buttonTitle:nil];
    }
    else
    {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",infoModel.branchPhone];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];

        
    }
    
    
}

#pragma mark - 展开View
-(void)spreadView
{
    
    _count++;
    if (_count%2==1) {
        _jiantouImg.image=[UIImage imageNamed:@"图层-down"];
        _cateView=[[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-44-75, WIDTH, 74)];
        _cateView.backgroundColor=[UIColor whiteColor];
        
        _returnBateLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, 120, 20)];
        _returnBateLabel.text=[NSString stringWithFormat:@"返币:%.1f%@",[infoModel.returnGoldRate floatValue]*100,@"%"];
        _returnBateLabel.font=[UIFont systemFontOfSize:16];
        _returnBateLabel.textColor=RGBACOLOR(255, 97, 0, 1);
        [_cateView addSubview:_returnBateLabel];
        
        _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(7+8, kDown(_returnBateLabel)+10, 160, 20)];
        _timeLabel.textColor=RGBACOLOR(154, 154, 154, 1);
        _timeLabel.text=[NSString stringWithFormat:@"每天%@-%@可用",infoModel.startBusinessTime,infoModel.endBusinessTime];
        _timeLabel.font=[UIFont systemFontOfSize:14];
        [_cateView addSubview:_timeLabel];
        
        //    _cateView.cateName=_categoryName;
        //                _cateView.categoryArr=_groundingArr;
        //                _cateView.backgroundColor=[UIColor cyanColor];
        CATransition *transition = [CATransition animation];    //创建动画效果类
        transition.duration = 0.7;//设置动画时长
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];  //设置动画淡入淡出的效果
        transition.type = kCATransitionFromTop;//{kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};设置动画类型，移入，推出等
        //更多私有{@"cube",@"suckEffect",@"oglFlip",@"rippleEffect",@"pageCurl",@"pageUnCurl",@"cameraIrisHollowOpen",@"cameraIrisHollowClose"};
        transition.subtype = kCATransitionFromLeft;//{kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
        transition.delegate = self;//设置属性依赖
        [_cateView.layer addAnimation:transition forKey:nil];       //在图层增加动画效果
        // 要做的
        [_cateView exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
        //    __block CategoryViewController * weakSelf=self;
        //    [_cateView setBlock:^(NSDictionary *dict) {
        //        [weakSelf.activityView startAnimate];
        //        [weakSelf.groundingArr removeAllObjects];
        //        _categoryId=dict[@"cateId"];
        //        weakSelf.categoryLabel.text=dict[@"cateName"];
        //        _categoryName=dict[@"cateName"];
        //        groundingFirstQueryTime=@"";
        //        groundingPage=1;
        //        [weakSelf mercharList];
        //        i=0;
        //        [weakSelf.coverView removeFromSuperview];
        //    }];
        [self.view addSubview:_cateView];
        
        _backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-44-75)];
        _backView.backgroundColor=[UIColor blackColor];
        _backView.alpha=0.4;
        [self.view addSubview:_backView];
        
        UITapGestureRecognizer *longPressGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo)];
        //                longPressGR.minimumPressDuration = 1.0;
        [_backView addGestureRecognizer:longPressGR];
    }
    else
    {
        _jiantouImg.image=[UIImage imageNamed:@"图层-up"];
        [_backView removeFromSuperview];
        [_cateView removeFromSuperview];
    }
    
    

}

//-(void)creatView
//{
//    
//}
//
//-(void)dismissView
//{
//    
//}

#pragma mark - 手势绑定的方法
-(void)longPressToDo
{

    _jiantouImg.image=[UIImage imageNamed:@"图层-up"];
    _count=0;
    //    __block CategoryViewController * weakSelf=self;
    [_backView removeFromSuperview];
    [_cateView removeFromSuperview];
    //    groundingFirstQueryTime=@"";
    //    groundingPage=1;
    //    [self mercharList];
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
