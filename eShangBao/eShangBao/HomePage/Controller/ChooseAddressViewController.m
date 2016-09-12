//
//  ChooseAddressViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/23.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "ChooseAddressViewController.h"
#import "ChooseProvinceViewController.h"
#import "RouteAnno.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
//#import "KCAnnotation.h"
@interface ChooseAddressViewController ()
{
    RouteAnno *userAnno;
    NSString * _latitude;
    CLGeocoder *_geocoder;
    NSString * _longitude;
    CLLocationManager *_locationManager;
    
    
//    BMKMapView *_mapView;
//    BMKLocationService *_locationService;
//    BMKGeoCodeSearch* _geocodesearch;

}
@end

@interface ChooseAddressViewController ()<UITextFieldDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>


@property(nonatomic,assign)BOOL                         mapViewCentent;//判断是否需要移动到中心点
@end

@implementation ChooseAddressViewController


-(void)viewWillAppear:(BOOL)animated
{
    
    [_mapView viewWillAppear];
    _mapView.delegate=self;
    _loactionService.delegate=self;
    _geocodesearch.delegate=self;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate=nil;
    _loactionService.delegate=nil;
    _geocodesearch.delegate=nil;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"门店地址";
    _longitude=@"";
    _latitude=@"";
    [self backButton];
    self.view.backgroundColor=BGMAINCOLOR;
    _determineBtn.layer.cornerRadius=5;
    _determineBtn.layer.masksToBounds=YES;
    _mapViewCentent=YES;
    _geocodesearch=[[BMKGeoCodeSearch alloc]init];
    
    
    _geocoder=[[CLGeocoder alloc]init];
     _locationManager=[[CLLocationManager alloc]init];
//    _locationManager.delegate = self;
    
     [_locationManager startUpdatingLocation];
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    _mapView.userTrackingMode=MKUserTrackingModeFollow;
    //请求定位服务
    _locationManager=[[CLLocationManager alloc]init];
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        if([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_locationManager requestAlwaysAuthorization]; // 永久授权
            // [_locService requestWhenInUseAuthorization]; //使用中授权
        }
//        [_locationManager requestWhenInUseAuthorization];
    }
    
    _mapView=[[BMKMapView alloc]initWithFrame:_BMmapView.bounds];
    CGRect mapframe=_mapView.frame;
    mapframe.size.width=KScreenWidth;
    mapframe.size.height=KScreenHeight-135-45-20;
    _mapView.frame=mapframe;
    
    [_BMmapView addSubview:_mapView];
    _mapView.showsUserLocation=YES;
    
    
////    //设置地图类型
//    _mapView.mapType=MKMapTypeStandard;
//    
    UITapGestureRecognizer *tapg=[[UITapGestureRecognizer alloc]init];
    [tapg addTarget:self action:@selector(hiddenkeyboard)];
    tapg.numberOfTapsRequired=1;
    [_hiddenView addGestureRecognizer:tapg];
    
    
    _loactionService=[[BMKLocationService alloc]init];
    _loactionService.delegate=self;
    [_loactionService startUserLocationService];
    // 加载UI
    // Do any additional setup after loading the view from its nib.
}
-(void)hiddenkeyboard
{
    [self.view endEditing:YES];
}
#pragma mark 检索位置
//地图位置改变
-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    //_currentLocation=mapView.centerCoordinate;//保存地图中心位置
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
//    for (BMKPoiInfo *model in arr) {
    BMKPoiInfo *model=[arr firstObject];
    _longitude=[NSString stringWithFormat:@"%f",model.pt.longitude];
    _latitude=[NSString stringWithFormat:@"%f",model.pt.latitude];
    _detailsAddr.text=[NSString stringWithFormat:@"%@%@",model.address,model.name];
//    _chooseAddressName.text=model.city;
    DMLog(@"%@--%@",model.name,model.address);
//    }

}

#pragma mark - 地图控件代理方法
#pragma mark 更新用户位置，只要用户改变则调用此方法（包括第一次定位到用户位置）
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    NSLog(@"%@",userLocation);
    //设置地图显示范围(如果不进行区域设置会自动显示区域范围并指定当前用户位置为地图中心点)
    //    MKCoordinateSpan span=MKCoordinateSpanMake(0.01, 0.01);
    //    MKCoordinateRegion region=MKCoordinateRegionMake(userLocation.location.coordinate, span);
    //    [_mapView setRegion:region animated:true];
}




#pragma mark 根据地名确定地理坐标
-(void)getCoordinateByAddress:(NSString *)address
{
    
    //地理编码
   
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
        CLPlacemark *placemark=[placemarks firstObject];
        
//        CLLocation *location=placemark.location;//位置
//        CLRegion *region=placemark.region;//区域
//        NSDictionary *addressDic= placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
//        placemark.location
        BMKCoordinateRegion regions;
//        regions.center=placemark
        regions.center.latitude=placemark.location.coordinate.latitude;
        regions.center.longitude=placemark.location.coordinate.longitude;
//        region.center.latitude = userLocation.location.coordinate.latitude;
//        region.center.longitude = userLocation.location.coordinate.longitude;
        regions.span.latitudeDelta = 0.25;
        regions.span.longitudeDelta = 0.25;
        _mapView.region = regions;
//        _mapView.region = regions;
        
        
        
        
        
        
        
        
        //        NSString *name=placemark.name;//地名
        //        NSString *thoroughfare=placemark.thoroughfare;//街道
        //        NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
        //        NSString *locality=placemark.locality; // 城市
        //        NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
        //        NSString *administrativeArea=placemark.administrativeArea; // 州
        //        NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
        //        NSString *postalCode=placemark.postalCode; //邮编
        //        NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
        //        NSString *country=placemark.country; //国家
        //        NSString *inlandWater=placemark.inlandWater; //水源、湖泊
        //        NSString *ocean=placemark.ocean; // 海洋
        //        NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
//        NSLog(@"位置:%@,区域:%@,详细信息:%@",location,region,addressDic);
    }];
}
#pragma mark 显示地图
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    if (_mapViewCentent) {
        BMKCoordinateSpan span={0.1,0.1};
        BMKCoordinateRegion region={userLocation.location.coordinate,span};
        
        [_mapView setRegion:region];
        _mapViewCentent=NO;
    }
    
//    BMKCoordinateRegion regions;
////    regions.center.latitude
//    ////        regions.center.latitude=placemark
//    regions.center.latitude = userLocation.location.coordinate.latitude;
//    regions.center.longitude = userLocation.location.coordinate.longitude;
//    regions.span.latitudeDelta = 0.25;
//    regions.span.longitudeDelta = 0.25;
//    _mapView.region = regions;
    //        _mapView.region = placemark.region;
    
}

-(void)mapStatusDidChanged:(BMKMapView *)mapView
{
    if (userAnno==nil) {
        
        userAnno=[[RouteAnno alloc]init];
    }
    userAnno.coordinate=_mapView.centerCoordinate;
    [_mapView addAnnotation:userAnno];
}

////处理方向变更信息
//- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
//{
//    DMLog(@"heading is %@",userLocation.heading);
//}
////处理位置坐标更新
//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
//{
//    DMLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//    _latitude=[NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
//    _longitude=[NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
//}

//- (void)locationManager:(CLLocationManager *)manager
//    didUpdateToLocation:(CLLocation *)newLocation
//           fromLocation:(CLLocation *)oldLocation
//{
//    NSLog(@"%@",NSStringFromSelector(_cmd));
//    CLLocationDistance distance = [newLocation distanceFromLocation:oldLocation];
//    NSLog(@"distance is %f",distance /1000.0);
//    
////    BMKCoordinateRegion region = BMKCoordinateRegionMake(newLocation.coordinate, BMKCoordinateSpanMake(100, 100));
////    BMKCoordinateRegion region= bmk;
////    [_mapView setRegion:region animated:YES];
//    
//    
//}

#pragma mark 显示标示
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnno class]]) {
        
        return [self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnno *)annotation];
    }
    return nil;
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnno*)routeAnnotation
{
    BMKAnnotationView *view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
    
    if (view == nil) {
        view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
        view.image=[UIImage imageNamed:@"location"];
        //        这是气泡
        view.canShowCallout = TRUE;
        view.draggable=YES;
    }
    view.annotation = routeAnnotation;
    return view;
}


#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _hiddenView.hidden=YES;
    [self.view endEditing:YES];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _hiddenView.hidden=NO;
    [UIView animateWithDuration:0.26 animations:^{

        _bottomView.transform=CGAffineTransformMakeTranslation(0, -210);

    }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
     _hiddenView.hidden=YES;
    [UIView animateWithDuration:0.26 animations:^{

        _bottomView.transform=CGAffineTransformMakeTranslation(0, 0);
    }];
}

- (IBAction)chooseProvinces:(id)sender {
    
    ChooseProvinceViewController * chooseVC=[[ChooseProvinceViewController alloc]init];
    [chooseVC returnCity:^(CityModel *provinceModel) {
        _model=provinceModel;
        NSString * city=_model.cityName;
        _chooseAddressName.text=_model.cityName;
        DMLog(@"city---%@,%@,%@,%@",city,_model.name,_model.cityId,_model.provinceid);
        [self getCoordinateByAddress:city];
    }];
    [self.navigationController pushViewController:chooseVC animated:YES];
    
}

#pragma mark 确定按钮
- (IBAction)determineBtnClick:(id)sender {
    
    if (self.addressTextBlack != nil) {
        if (_model.cityId.length==0) {
            [UIAlertView alertWithTitle:@"温馨提示" message:@"请选择省市" buttonTitle:nil];
        }
        else
        {
            NSDictionary * dic=@{@"address":[NSString stringWithFormat:@"%@%@",_detailsAddr.text,_addrTF.text],@"latitude":_latitude,@"longitude":_longitude,@"cityId":_model.cityId,@"cityName":_model.cityName,@"provinceName":_model.name,@"provinceId":_model.provinceid};
            self.addressTextBlack(dic);
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    }
    
}

-(void)addressTextBlack:(ReturnAddress)black
{
    self.addressTextBlack=black;
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
