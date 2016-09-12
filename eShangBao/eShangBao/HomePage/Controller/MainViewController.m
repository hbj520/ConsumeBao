//
//  MainViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/25.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "MainViewController.h"
#import "SYQViewController.h"
#import "XSRMViewController.h"
#import "ClassificationViewController.h"
#import "HHRViewController.h"
#import "AllianceViewController.h"
#import "AdvertisingUIScrollView.h"

//#import "SellerDataModel.h"
@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,WebViewBottmDelegate,FLAdViewDelegate,CLLocationManagerDelegate,jumpToCategaryDelegate,jumpToCategaryDelegates,pushDetailsVCDelegate>
{
    NSMutableArray * _imgArr;
//    NSMutableArray * _adImgArr;//广告图片数组
    NSMutableArray * _dataArr;
    NSMutableArray * _titleArr;
    NSString * _titleString;
    int _first;
    int _second;
    int _third;
    int _add;
    NSString       *firstQueryTime;
    NSString       *totalCount;
    int            page;
    
    NSString       *groundingFirstQueryTime;
    NSString       *groundingTotalCount;
    int            groundingPage;
    
//    TBActivityView *activityView;
    CLLocationManager *_locationManager;
    
    NSString * _type;//合伙人类型
    NSString * _partnerAgencyPayStatus;//付款状态
    NSInteger      _hotTotalCount;
    
    FLAdView *_adView;
    AdvertisingUIScrollView *advertisingView;
    
    
}

@property (nonatomic,strong) UIImageView *qrImageView;
@property (nonatomic,retain) NSMutableArray * nearDataArr;
@property (nonatomic,retain) NSMutableArray * sellerListArr;//下方广告图片数组
@property (nonatomic,retain) NSMutableArray * aboutUSArr;//关于我们数组
@property (nonatomic,strong) NSMutableArray * adModelArr;
@property (nonatomic,strong) NSMutableArray * hotAdImg;//热点
@property (nonatomic,retain) NSMutableArray * adImgArr;//广告图片数组
@property (nonatomic,strong) NSMutableArray * projectModelArr;//合伙人类别数据
@property (nonatomic,strong) NSMutableArray * usufructArr;//收益变换表
@property (nonatomic,strong) NSMutableArray * activityArr;//最下活动数组
@property (nonatomic,strong) TBActivityView * activityView;
@end

@implementation MainViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    NSDictionary * param=@{@"memberId":USERID};
    [RequstEngine requestHttp:@"1003" paramDic:param blockObject:^(NSDictionary *dic) {
        [_activityView stopAnimate];
        if ([dic[@"errorCode"] intValue]==00000) {
            _type=dic[@"member"][@"type"];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"member"][@"inviteCode"] forKey:@"inviteCode"];
            _partnerAgencyPayStatus=dic[@"member"][@"partnerAgencyPayStatus"];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"member"][@"phone"] forKey:@"selfPhone"];
        }
    }];

}

-(void)getGroundingList
{
    NSDictionary *pagination=@{@"page":[NSString stringWithFormat:@"%d",groundingPage],@"rows":@"4",@"firstQueryTime":groundingFirstQueryTime};
    
    NSDictionary * param=@{@"categoryId":@"",@"name":@"",@"isDeleted":@"",@"sortType":@"0"};
    
    [RequstEngine pagingRequestHttp:@"1067" paramDic:param pageDic:pagination blockObject:^(NSDictionary *dic) {
        DMLog(@"1067--%@",dic);
        DMLog(@"error---%@",dic[@"errorMsg"]);
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
        [_activityView stopAnimate];
        if ([dic[@"errorCode"] intValue]==0) {
            
            if ([dic[@"totalCount"] intValue]==0) {
                [self.tableView.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            }
            if ([dic[@"totalCount"] intValue]>0&&[dic[@"totalCount"] intValue]<=4) {
                [self.tableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            }
            
            NSDictionary *newDic=dic[@"proList"];
            if (newDic.count>0) {
                groundingPage++;
            }
            else
            {
                if (_add==1) {
                    [UIAlertView alertWithTitle:@"温馨提示" message:@"暂时没有更多的信息了" buttonTitle:nil];
                }
                
            }
            groundingFirstQueryTime=dic[@"firstQueryTime"];
            groundingTotalCount=dic[@"totalCount"];
            for (NSDictionary *dataDic in dic[@"proList"]) {
                
                GroundingModel * model=[[GroundingModel alloc]init];
                [model setValuesForKeysWithDictionary:dataDic];
                [_groundingArr addObject:model];
                //
            }
            
//             [self merchantsList];
            [_tableView reloadData];
        }
        
    }];
    
}

-(void)categoryList
{
    if (_categoryArr.count>0) {
        [_categoryArr removeAllObjects];
    }
    if (_aboutUSArr.count>0) {
        [_aboutUSArr removeAllObjects];
    }
    if (_imgArr.count>0) {
        [_imgArr removeAllObjects];
    }
    if (_adModelArr.count>0) {
        [_adModelArr removeAllObjects];
    }
    if (_adImgArr.count>0) {
        [_adImgArr removeAllObjects];
    }

    NSDictionary * param=@{@"shopId":@""};
    [RequstEngine requestHttp:@"1009" paramDic:param blockObject:^(NSDictionary *dic) {
        [_activityView stopAnimate];
        DMLog(@"1009---%@",dic);
        DMLog(@"error----%@",dic[@"errorMsg"]);
        if ([dic[@"errorCode"] intValue]==00000) {
            for (NSDictionary * newDic in dic[@"categoryList"]) {
                CategoryListModel * model=[[CategoryListModel alloc]init];
                [model setValuesForKeysWithDictionary:newDic];
                [_categoryArr addObject:model];
            }
            [RequstEngine requestHttp:@"1005" paramDic:nil blockObject:^(NSDictionary *dic) {
                DMLog(@"1005--%@",dic);
                if ([dic[@"errorCode"] intValue]==00000) {
//                    [activityView stopAnimate];
                    for (NSDictionary*newDic in dic[@"adLst"]) {
                        activityModel * model=[[activityModel alloc]init];
                        [model setValuesForKeysWithDictionary:newDic];
                        [_aboutUSArr addObject:model];
                        //                _aboutUSArr=[_imgArr subarrayWithRange:NSMakeRange(0, 1)];
                        [_imgArr addObject:newDic[@"imgUrl"]];
                        _hotTotalCount=_imgArr.count;
                        //            _third=_imgArr.count;
                    }
                    [RequstEngine requestHttp:@"1011" paramDic:nil blockObject:^(NSDictionary *dic) {
                        DMLog(@"1011--%@",dic);
//                        [activityView stopAnimate];
                        if ([dic[@"errorCode"]intValue]==00000) {
                            for (NSDictionary * newDic in dic[@"adLst"]) {
                                
                                if ([newDic[@"type"] intValue]==0) {
                                    [_adImgArr addObject:newDic[@"imgUrl"]];
                                    adModel *model=[[adModel alloc]init];
                                    [model setValuesForKeysWithDictionary:newDic];
                                    [_adModelArr addObject:model];
                                }
                                else
                                {
                                    
                                    //                [_adImgArr addObject:newDic[@"imgUrl"]];
                                    adModel *model=[[adModel alloc]init];
                                    [model setValuesForKeysWithDictionary:newDic];
                                    [_hotAdImg addObject:newDic[@"content"]];
                                    [_titleArr addObject:newDic[@"title"]];
                                    _titleString=[_titleArr componentsJoinedByString:@"      "];
                                }
                                
                            }
                            
                            _adView.imageArray=_adImgArr;
//                            [self getGroundingList];
                            [_tableView reloadData];
                           
                            
                        }
                        
                    }];
                    
                }
                
            }];
            

        }
    }];
}

#pragma mark - 获取等级列表
-(void)merchantsList
{
    
    NSDictionary *param=@{@"type":@"0",@"minLevel":@""};
    [RequstEngine requestHttp:@"1023" paramDic:param blockObject:^(NSDictionary *dic) {
        
        
        DMLog(@"dic=====%@",dic);
        if ([dic[@"errorCode"] intValue]==0) {
            
            [_projectModelArr removeAllObjects];
            for (NSDictionary *newDic in dic[@"categoryList"]) {
                ProjectIntroductionModel *model=[[ProjectIntroductionModel alloc]init];
                [model setValuesForKeysWithDictionary:newDic];
                [_projectModelArr addObject:model];
            }
            
            
        }
        
        
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }];
}

#pragma mark - 收益权变化
-(void)usufructChange
{
    
    NSDate * mydate = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    DMLog(@"---当前的时间的字符串 =%@",currentDateStr);
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:mydate];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:0];
    
    [adcomps setDay:-7];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    NSString *beforDate = [dateFormatter stringFromDate:newdate];
    [adcomps setDay:-1];
    NSDate *newdate2 = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    NSString *beforDate2 = [dateFormatter stringFromDate:newdate2];
    DMLog(@"---前7天=%@",beforDate);
    DMLog(@"---前7天=%@",beforDate2);
    
    
    
    
    NSDictionary *param=@{@"startDate":beforDate,@"endDate":beforDate2};
    [RequstEngine requestHttp:@"1085" paramDic:param blockObject:^(NSDictionary *dic) {
        
        
        DMLog(@"%@",dic);
        if ([dic[@"errorCode"] intValue]==0) {
            
            [_usufructArr removeAllObjects];
            for (NSDictionary *newDic in dic[@"recordList"]) {
                UsufructModel *model=[[UsufructModel alloc]init];
                [model setValuesForKeysWithDictionary:newDic];
                [_usufructArr addObject:model];
            }
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    }];
}


-(void)createActivityRequset
{
    [RequstEngine requestHttp:@"1005" paramDic:nil blockObject:^(NSDictionary *dic) {
        
        DMLog(@"%@",dic);
        if ([dic[@"errorCode"] intValue]==0) {
            
            [_activityArr removeAllObjects];
            [advertisingView removeImageView];
            NSDictionary *newDic=dic[@"adLst"];
            for (NSDictionary *adLst in newDic) {
                
                activityModel *model=[[activityModel alloc]init];
                [model setValuesForKeysWithDictionary:adLst];
                [_activityArr addObject:model];
            }
            
            advertisingView.activityArr=_activityArr;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
           // NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndexSet:4];
            
        }
        
    }];
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"消费宝";
    
    UILabel *backLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 1)];
    backLabel.backgroundColor=BGMAINCOLOR;
    [self.tabBarController.tabBar addSubview:backLabel];
    
    
    [self createAdView];
    [self createActivityView];
    _add=0;
    self.navigationController.navigationBarHidden=NO;
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTimer" object:nil];
    _imgArr=[NSMutableArray arrayWithCapacity:0];
    _adImgArr=[NSMutableArray arrayWithCapacity:0];
    _aboutUSArr=[NSMutableArray arrayWithCapacity:0];
    _adModelArr=[NSMutableArray arrayWithCapacity:0];
    _hotAdImg=[NSMutableArray arrayWithCapacity:0];
    _titleArr=[NSMutableArray arrayWithCapacity:0];
    _projectModelArr=[NSMutableArray arrayWithCapacity:0];
    _usufructArr =[NSMutableArray arrayWithCapacity:0];
    _activityArr =[NSMutableArray arrayWithCapacity:0];
    
    [self merchantsList];
    [self usufructChange];
    [self createActivityRequset];
    //    _titleString=[[NSMutableString alloc]init];
    _third=1;
    
    
    //    page=1;
    //    firstQueryTime=@"";
    //    [_sellerListArr removeAllObjects];
    
    [self categoryList];
    
    [self creataLocationManager];
    [self backButton];
    
    page=1;
    firstQueryTime=@"";
    //[self merchantsList];
    groundingPage=1;
    groundingFirstQueryTime=@"";
    [self getGroundingList];
    _nearDataArr=[NSMutableArray arrayWithCapacity:0];
    _sellerListArr=[NSMutableArray arrayWithCapacity:0];
    _groundingArr=[NSMutableArray arrayWithCapacity:0];
    _categoryArr=[NSMutableArray arrayWithCapacity:0];
    
    _first=1;
    _second=1;
   
    
    [self loadUI];
    
    //上拉
    __block MainViewController * weakSelf=self;

    //下拉刷新
    [_tableView addLegendHeaderWithRefreshingBlock:^{
//        _fresh=1;
        [weakSelf.activityView startAnimate];
        
        page=1;
        firstQueryTime=@"";
        [weakSelf.sellerListArr removeAllObjects];
        //[weakSelf merchantsList];
        
        _add=0;
        groundingFirstQueryTime=@"";
        groundingPage=1;
        
        [weakSelf.groundingArr removeAllObjects];
        [weakSelf getGroundingList];
        [weakSelf merchantsList];
        [weakSelf usufructChange];
        [weakSelf createActivityRequset];
        [weakSelf.adImgArr removeAllObjects];
        [weakSelf categoryList];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"stopTimer" object:nil];
    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tongzhi:) name:@"notification" object:nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)createAdView
{
    _adView = [[FLAdView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, W(180))];
    //_adView.imageArray = @[@"u8",@"u10.jpg",@"u12.jpg"];
    _adView.location = PageControlCenter;//设置pagecontrol的位置
    _adView.currentPageColor = [UIColor redColor];//选中pagecontrol的颜色
    _adView.normalColor = [UIColor whiteColor];//未选中的pagecontol的颜色
    _adView.chageTime = 3.0f;//定时时间 默认3秒
    _adView.flDelegate=self;
    
}
-(void)createActivityView
{
    advertisingView=[[AdvertisingUIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 180)];
    advertisingView.webDelegate=self;
}

-(void)loadUI
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 30, WIDTH, HEIGHT-59) style:1];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.sectionFooterHeight=0;
    _tableView.sectionHeaderHeight=0;
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableView.separatorStyle=0;
    [self.view addSubview:_tableView];
    
    _scanBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _scanBtn.frame=CGRectMake( W(40), H(3), W(20), H(20));
    _scanBtn.enabled=NO;
    [_scanBtn addTarget:self action:@selector(scanAction) forControlEvents:1<<6];
    [_scanBtn setImage:[UIImage imageNamed:@"商城主页1_05"] forState:0];
    UIBarButtonItem*rightItem1=[[UIBarButtonItem alloc]initWithCustomView:_scanBtn];
    self.navigationItem.rightBarButtonItem=rightItem1;
    
    _erweimaBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _erweimaBtn.frame=CGRectMake( W(40), H(3), W(20), H(20));
    _erweimaBtn.enabled=NO;
    [_erweimaBtn addTarget:self action:@selector(createCode) forControlEvents:1<<6];
    [_erweimaBtn setImage:[UIImage imageNamed:@"商城主页1_03"] forState:0];
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:_erweimaBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    
    
    _activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    
    _activityView.rectBackgroundColor=MAINCOLOR;
    
    _activityView.showVC=self;
    [self.view addSubview:_activityView];
    
    [_activityView startAnimate];
}

-(void)tongzhi:(NSNotification*)text
{
    NSString * userId=text.userInfo[@"shopID"];
    if (userId.length==0) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"该商品已下架" buttonTitle:nil];
    }
    else
    {
        StoreInfoViewController * vc=[[StoreInfoViewController alloc]init];
        vc.hidesBottomBarWhenPushed=YES;
        vc.shopID=text.userInfo[@"shopID"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
#pragma mark - 定位服务
-(void)creataLocationManager
{
    _locationManager=[[CLLocationManager alloc]init];
    _locationManager.delegate=self;
    _locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
    _locationManager.distanceFilter=1000;
    if ([CLLocationManager locationServicesEnabled]) {
        // 启动位置更新
        // 开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
        [_locationManager startUpdatingLocation];
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    else {
        
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请开启定位功能" buttonTitle:nil];
    }
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSString *latitude;
    NSString *longitude;
    for(CLLocation *location in locations){
        latitude=[NSString stringWithFormat:@"%f",location.coordinate.latitude];
        longitude=[NSString stringWithFormat:@"%f",location.coordinate.longitude];
    }
    
    CLLocation *currLocation=[locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];//反向解析，根据及纬度反向解析出地址
    CLLocation *location = [locations objectAtIndex:0];
    
    NSUserDefaults *usereDef=[NSUserDefaults standardUserDefaults];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for(CLPlacemark *place in placemarks)
        {
            //取出当前位置的坐标
            DMLog(@"latitude : %f,longitude: %f",currLocation.coordinate.latitude,currLocation.coordinate.longitude);
            NSDictionary *dict = [place addressDictionary];
            NSString *cityStr=dict[@"City"];
            NSString *cityName=[cityStr substringToIndex:[cityStr length]-1];
            [usereDef setObject:cityName forKey:@"userCity"];
            [usereDef synchronize];
            
            DMLog(@"--------%@",dict[@"City"]);
        }
    }];
    [usereDef setObject:latitude forKey:@"latitude"];
    [usereDef setObject:longitude forKey:@"longitude"];
    [usereDef synchronize];
    
    [manager stopUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSString *errorString;
    [manager stopUpdatingLocation];
    NSLog(@"Error: %@",[error localizedDescription]);
    switch([error code]) {
        case kCLErrorDenied:
        {
            //Access denied by user
            
            errorString = @"该程序定位不可用,请到隐私中打开定位开关";
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:errorString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
            
            break;
    }
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 150+W(180);
        
    }
    else if (indexPath.section==1)
    {
        
        long projectNum=(_projectModelArr.count+1)/2;
        return 75*projectNum+43;
    }
    else if(indexPath.section==2)
    {
        return 203;
        
    }
    else
    {
        return 185;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return _first;
    }
    else if (section==1)
    {
        return 1;
    }
    else if (section==2)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        ElseTableViewCell * cell=[ElseTableViewCell StatusTableView:tableView Array:nil cellForRowAtIndexPath:indexPath];
        cell.selectionStyle=0;
        cell.button1.tag=10;
        cell.button2.tag=11;
        cell.button3.tag=12;
        cell.button4.tag=13;
        [cell.button1 addTarget:self action:@selector(jumpToOther:) forControlEvents:1<<6];
        [cell.button2 addTarget:self action:@selector(jumpToOther:) forControlEvents:1<<6];
        [cell.button3 addTarget:self action:@selector(jumpToOther:) forControlEvents:1<<6];
        [cell.button4 addTarget:self action:@selector(jumpToOther:) forControlEvents:1<<6];
        cell.categoryArr=_categoryArr;
        cell.delegate=self;
        [_adView removeFromSuperview];
        if (_adImgArr.count>0) {
            //cell.adView.flDelegate=self;
            [cell.contentView addSubview:_adView];
            //cell.adView.imageArray=_adImgArr;
        }
        else
        {
            cell.recImg.image=[UIImage imageNamed:@"默认banner"];
        }
//        DMLog(@"string----%@",_titleString);
        cell.titleStr=_titleString;
        return cell;
    }
    else if (indexPath.section==1)
    {
        HotActivityTableViewCell * hotcell=[tableView dequeueReusableCellWithIdentifier:@"cell6"];
        if (!hotcell) {
            hotcell=[[HotActivityTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell6"];
        }
        
        hotcell.dataModelArr=_projectModelArr;
        hotcell.mydelegate=self;
        hotcell.selectionStyle=0;
        return hotcell;
    }
    else if (indexPath.section==2)
    {
        NSInteger height=ceilf(_sellerListArr.count/2.);
        RecommendTableViewCell * cell=[RecommendTableViewCell nowStatusWithTableView:_tableView section:height cellForRowAtIndexPath:indexPath];
        cell.selectionStyle=0;
        cell.layer.masksToBounds=YES;
        cell.type=0;
        cell.detailsButton.tag=11;
        [cell.detailsButton addTarget:self action:@selector(jumpToOther:) forControlEvents:1<<6];
        if (_usufructArr.count>0) {
            cell.dataArr=_usufructArr;
        }
        
        return cell;
    }
    else
    {
        NSInteger height=ceilf(_groundingArr.count/2.);

        GroundingTableViewCell * cell=[GroundingTableViewCell nowStatusWithTableView:_tableView section:height cellForRowAtIndexPath:indexPath];
        cell.selectionStyle=0;
        cell.delegate=self;
        [advertisingView removeFromSuperview];
        if (_activityArr.count>0) {
            [cell.contentView addSubview:advertisingView];
        }
        //cell.dataArr=_groundingArr;
       // cell.model=model;
        cell.layer.masksToBounds=YES;
        return cell;
    }
   
}

-(void)scrollWebImageTaped:(UIImageView *)imageView
{
    
    
    activityModel *model=_activityArr[imageView.tag-10];
    AdvertisingViewController *advertringVC=[[AdvertisingViewController alloc]init];
    advertringVC.hidesBottomBarWhenPushed=YES;
    advertringVC.acModel=model;
    advertringVC.add=1;
    [self.navigationController pushViewController:advertringVC animated:YES];

    DMLog(@"%@",model);
    
}

#pragma mark - 滚动图的点击方法
-(void)imageTaped:(UIImageView *)imageView{
    
    adModel *model=_adModelArr[imageView.tag-10];
    AdvertisingViewController *advertringVC=[[AdvertisingViewController alloc]init];
    advertringVC.hidesBottomBarWhenPushed=YES;
    advertringVC.adModel=model;
    advertringVC.add=0;
    [self.navigationController pushViewController:advertringVC animated:YES];
}

#pragma mark - 按钮跳转的方法
-(void)jumpToOther:(UIButton*)sender
{
    switch (sender.tag) {
        case 10:
        {
//            if (![NSString isLogin]) {
//                [self loginUser];
//            }
//            else
//            {
//                if (([_type intValue]==2||[_type intValue]==1)&&[_partnerAgencyPayStatus intValue]==1) {
//                    if ([_type intValue]==2) {
//                        [UIAlertView alertWithTitle:@"温馨提示" message:@"您已是合伙人，不需要重新加盟!" buttonTitle:nil];
//                    }
//                    else
//                    {
//                        [UIAlertView alertWithTitle:@"温馨提示" message:@"您已是合伙人，不需要重新加盟!" buttonTitle:nil];
//                    }
//                    
//                }
//                else
//                {
            XFZCViewController *allianceVC=[[XFZCViewController alloc]init];
            allianceVC.projectModelArr=_projectModelArr;
            allianceVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:allianceVC animated:YES];
//                }
            
//            }
           
        }
            break;
        case 11:
        {
            //[UIAlertView alertWithTitle:@"温馨提示" message:@"暂未开通此功能，敬请期待!" buttonTitle:nil];
            SYQViewController *syqView=[[SYQViewController alloc]init];
            syqView.usufructArr=_usufructArr;
            syqView.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:syqView animated:YES];
        }
            break;
        case 12:
        {
            if (![NSString isLogin]) {
                [self loginUser];
            }
            else
            {
                if (([_type intValue]==2||[_type intValue]==1)&&[_partnerAgencyPayStatus intValue]==1) {
                    if ([_type intValue]==2) {
                        [UIAlertView alertWithTitle:@"温馨提示" message:@"您已是合伙人，不需要重新加盟!" buttonTitle:nil];
                    }
                    else
                    {
                        [UIAlertView alertWithTitle:@"温馨提示" message:@"您已是合伙人，不需要重新加盟!" buttonTitle:nil];
                    }
                    
                }
                else
                {
                    PartnerViewController*partnerVC=[[PartnerViewController alloc]init];
                    partnerVC.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:partnerVC animated:YES];

                }
            }
           
        }
            break;
        case 13:
        {
//            [UIAlertView alertWithTitle:@"温馨提示" message:@"暂未开通此功能，敬请期待!" buttonTitle:nil];
            XSRMViewController *xsrmView=[[XSRMViewController alloc]init];
            xsrmView.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:xsrmView animated:YES];
        }
            break;
        default:
            break;
    }
//    DMLog(@"sender.tag=%ld",sender.tag);
}
-(void)pushDetailsVC:(ProjectIntroductionModel *)projectModel{
    
    
    HHRViewController *hhrVC=[[HHRViewController alloc]init];
    hhrVC.projectModel=projectModel;
    hhrVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:hhrVC animated:YES];
    
}

-(void)jumpToAd:(UIButton*)sender
{
    if (_aboutUSArr.count>0) {
        switch (sender.tag) {
            case 10:
            {
                activityModel * model=_aboutUSArr[0];
                AdvertisingViewController *advertringVC=[[AdvertisingViewController alloc]init];
                advertringVC.hidesBottomBarWhenPushed=YES;
                advertringVC.acModel=model;
                advertringVC.add=1;
                [self.navigationController pushViewController:advertringVC animated:YES];
            }
                
                break;
                
            case 11:
            {
                if (_aboutUSArr.count>=2) {
                    activityModel * model=_aboutUSArr[1];
                    AdvertisingViewController *advertringVC=[[AdvertisingViewController alloc]init];
                    advertringVC.hidesBottomBarWhenPushed=YES;
                    advertringVC.acModel=model;
                    advertringVC.add=1;
                    [self.navigationController pushViewController:advertringVC animated:YES];
                }
                else
                {
                    [UIAlertView alertWithTitle:@"温馨提示" message:@"暂无活动,敬请期待" buttonTitle:nil];
                }
            }
                
                break;
                
            case 12:
            {
                if (_aboutUSArr.count>=3) {
                    activityModel * model=_aboutUSArr[2];
                    AdvertisingViewController *advertringVC=[[AdvertisingViewController alloc]init];
                    advertringVC.hidesBottomBarWhenPushed=YES;
                    advertringVC.acModel=model;
                    advertringVC.add=1;
                    [self.navigationController pushViewController:advertringVC animated:YES];
                }
                else{
                    [UIAlertView alertWithTitle:@"温馨提示" message:@"暂无活动,敬请期待" buttonTitle:nil];
                }
            }
                
                break;
            default:
                break;
        }

    }

}
//-(void)addMore:(UIButton *)button
//{
//    [_activityView startAnimate];
//    _add=1;
////    if (_sellerListArr.count<4) {
////        [_sellerListArr removeAllObjects];
////        page=1;
////        firstQueryTime=@"";
////        [self merchantsList];
////        [_tableView reloadData];
////    }
////    else
////    {
//        [self merchantsList];
//        [_tableView reloadData];
////    }
//    
//}

-(void)addMoreCell:(UIButton * )button
{
//    DMLog(@"button.tag=%ld",button.tag);
    _third+=1;

    if (_third-1>=_imgArr.count) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"没有更多的信息了" buttonTitle:nil];
    }
    else
    {
//        _aboutUSArr=[_imgArr subarrayWithRange:NSMakeRange(0, _third)];
        [_tableView reloadData];
    }

    DMLog(@"---%@",_aboutUSArr);
}


#pragma mark - 扫描按钮绑定的方法
-(void)scanAction
{
    if (![NSString isLogin]) {
        [self loginUser];
    }
    else
    {
        ScanerVC *scanVC=[[ScanerVC alloc]init];
        scanVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:scanVC animated:YES];

    }
}

#pragma mark - 生成二维码按钮绑定的方法
-(void)createCode
{
    if (![NSString isLogin]) {
        [self loginUser];
    }
    else
    {
        CreateCodeViewController * createVC=[[CreateCodeViewController alloc]init];
        createVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:createVC animated:YES];
    }
    
}

-(void)pushView:(int)vcType
{
    
    DMLog(@"%d",vcType);
    switch (vcType) {
        case 0:
            
            [UIAlertView alertWithTitle:@"温馨提示" message:@"暂未开通此功能，敬请期待!" buttonTitle:nil];
            
            break;
        case 1:
        {
            if (![NSString isLogin]) {
                [self loginUser];
            }
            else
            {
//                if (([_type intValue]==2||[_type intValue]==1)&&[_partnerAgencyPayStatus intValue]==1) {
                
                    self.tabBarController.selectedIndex=vcType;
//                }
//                else
//                {
//                    AllianceViewController * coinVC=[[AllianceViewController alloc]init];
//                    coinVC.whichPage=@"1";
//                    coinVC.titleStr=@"联营超市";
//                    coinVC.hidesBottomBarWhenPushed=YES;
//                    [self.navigationController pushViewController:coinVC animated:YES];
//                }

            }
            
            
#warning 需要判段入口类型
            //self.tabBarController.selectedIndex=vcType;
        }
            
            
            break;
        case 2:
        {
            ClassificationViewController *classificationVC=[[ClassificationViewController alloc]init];
            //classificationVC.categoryArr=[_categoryArr mutableCopy];
            classificationVC.vcType=1;
            //classificationVC.index=(int)newBtn.tag;
            classificationVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:classificationVC animated:YES];
        }
            

            
            break;
        case 3:
            
            self.tabBarController.selectedIndex=vcType;
            
            break;
            
        default:
            break;
    }
    
    
//    [self.navigationController pushViewController:VC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
