//
//  ChooseAddrViewController.m
//  eShangBao
//
//  Created by Dev on 16/1/23.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "ChooseAddrViewController.h"
#import "AddressTableViewCell.h"
#import "RouteAnno.h"


@interface ChooseAddrViewController ()
{
    RouteAnno *userAnno;
    RouteAnno *userMy;
    BMKMapManager *mapmanger;
    
    TBActivityView *activityView;
    
    UITableView    *_seaechTableView;
    UIButton       *packUpBtn;
    UIView         *mySearchView;
    
    BOOL           isSearch;
}
@end

@interface ChooseAddrViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKShareURLSearchDelegate,BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate,UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,strong)NSMutableArray               *addrArr;
@property(nonatomic,strong)NSMutableArray               *otherAddr;
@property(nonatomic,assign)BOOL                         mapViewCentent;//判断是否需要移动到中心点
@property(nonatomic,strong)UIButton                     *selectedBtn;
@property(nonatomic,strong)BMKUserLocation              *myLocation;
@property(nonatomic,assign)BOOL                         isMylocaton;//判断是否是在表示自己的位置
@property(nonatomic,assign)CLLocationCoordinate2D       currentLocation;//当前地图的中心位置
@property(nonatomic,assign)BOOL                         addrType;//判断当前显示的是什么类型的地址 yes 全部 no 其他
@end

@implementation ChooseAddrViewController

-(void)viewWillAppear:(BOOL)animated
{
    
    [_mapView viewWillAppear];
    _mapView.delegate=self;
    _geocodesearch.delegate = self;

}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate=nil;
    _search.delegate = nil;
    _geocodesearch.delegate=nil;
    _locationService.delegate=nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.fd_prefersNavigationBarHidden=YES;
    self.navigationController.navigationBarHidden=YES;
    
    [self createSearchTable];
    
    
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, _addrTabel.frame.size.height/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [_addrTabel addSubview:activityView];
    [activityView startAnimate];
    
    _mapView=[[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-262-64)];
    [_BMMapView addSubview:_mapView];
    
    //_BMMapView=_mapView;
    
    _mapView.mapType=BMKMapTypeStandard;
    _mapView.showsUserLocation=YES;
    
    _locationService=[[BMKLocationService alloc]init];
    _locationService.delegate=self;
    [_locationService startUserLocationService];
    _geocodesearch=[[BMKGeoCodeSearch alloc]init];
    
    _searchView.layer.cornerRadius=5;
    _searchView.layer.masksToBounds=YES;
    
    _searchButton.layer.cornerRadius=5;
    _searchButton.layer.masksToBounds=YES;
    
    _addrArr=[NSMutableArray arrayWithCapacity:0];
    _otherAddr=[NSMutableArray arrayWithCapacity:0];
    _mapViewCentent=YES;
    _isMylocaton=NO;
    _addrType=YES;
    isSearch=NO;
    
    _searchButton=(UIButton *)[self.view viewWithTag:1];
    _addrTabel.tableFooterView=[[UIView alloc]init];

}

-(void)createSearchTable
{
    
    mySearchView=[[UIView alloc]initWithFrame:CGRectMake(0, -KScreenHeight+64, KScreenWidth, KScreenHeight-64)];
    mySearchView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:mySearchView];
    [_titalView bringSubviewToFront:self.view];
    
    
    _seaechTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64)];
    _seaechTableView.tableFooterView=[[UIView alloc]init];
    _seaechTableView.delegate=self;
    _seaechTableView.dataSource=self;
    _seaechTableView.tag=1;
    [mySearchView addSubview:_seaechTableView];
    
    
    packUpBtn=[UIButton buttonWithType:0];
    packUpBtn.backgroundColor=[UIColor whiteColor];
    [packUpBtn setTitle:@"收起" forState:0];
    packUpBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    packUpBtn.layer.cornerRadius=20;
    packUpBtn.layer.masksToBounds=YES;
    packUpBtn.backgroundColor=MAINCOLOR;
    packUpBtn.frame=CGRectMake(KScreenWidth-60,KScreenHeight/2., 40, 40);
    [packUpBtn addTarget:self action:@selector(packUpClick) forControlEvents:1<<6];
    [mySearchView addSubview:packUpBtn];
    
}
-(void)packUpClick
{
    [UIView animateWithDuration:0.3 animations:^{
        
        
        mySearchView.transform=CGAffineTransformMakeTranslation(0, 0);
        
    }];

}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    DMLog(@"%@",userLocation.location);
    BMKCoordinateSpan span={0.003,0.003};
    BMKCoordinateRegion region={userLocation.location.coordinate,span};
    _myLocation=userLocation;
    if (_mapViewCentent) {
        [_mapView setRegion:region];
        _mapViewCentent=NO;
    }
    
    
}
-(void)mapStatusDidChanged:(BMKMapView *)mapView
{
    [self.view endEditing:YES];
    [activityView startAnimate];
    if (userAnno==nil) {
        
        userAnno=[[RouteAnno alloc]init];
        userMy  =[[RouteAnno alloc]init];
    }
    userAnno.coordinate = _mapView.centerCoordinate;
    userMy.coordinate   = _myLocation.location.coordinate;
    userMy.title = @"您的当前位置";
    userAnno.type = 3;
    userMy  .type =3;
    NSArray *annoArr=@[userMy,userAnno];
    [_mapView addAnnotations:annoArr];
}

-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
    [_addrArr removeAllObjects];
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    _currentLocation=mapView.centerCoordinate;//保存地图中心位置
    reverseGeocodeSearchOption.reverseGeoPoint = mapView.centerCoordinate;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }

}

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray *arr=result.poiList;
    for (BMKPoiInfo *model in arr) {
        
        [_addrArr addObject:model];
        DMLog(@"%@--%@",model.name,model.address);
    }
    
    [activityView stopAnimate];
    [_addrTabel reloadData];

}

#pragma mark - 周边搜索
-(void)searcherSurroundingContent:(NSString *)content;
{
    _search=[[BMKPoiSearch alloc]init];
    _search.delegate=self;
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 10;
    option.location = _currentLocation;
    option.keyword =content;
    BOOL flag = [_search poiSearchNearBy:option];
    if(flag)
    {
        [activityView stopAnimate];
        NSLog(@"周边检索发送成功");
    }
    else
    {
        [activityView stopAnimate];
        NSLog(@"周边检索发送失败");
    }
}

-(void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    [_otherAddr removeAllObjects];
    NSArray *arr=poiResult.poiInfoList;
    for (BMKPoiInfo *model in arr) {
        
        [_otherAddr addObject:model];
        
    }
    if (isSearch) {
        [_seaechTableView reloadData];
    }else{
         [_addrTabel reloadData];
    }
}

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnno class]]) {
        return [self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnno*)annotation];
    }
    return nil;
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnno*)routeAnnotation
{
    BMKAnnotationView *view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
    
    if (view == nil) {
        view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
        if (_isMylocaton) {
            view.image=[UIImage imageNamed:@"location"];
            
        }else{
           view.image=[UIImage imageNamed:@"myLocation"];
            _isMylocaton=YES;
        }
        
        //        这是气泡
        view.canShowCallout = TRUE;
        view.draggable=YES;
    }
    view.annotation = routeAnnotation;
    return view;
}
- (IBAction)backButton:(id)sender {
    
//    self.navigationController.navigationBarHidden=NO;
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)searchButtonClick:(id)sender {
    
    [self.view endEditing:YES];
    if (_searchText.text.length==0) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入搜索内容" buttonTitle:nil];
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        
        
        mySearchView.transform=CGAffineTransformMakeTranslation(0, KScreenHeight);
        
    }];
    
    //[activityView startAnimate];
    isSearch=YES;
    _addrType=NO;
    
    [self searcherSurroundingContent:_searchText.text];
}


#pragma mark 表的代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_addrType==YES) {
        return _addrArr.count;
    }
    return _otherAddr.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BDAddrCell"];
    NSArray *arrCell=[[NSBundle mainBundle] loadNibNamed:@"AddressTableViewCell" owner:nil options:nil];
    BMKPoiInfo *model;
    if (_addrType==YES) {
        model=[_addrArr objectAtIndex:indexPath.row];
    }else{
        
        model=[_otherAddr objectAtIndex:indexPath.row];
    }
    if (indexPath.row==0&&!isSearch) {
        AddressTableViewCell *currentAddrCell=[[[NSBundle mainBundle] loadNibNamed:@"AddressTableViewCell" owner:nil options:nil] objectAtIndex:1];
        currentAddrCell.currentName.text=model.name;
        currentAddrCell.currentAddr.text=model.address;
        return currentAddrCell;
    }
    
    if (!cell) {
        
        cell=[arrCell objectAtIndex:0];
        
    }
    cell.name.text=model.name;
    cell.address.text=model.address;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BMKPoiInfo *model;
    if (_addrType==YES) {
        model=[_addrArr objectAtIndex:indexPath.row];
    }else{
        
        model=[_otherAddr objectAtIndex:indexPath.row];
    }
    
    NSString *latitude=[NSString stringWithFormat:@"%f",model.pt.latitude];
    NSString *longitude=[NSString stringWithFormat:@"%f",model.pt.longitude];
    
    NSDictionary *addrDic=@{@"name":[NSString stringWithFormat:@"%@%@",model.address,model.name],@"latitude":latitude,@"longitude":longitude};
    
    if (self.returnTextBlock != nil) {
        
        self.returnTextBlock(addrDic);
    }
    //self.navigationController.navigationBarHidden=NO;
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark 选择类型按钮
- (IBAction)searchTypeButton:(id)sender {
    
    isSearch=NO;
    UIButton *newButton=(UIButton *)sender;
    [UIView animateWithDuration:0.3 animations:^{
        
        _chooseLabel.center=CGPointMake(newButton.center.x, _chooseLabel.center.y);
        
    }];
    
    if (newButton!=_searchButton) {
        
        [newButton setTitleColor:MAINCOLOR forState:0];
        [_searchButton setTitleColor:MAINCHARACTERCOLOR forState:0];
        _searchButton=newButton;
    }else{
        
        return;
    }
    [activityView startAnimate];
    switch (newButton.tag) {
        case 1:
        {
            [activityView stopAnimate];
            _addrType=YES;
            [_addrTabel reloadData];
            //[self searcherSurroundingContent:@"大厦"];
        }
            break;
        case 2:
        {
            _addrType=NO;
            [self searcherSurroundingContent:@"大厦"];
        }
            break;

        case 3:
        {
            _addrType=NO;
            [self searcherSurroundingContent:@"小区"];
        }
            break;

        case 4:
        {
            _addrType=NO;
            [self searcherSurroundingContent:@"学校"];
        }
            break;
        default:
            break;
    }
    
}

- (void)returnText:(ReturnAddrBlock)block {
    
    self.returnTextBlock = block;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
