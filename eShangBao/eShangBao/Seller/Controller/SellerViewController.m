//
//  SellerViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/13.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "SellerViewController.h"
#import "SellerTableViewCell.h"
#import "ClassificationViewController.h"
#import "StoreInfoViewController.h"
#import "SearchViewController.h"
#import "SellerDataModel.h"
#import "ChooseProvinceViewController.h"
#import "HomeModel.h"
#import "CityModel.h"
#import "LoginViewController.h"
#import "FLAdView.h"
#import "SellerDataModel.h"
#import "AdvertisingViewController.h"

#import "LoginViewController.h"




@interface SellerViewController ()<FLAdViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
//    NSString       *firstQueryTime;
    NSString       *totalCount;
//    int            page;
    int            typeIndex;//记录是那个分类按钮
    CityModel      *myProvinceModel;
    UIButton       *left;//选地址ID
    NSString       *cityID;
    BOOL           isLocation;//判断是否定位过
    FLAdView       *adView;
    TBActivityView *activityView;
     BOOL          isPush;//0 上拉；1 下拉
    int            _fresh;
    
    
}
//@property(nonatomic,strong)NSString * fresh;

@property(nonatomic,strong)NSMutableArray          *latestDataArr;//最新商家的数据
@property(nonatomic,strong)NSMutableArray          *nearDataArr;//附近的数据
@property(nonatomic,strong)NSMutableArray          *oftenDataArr;//常去商家
@property(nonatomic,strong)UIButton                *selectedBtn;//当前选择的button
@property(nonatomic,strong)NSMutableArray          *categoryArr;//分类的Arr
@property(nonatomic,strong)NSMutableArray          *adImgArr;
@property(nonatomic,strong)NSMutableArray          *adModelArr;//广告内容

@end

@implementation SellerViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"商家";
    
    isLocation=NO;
    typeIndex=1;
    [self createHeadView];
//    page=1;
//    firstQueryTime=@"";
    cityID=@"";
    _nearDataArr    =[NSMutableArray arrayWithCapacity:0];
    _latestDataArr  =[NSMutableArray arrayWithCapacity:0];
    _oftenDataArr   =[NSMutableArray arrayWithCapacity:0];
    _categoryArr    =[NSMutableArray arrayWithCapacity:0];
    _adImgArr       =[NSMutableArray arrayWithCapacity:0];
    _adModelArr     =[NSMutableArray arrayWithCapacity:0];
    
    [self backButton];
    
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
     [activityView startAnimate];
    
    [self createNavigationButton];
    
    
    [self addLegendHeader];
    
   

}

-(void)createHeadView
{
    _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 115+W(190))];
    _advertisingView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, W(150))];
    [_headView addSubview:_advertisingView];
    
    _categoryView=[[UIView alloc]initWithFrame:CGRectMake(0, W(150)+1, KScreenWidth, 75)];
    _categoryView.backgroundColor=[UIColor whiteColor];
    _categoryScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 75)];
    [_headView addSubview:_categoryView];
    
    [_categoryView addSubview:_categoryScrollView];
    
    _titleView=[[UIView alloc]initWithFrame:CGRectMake(0, W(150)+76, KScreenWidth, 38)];
    _titleView.backgroundColor=[UIColor whiteColor];
    _fujiBtn=[UIButton buttonWithType:0];
    _fujiBtn.frame=CGRectMake(0, 0, 105, 38);
    [_fujiBtn setTitle:@"附近商家" forState:0];
    _fujiBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [_fujiBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
    _fujiBtn.tag=1;
    [_fujiBtn addTarget:self action:@selector(categoryButtonClick:) forControlEvents:1<<6];
    [_titleView addSubview:_fujiBtn];
    
    
    _zuixingBtn=[UIButton buttonWithType:0];
    [_zuixingBtn setTitle:@"最新商家" forState:0];
    _zuixingBtn.frame=CGRectMake(105, 0, 109, 38);
    _zuixingBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [_zuixingBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
    _zuixingBtn.tag=2;
    [_zuixingBtn addTarget:self action:@selector(categoryButtonClick:) forControlEvents:1<<6];
    [_titleView addSubview:_zuixingBtn];
    
    _changquBtn=[UIButton buttonWithType:0];
    [_changquBtn setTitle:@"经常去的" forState:0];
    _changquBtn.frame=CGRectMake(214, 0, 106, 38);
    _changquBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [_changquBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
    [_titleView addSubview:_changquBtn];
    _changquBtn.tag=3;
    [_changquBtn addTarget:self action:@selector(categoryButtonClick:) forControlEvents:1<<6];
    [_headView addSubview:_titleView];
    
    _selectedLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 34, 80, 2)];
    _selectedLabel.backgroundColor=MAINCOLOR;
    [_titleView addSubview:_selectedLabel];
    _bottomBtn=[[UILabel alloc]init];
    _bottomBtn.backgroundColor=MAINCOLOR;
    _bottomBtn.frame=CGRectMake(0, CGRectGetMaxY(_changquBtn.frame), KScreenWidth, 1);
    [_titleView addSubview:_bottomBtn];
    

    
    [self adapterView];

    
}

-(void)adapterView
{
    
    float ratioH=(KScreenHeight>568)?KScreenHeight/ 568.0:1;
    
    _headView.frame=CGRectMake(_headView.frame.origin.x, _headView.frame.origin.y, KScreenWidth, (114+W(150))*ratioH);
    _myTableVeiw.tableHeaderView=_headView;
    _myTableVeiw.frame=CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    _advertisingView.frame=CGRectMake(0, 0, KScreenWidth, ratioH*W(150));
    _categoryView.frame=CGRectMake(0, CGRectGetMaxY(_advertisingView.frame)+1, KScreenWidth, ratioH*70);
    _categoryScrollView.frame=CGRectMake(0, 0, KScreenWidth, CGRectGetHeight(_categoryView.frame));
    _titleView.frame=CGRectMake(0, CGRectGetMaxY(_categoryView.frame)+5, KScreenWidth, ratioH*38);
    
    float btnW=KScreenWidth/3.;
    _fujiBtn.frame=CGRectMake(0, 0, btnW, CGRectGetHeight(_titleView.frame)-1);
    _zuixingBtn.frame=CGRectMake(btnW, 0, btnW, CGRectGetHeight(_titleView.frame)-1);
    _changquBtn.frame=CGRectMake(2*btnW, 0, btnW, CGRectGetHeight(_titleView.frame)-1);
    _bottomBtn.frame=CGRectMake(0, CGRectGetMaxY(_changquBtn.frame)+1, KScreenWidth, 1);
    _selectedLabel.center=CGPointMake(_fujiBtn.center.x, _fujiBtn.frame.size.height);
    
    [self advertisingPlay];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    
//    if (isPush)return;
    
    _fresh=1;
    [self merchantsList:typeIndex];
    [super viewWillAppear:animated];
    
    if (_adModelArr.count==0) {
        
        [_adModelArr removeAllObjects];
        [self requsetAdvertising];
    }
    if (_categoryArr.count==0) {
        
        [_categoryArr removeAllObjects];
        [self requestStoreListData];
    }
    
}

#pragma mark -  轮播图广告
-(void)advertisingPlay
{
    float ratioH=(KScreenHeight>568)?KScreenHeight/ 568.0:1;
    adView = [[FLAdView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, ratioH*W(150))];
    adView.location = PageControlCenter;//设置pagecontrol的位置
    adView.currentPageColor = [UIColor redColor];//选中pagecontrol的颜色
    adView.normalColor = [UIColor whiteColor];//未选中的pagecontol的颜色
    adView.chageTime = 3.0f;//定时时间 默认3秒
    adView.flDelegate = self;//图片点击事件delegate
    [_advertisingView addSubview:adView];
    //[self requsetAdvertising];
}

-(void)requsetAdvertising
{
    
    [RequstEngine requestHttp:@"1011" paramDic:nil blockObject:^(NSDictionary *dic) {
        DMLog(@"1011--%@",dic);
        
        for (NSDictionary * newDic in dic[@"adLst"]) {
            if ([newDic[@"type"] intValue]==2) {
                [_adImgArr addObject:newDic[@"imgUrl"]];
                adModel *model=[[adModel alloc]init];
                [model setValuesForKeysWithDictionary:newDic];
                [_adModelArr addObject:model];
            }
        }
        adView.imageArray=_adImgArr;
        if (_adImgArr.count==0) {
            adView.hidden=YES;
        }
        else
        {
            adView.hidden=NO;
        }
    }];
}

-(void)imageTaped:(UIImageView *)imageView
{
    adModel *model=_adModelArr[imageView.tag-10];
    
    AdvertisingViewController *advertisVC=[[AdvertisingViewController alloc]init];
    advertisVC.hidesBottomBarWhenPushed=YES;
    advertisVC.adModel=model;
    advertisVC.add=0;
    [self.navigationController pushViewController:advertisVC animated:YES];
//    DMLog(@"%ld",imageView.tag);
    DMLog(@"sdsdd");
}

-(void)addLegendHeader
{
    __block NSMutableArray *newDataArr=[NSMutableArray arrayWithCapacity:0];
    //上拉
    
    
   
    
    [_myTableVeiw addLegendFooterWithRefreshingBlock:^{
        
        if (isPush) return ;
        _fresh=0;
        SellerListModel *mianModl=[self backCurrentModel];
        totalCount=mianModl.totalCount;
        
        if (typeIndex==1) {
            newDataArr=[_nearDataArr copy];
        }
        if (typeIndex==2) {
            newDataArr= [_latestDataArr copy];
        }
        if (typeIndex==3) {
            newDataArr= [_oftenDataArr copy];
        }
        
        if ([totalCount intValue]==0) {
            
            [self.myTableVeiw.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            [self.myTableVeiw.footer endRefreshing];
            
            return ;
        }
        if ([totalCount intValue]>0&&[totalCount intValue]<=10) {
            [self.myTableVeiw.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            [self.myTableVeiw.footer endRefreshing];
            return ;
        }
        if ([totalCount intValue]==newDataArr.count&&[totalCount intValue]>10) {
            [self.myTableVeiw.footer endRefreshing];
            [self.myTableVeiw.footer setTitle:@"没有更多了..." forState:MJRefreshFooterStateIdle];
            return ;
        }
        
        [self merchantsList:typeIndex];
    }];
    
    //下拉刷新
    [_myTableVeiw addLegendHeaderWithRefreshingBlock:^{
        
        _fresh=1;
        [_headView removeFromSuperview];
        [self createHeadView];
        
        [_adImgArr removeAllObjects];
        [activityView startAnimate];
        [self requsetAdvertising];
        
        [_categoryArr removeAllObjects];
        [self requestStoreListData];
        
        
        [self merchantsList:typeIndex];
        
    }];
    [self.myTableVeiw.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
}

#pragma mark - 请求数据
//请求分类列表
-(void)requestStoreListData
{
    [RequstEngine requestHttp:@"1008" paramDic:nil blockObject:^(NSDictionary *dic) {
        [activityView stopAnimate];
        DMLog(@"%@",dic);
        if ([dic[@"errorCode"] intValue]==0) {
            
           //
            for (NSDictionary *newDic in dic[@"categoryList"]) {
                
                CategoryListModel *model=[[CategoryListModel alloc]init];
                [model setValuesForKeysWithDictionary:newDic];
                [_categoryArr addObject:model];
            }
                        
            [self createCategoryButton];
        }
        else{
            
            //[];
            
        }
        
        
    }];
}



-(void)createCategoryButton
{
    if (_categoryArr.count<=4) {
        
        float  vieWidth=KScreenWidth/_categoryArr.count;
        for (int i=0; i<_categoryArr.count; i++) {

            CategoryListModel *model=_categoryArr[i];
            UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake(vieWidth*i, 0, vieWidth, H(75))];
            //btnView.backgroundColor=RGBACOLOR(40*i, 20*i, 20, 1);
            [_categoryScrollView addSubview:btnView];
            
            
            UILabel *categoryName=[[UILabel alloc]initWithFrame:CGRectMake(0, W(36)+W(8)+W(5), vieWidth, 14)];
            categoryName.font=[UIFont systemFontOfSize:12];
            categoryName.textAlignment=1;
            categoryName.text=model.cateName;
            categoryName.textColor=MAINCHARACTERCOLOR;
            [btnView addSubview:categoryName];
            
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, H(8), W(36), W(36))];
            imageView.center=CGPointMake(categoryName.center.x, imageView.center.y);
            imageView.backgroundColor=MAINCOLOR;
            imageView.layer.cornerRadius=imageView.frame.size.height/2.;
            imageView.layer.masksToBounds=YES;
            [imageView setImageWithURLString:model.iconUrl placeholderImage:DEFAULTIMAGE];
            [btnView addSubview:imageView];
            
            
            
//            UILabel *categoryName=[[UILabel alloc]initWithFrame:CGRectMake(0, 48, vieWidth, 14)];
//            categoryName.font=[UIFont systemFontOfSize:12];
//            categoryName.textAlignment=1;
//            categoryName.text=model.cateName;
//            categoryName.textColor=MAINCHARACTERCOLOR;
//            [btnView addSubview:categoryName];
            
            
            UIButton *chooseCategoryBtn=[[UIButton alloc]initWithFrame:btnView.bounds];
            chooseCategoryBtn.tag=i;
            [chooseCategoryBtn addTarget:self action:@selector(speciesButtonClick:) forControlEvents:1<<6];
            [btnView addSubview:chooseCategoryBtn];


        }
        return;
    }else{
        
        float  vieWidth=KScreenWidth/4-W(10);
        for (int i=0; i<_categoryArr.count; i++) {
            
            CategoryListModel *model=_categoryArr[i];
            UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake(vieWidth*i, 0, vieWidth, H(70))];
            // btnView.backgroundColor=RGBACOLOR(40*i, 30*i, 20, 1);
            [_categoryScrollView addSubview:btnView];
            
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(W(25), W(8), W(36), W(36))];
//            imageView.backgroundColor=MAINCOLOR;
            imageView.layer.cornerRadius=imageView.frame.size.height/2.;
            imageView.layer.masksToBounds=YES;
            [imageView setImageWithURLString:model.iconUrl placeholderImage:DEFAULTIMAGE];
            [btnView addSubview:imageView];
            
            UILabel *categoryName=[[UILabel alloc]initWithFrame:CGRectMake(W(3), kDown(imageView)+W(5), vieWidth+W(10), 14)];
//            categoryName.backgroundColor=[UIColor cyanColor];
            categoryName.textAlignment=NSTextAlignmentCenter;
            categoryName.font=[UIFont systemFontOfSize:12];
            categoryName.textAlignment=1;
            categoryName.text=model.cateName;
            categoryName.textColor=MAINCHARACTERCOLOR;
            [btnView addSubview:categoryName];
            
            UIButton *chooseCategoryBtn=[[UIButton alloc]initWithFrame:btnView.bounds];
            chooseCategoryBtn.tag=i;
            [chooseCategoryBtn addTarget:self action:@selector(speciesButtonClick:) forControlEvents:1<<6];
            [btnView addSubview:chooseCategoryBtn];
            
        }
        _categoryScrollView.contentSize=CGSizeMake(vieWidth*_categoryArr.count, 0);
  
    }

}

-(void)merchantsList:(int)type
{
    //待处理  需要传经纬度 0：附近商家 1：最新商家 2常去商家 3：评分最高 4起送家最低 5销售最高 6综合排序
    
    
    NSDictionary *param=@{@"isRecommend":@"",@"type":[NSString stringWithFormat:@"%d",type-1],@"shopName":@"",@"categoryId":@"",@"isSupportGold":@"",@"latitude":LATITUDE,@"longitude":LONGITUDE,@"cityId":cityID,@"isShop":@"",@"isOpenning":@""};
    
    DMLog(@"%@",param);
    //拿到当前最后一个的model
    NSString * pageStr;
    NSString * firstQueryTime;
    if (_fresh==1) {
        pageStr=@"1";
        firstQueryTime=@"";
        
    }
    else
    {
        SellerListModel *mianModl=[self backCurrentModel];
        pageStr=(mianModl==nil)?[NSString stringWithFormat:@"%d",1]:mianModl.page;
        firstQueryTime=(mianModl==nil)?@"":mianModl.firstQueryTime;

    }
       NSDictionary *pagination=@{@"page":pageStr,@"rows":@"10",@"firstQueryTime":firstQueryTime};
    
    DMLog(@"%@====%@",param,pagination);
    [RequstEngine pagingRequestHttp:@"1006" paramDic:param pageDic:pagination blockObject:^(NSDictionary *dic) {
        DMLog(@"%@",dic);

        [activityView stopAnimate];
        [self.myTableVeiw.footer endRefreshing];
        [self.myTableVeiw.header endRefreshing];
        isPush=NO;//解除标示是是否是选择的城市的操作
        if ([dic[@"errorCode"] intValue]==0) {
            

            
            if (_fresh==1) {
                if (typeIndex==1) {
                    [_nearDataArr removeAllObjects];
                }
                if (typeIndex==2) {
                    [_latestDataArr removeAllObjects];
                }
                if (typeIndex==3) {
                    [_oftenDataArr removeAllObjects];
                }

            }
            if ([dic[@"totalCount"] intValue]==0) {
                [self.myTableVeiw.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            }
            if ([dic[@"totalCount"] intValue]>0&&[dic[@"totalCount"] intValue]<=10) {
                [self.myTableVeiw.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            }
            
            NSDictionary *newDic=dic[@"recordList"];
            int    newpage=[pageStr intValue];
            if (newDic.count>0) {
                
                newpage++;
            }
            NSString *  firstQueryTime=dic[@"firstQueryTime"];
            totalCount=dic[@"totalCount"];
            for (NSDictionary *myDic in dic[@"recordList"]) {
                
                SellerListModel *modl=[[SellerListModel alloc]init];
                modl.firstQueryTime=firstQueryTime;
                modl.page=[NSString stringWithFormat:@"%d",newpage];
                modl.totalCount=totalCount;
                [modl setValuesForKeysWithDictionary:myDic];
                
                if (typeIndex==1) {
                    [_nearDataArr addObject:modl];
                }
                if (typeIndex==2) {
                    [_latestDataArr addObject:modl];
                }
                if (typeIndex==3) {
                    [_oftenDataArr addObject:modl];
                }
            }
            
            [_myTableVeiw reloadData];
        }
    }];
    
}

-(SellerListModel *)backCurrentModel
{
    SellerListModel *modl;
    switch (typeIndex) {
        case 1:
        {
            modl=[_nearDataArr lastObject];
        }
            break;
        case 2:
        {
            modl=[_latestDataArr lastObject];
        }
            break;
        case 3:
        {
            modl=[_oftenDataArr lastObject];
        }
            break;
            
        default:
            break;
    }
    return  modl;
}

#pragma mark - 导航栏方法
-(void)createNavigationButton
{
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClick)];
    
    left=[UIButton buttonWithType:0];
    left.frame=CGRectMake(0, 0, 50, 40);
    [left setImage:[UIImage imageNamed:@"address_icon"] forState:0];
    [left setTitle:USERCITY forState:0];
    left.titleLabel.font=[UIFont systemFontOfSize:12];
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc] initWithCustomView:left];
    [left addTarget:self action:@selector(leftButtonClick) forControlEvents:1<<6];
    
    self.navigationItem.rightBarButtonItem=right;
    self.navigationItem.leftBarButtonItem=leftButton;
    
}
-(void)rightButtonClick
{
    
//    LoginViewController *loginVC=[[LoginViewController alloc]init];
//    loginVC.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:loginVC animated:YES];
    
    SearchViewController *searchVC=[[SearchViewController alloc]init];
    searchVC.hidesBottomBarWhenPushed=YES;
    searchVC.cityModel=myProvinceModel;
    searchVC.type=1;
    [self.navigationController pushViewController:searchVC animated:YES];
    DMLog(@"搜索");
}
-(void)leftButtonClick
{
    DMLog(@"地址");
    ChooseProvinceViewController *chooseProvinceVC=[[ChooseProvinceViewController alloc]init];
    isPush=YES;
    [chooseProvinceVC returnCity:^(CityModel *provinceModel) {
        
        DMLog(@"%@",provinceModel.name);
        myProvinceModel=provinceModel;
        cityID=provinceModel.cityId;
        _fresh=1;
        [left setTitle:provinceModel.name forState:0];
        [_nearDataArr removeAllObjects];
        [_latestDataArr removeAllObjects];
        [_oftenDataArr removeAllObjects];
        [self merchantsList:typeIndex];
        //[_myTableVeiw reloadData];
    }];
    chooseProvinceVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:chooseProvinceVC animated:YES];
    
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (typeIndex==1) {
        return _nearDataArr.count;
    }
    if (typeIndex==2) {
        return _latestDataArr.count;
    }
    if (typeIndex==3) {
        return _oftenDataArr.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93.;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SellerListModel *model;
    if (typeIndex==1) {
        model= _nearDataArr[indexPath.row] ;
    }
    if (typeIndex==2) {
        model= _latestDataArr[indexPath.row];
    }
    if (typeIndex==3) {
        model= _oftenDataArr[indexPath.row];
    }
    SellerTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        
        cell=[[[NSBundle mainBundle]loadNibNamed:@"SellerTableViewCell" owner:nil options:nil] firstObject];
    }
    cell.listModel=model;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.selectionStyle=0;
    return cell;
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    isPush=YES;
//    SellerListModel *model;
//    if (typeIndex==1) {
//        if (_nearDataArr.count>0) {
//            model=_nearDataArr[indexPath.row] ;
//        }
//        
//    }
//    if (typeIndex==2) {
//        if (_latestDataArr.count>0) {
//            model= _latestDataArr[indexPath.row];
//        }
//        
//    }
//    if (typeIndex==3) {
//        if (_oftenDataArr.count>0) {
//             model= _oftenDataArr[indexPath.row];
//        }
//       
//    }
//    StoreInfoViewController *storeVC=[[StoreInfoViewController alloc]init];
//    storeVC.shopModel=model;
//    storeVC.shopID=model.shopId;
////    storeVC.isCollected=model.isCollected;
//    storeVC.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:storeVC animated:YES];
//}
#pragma mark 4个种类的选择
- (IBAction)speciesButtonClick:(id)sender {
    
    UIButton *newBtn=(UIButton *)sender;
    ClassificationViewController *classificationVC=[[ClassificationViewController alloc]init];
    classificationVC.categoryArr=[_categoryArr mutableCopy];
    classificationVC.index=(int)newBtn.tag;
    classificationVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:classificationVC animated:YES];

}

#pragma mark 3个类别的选择
- (IBAction)categoryButtonClick:(id)sender {
    UIButton *newBtn=(UIButton *)sender;
    typeIndex=(int)newBtn.tag;
    _fresh=1;
    [UIView animateWithDuration:0.3 animations:^{
        
        _selectedLabel.center=CGPointMake(newBtn.center.x, _selectedLabel.center.y);
    }];

    switch (newBtn.tag) {
        case 1:
        {
            DMLog(@"附近商家");
        }
            break;
        case 2:
        {
            
            DMLog(@"最新商家");
        }
            break;
        case 3:
        {
            //此处需判断是否登录
            DMLog(@"经常去");
            if (![NSString isLogin]) {
                [_myTableVeiw reloadData];
                [self loginUser];
                return;
            }
        }
            break;

        default:
            break;
    }
    [activityView startAnimate];
    
    [self merchantsList:typeIndex];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
