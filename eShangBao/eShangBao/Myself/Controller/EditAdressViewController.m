//
//  EditAdressViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "EditAdressViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>

//#import <BaiduMapAPI_Map/BMKMapView.h>
////#import <BaiduMapAPI/BMapKit.h>
//#import <BaiduMapAPI_Location/BMKLocationService.h>
//#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
//#import <BaiduMapAPI_Search/BMKPoiSearch.h>
//#import <BaiduMapAPI_Map/BMKPointAnnotation.h>
@interface EditAdressViewController ()<UITextFieldDelegate,BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate>
{
    BMKMapView *_mapView;
    BMKLocationService *_locationService;
    BMKGeoCodeSearch* _geocodesearch;
    NSString *_selfLatitude;//纬度
    NSString *_selfLongitude;//经度
}

@end

@implementation EditAdressViewController

-(void)viewWillAppear:(BOOL)animated
{
    
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title=@"收货地址管理";
    self.view.backgroundColor=BGMAINCOLOR;
    
    DMLog(@"88888888------%@,%@,%@",_latitude,_longitude,_addrId);
    _selfLatitude=_latitude;
    _selfLongitude=_longitude;
    // 加载UI
    [self loadUI];
    // Do any additional setup after loading the view.
}


-(void)loadUI
{
    UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, H(44)*4)];
    coverView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:coverView];
    
    UILabel * nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(10), W(70), H(22))];
    nameLabel.text=@"收货人:";
    nameLabel.font=[UIFont systemFontOfSize:14];
    nameLabel.textColor=MAINCHARACTERCOLOR;
    [coverView addSubview:nameLabel];
    
    _nameTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(nameLabel)+W(10), 0, WIDTH-W(12)-W(70)-W(10), H(44))];
    _nameTF.returnKeyType=UIReturnKeyDone;
    _nameTF.clearButtonMode=1;
    _nameTF.textColor=MAINCHARACTERCOLOR;
    _nameTF.delegate=self;
    _nameTF.text=_nameStr;
    _nameTF.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:_nameTF];
    
    UILabel * addressLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(_nameTF)+H(10), W(70), H(22))];
    addressLabel.textColor=MAINCHARACTERCOLOR;
    addressLabel.text=@"收货地址:";
    addressLabel.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:addressLabel];
    
    _addressTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(addressLabel)+W(10), kDown(_nameTF), WIDTH-W(12)-W(70)-W(10), H(44))];
    _addressTF.returnKeyType=UIReturnKeyDone;
    _addressTF.clearButtonMode=1;
    _addressTF.delegate=self;
    _addressTF.text=_addressStr;
    [_addressTF addTarget:self action:@selector(caclulate:) forControlEvents:UIControlEventEditingChanged];
    _addressTF.textColor=MAINCHARACTERCOLOR;
    _addressTF.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:_addressTF];
    
    UILabel * detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(_addressTF)+H(10), W(70), H(22))];
    detailLabel.text=@"门牌号";
    detailLabel.textColor=MAINCHARACTERCOLOR;
    detailLabel.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:detailLabel];
    
    _detailTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(detailLabel)+W(10), kDown(_addressTF), WIDTH-W(12)-W(70)-W(10), H(44))];
    _detailTF.delegate=self;
    _detailTF.returnKeyType=UIReturnKeyDone;
    _detailTF.clearButtonMode=1;
//    _detailTF.text
    _detailTF.text=_details;
    [_detailTF addTarget:self action:@selector(caclulate:) forControlEvents:UIControlEventEditingChanged];
    _detailTF.textColor=MAINCHARACTERCOLOR;
    _detailTF.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:_detailTF];
    
    UILabel * phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(_detailTF)+H(10), W(70), H(22))];
    phoneLabel.textColor=MAINCHARACTERCOLOR;
    phoneLabel.text=@"联系方式:";
    phoneLabel.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:phoneLabel];
    
    _phoneTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(phoneLabel)+W(10), kDown(_detailTF), WIDTH-W(12)-W(70)-W(10), H(44))];
    _phoneTF.returnKeyType=UIReturnKeyDone;
    _phoneTF.clearButtonMode=1;
    _phoneTF.delegate=self;
    _phoneTF.text=_phoneStr;
    _phoneTF.textColor=MAINCHARACTERCOLOR;
    _phoneTF.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:_phoneTF];
    
    for (int i=0; i<4; i++) {
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43)+i*H(44), WIDTH, H(1))];
        lineLabel.backgroundColor=BGMAINCOLOR;
        [coverView addSubview:lineLabel];
    }
    
    UIButton * deleteBtn=[UIButton buttonWithType:0];
    deleteBtn.frame=CGRectMake(W(15), H(500), W(120), H(40));
    deleteBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    [deleteBtn setTitle:@"删除" forState:0];
    deleteBtn.layer.cornerRadius=3;
    deleteBtn.layer.masksToBounds=YES;
    [deleteBtn addTarget:self action:@selector(deleteAddress) forControlEvents:1<<6];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:0];
    deleteBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:deleteBtn];
    
    UIButton * saveBtn=[UIButton buttonWithType:0];
    saveBtn.frame=CGRectMake(kRight(deleteBtn)+W(40), H(500), W(120), 40);
    saveBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    [saveBtn setTitle:@"保存" forState:0];
    saveBtn.layer.cornerRadius=3;
    saveBtn.layer.masksToBounds=YES;
    [saveBtn addTarget:self action:@selector(saveAddress) forControlEvents:1<<6];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:0];
    saveBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:saveBtn];

}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _locationService.delegate=nil;
}
# pragma mark----百度地图的代理方法
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        _mapView.centerCoordinate=result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        _selfLatitude=[NSString stringWithFormat:@"%f",item.coordinate.latitude];
        _selfLongitude=[NSString stringWithFormat:@"%f",item.coordinate.longitude];
        
        DMLog(@"******%@,%@",_selfLongitude,_selfLatitude);
//        _latitude=_selfLatitude;
//        _longitude=_selfLongitude;
        
        
    }
}
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    DMLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    DMLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _selfLatitude=[NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    _selfLongitude=[NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
}
#pragma mark - 按钮绑定的方法
-(void)deleteAddress
{
    DMLog(@"删除");
    NSDictionary * param=@{@"addrId":_addrId};
    [RequstEngine requestHttp:@"1016" paramDic:param blockObject:^(NSDictionary *dic) {
        DMLog(@"1016--**%@",dic);
        DMLog(@"error---%@",dic[@"errorMsg"]);
        if ([dic[@"errorCode"] intValue]==00000) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

-(void)saveAddress
{
    DMLog(@"保存");
//    DMLog(@"")
    NSDictionary * param=@{@"addrId":_addrId,@"name":_nameTF.text,@"sex":@"0",@"phone":_phoneTF.text,@"positon":_addressTF.text,@"details":_detailTF.text,@"latitude":_selfLatitude,@"longitude":_selfLongitude};
    [RequstEngine requestHttp:@"1015" paramDic:param blockObject:^(NSDictionary *dic) {
        DMLog(@"1015--address==%@",dic);
        if ([dic[@"errorCode"] intValue]==00000) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark---UITextField绑定的方法
-(void)caclulate:(UITextField*)textFiled
{
    //初始化BMKLocationService
    _locationService = [[BMKLocationService alloc]init];
    _locationService.delegate = self;
    //启动LocationService
    [_locationService startUserLocationService];
    
    
    NSLog(@"--**%@",textFiled.text);
//    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
//    _geocodesearch.delegate=self;
//    
//    
//    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
//    
//    geocodeSearchOption.address = textFiled.text;
//    geocodeSearchOption.city= @"安徽省";
//    
//    BOOL flag = [_geocodesearch geoCode:geocodeSearchOption];
//    if(flag)
//    {
//        NSLog(@"33geo检索发送成功");
//    }
//    else
//    {
//        NSLog(@"geo检索发送失败");
//    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
