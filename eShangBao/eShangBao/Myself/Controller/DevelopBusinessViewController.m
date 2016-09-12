//
//  DevelopBusinessViewController.m
//  eShangBao
//
//  Created by doumee on 16/6/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "DevelopBusinessViewController.h"
#import "ChooseusTableViewCell.h"
#import "MarkTableViewCell.h"
#import "NumberTableViewCell.h"
#import "ClassifyViewController.h"
#import "LicenceViewController.h"
#import "AllowViewController.h"
#import "LoginViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "DevelopBusinessTableViewCell.h"
@interface DevelopBusinessViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,uploadImageDelegate,BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate>
{
    UITableView * _tableView;
    UITableView * _addressTableView;
    NSString * _classify;//经营品类
    UIView * _mainView;
    UIView * _bgView;
    UIControl *commitBtn;
    NSString * _storeNameStr;// 店铺名称
    NSString * _mainStroeNameStr;// 门店名称
    NSString * _elseStoreStr;// 分店名称
    NSString * _storeAddress;// 门店地址
    NSString * _stroePhone;// 门店电话
    NSString * _codeStr;// 产品编码
    NSString * _felleiStr;//产品分类
    NSString * _priceStr;// 起送价格
    NSString * _deliveryFee;// 配送费
    NSString * _timeStr;// 承诺时间
    NSString * _numberStr;// 营业执照编号
    NSString * _licenceImgUrl;//营业执照
    NSString * _allowImgUrl;//许可证
    NSString * _categoryName;//经营产品分类
    NSString * _totalScore;//总体评分
    NSString * _qualityScore;//商品质量
    NSString * _sendScore;//配送服务
    NSString * _categoryId;//经营分类编码
    NSString * _businessImg;//营业执照图片
    NSString * _licenseImg;//许可证
    NSString * _latitude;//纬度
    NSString * _longitude;//经度
    NSString * _doorImg;//门店图片
    NSString * _doorImgUrl;
    NSString * _deliveryDistance;//配送范围
    
    TBActivityView *activityView;
    BMKMapView *_mapView;
    BMKLocationService *_locationService;
    BMKGeoCodeSearch* _geocodesearch;
    
    NSString *_selfLatitude;//纬度
    NSString *_selfLongitude;//经度
    
    NSArray * _HourArr;
    NSArray * _mintueArr;
    NSString * _startHour;//开始小时
    NSString * _startMinute;//开始分钟
    NSString * _endHour;//结束小时
    NSString * _endMinute;//结束分钟
    NSString * _startTime;//开始时间
    NSString * _endTime;//结束时间
    
    UIImage * _headImg;//头像
    CLGeocoder *_geocoder;
    CLLocationManager *_locationManager;
    
    
    BOOL  _isUpLoad;
}


@end

@implementation DevelopBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self backButton];
    _isUpLoad=NO;
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    
    [activityView startAnimate];
    self.title=@"发展商家";
    self.view.backgroundColor=BGMAINCOLOR;
    _felleiStr=@"请选择";
    _timeStr=@"30分钟";
    _licenceImgUrl=@"";
    _allowImgUrl=@"";
    _doorImgUrl=@"";
    _longitude=@"";
    _latitude=@"";
    _startHour=@"00";
    _startMinute=@"00";
    _endHour=@"00";
    _endMinute=@"00";
    _startTime=[NSString stringWithFormat:@"%@:%@",_startHour,_startMinute];
    _endTime=[NSString stringWithFormat:@"%@:%@",_endHour,_endMinute];
    //    _deliveryDistance=@"";
    _timeArray=@[@"0",@"10",@"20",@"30",@"40",@"50",@"60"];
    _HourArr=@[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
    _mintueArr=@[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
    
    
    [self loadUI];
    
    _geocoder=[[CLGeocoder alloc]init];
    _locationManager=[[CLLocationManager alloc]init];
    //    _locationManager.delegate = self;
    
    [_locationManager startUpdatingLocation];
    _locationManager=[[CLLocationManager alloc]init];
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){

//        [_locationManager requestWhenInUseAuthorization];
//        
//        [_locationManager startUpdatingLocation];
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
        
//=======
//        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
//            [_locationManager requestWhenInUseAuthorization];
//        }
//>>>>>>> .r10349
    }

    // Do any additional setup after loading the view.
}

#pragma mark - loadUI
-(void)loadUI
{
    _mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 30, WIDTH, HEIGHT)];
    _mainView.backgroundColor=BGMAINCOLOR;
    [self.view addSubview:_mainView];
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-2) style:1];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    //    _tableView.rowHeight=H(44);
    //    _tableView.scrollEnabled=NO;
    _tableView.separatorStyle=0;
    //    _tableView.separatorColor=BGMAINCOLOR;
    _tableView.sectionHeaderHeight=0;
    _tableView.sectionFooterHeight=H(10);
    self.automaticallyAdjustsScrollViewInsets=NO;
    [_mainView addSubview:_tableView];
    
    _saveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _saveBtn.frame=CGRectMake( W(20), H(3), W(30), H(20));
    [_saveBtn setImage:[UIImage imageNamed:@"saveAddress"] forState:0];
    [_saveBtn addTarget:self action:@selector(save) forControlEvents:1<<6];
    UIBarButtonItem*rightItem1=[[UIBarButtonItem alloc]initWithCustomView:_saveBtn];
    self.navigationItem.rightBarButtonItem=rightItem1;
    
    
}
#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    else if (section==1)
    {
        return 4;
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        DMLog(@"___%@",_doorImgUrl);
        DevelopBusinessTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[DevelopBusinessTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
        }
        cell.selectionStyle=0;
        [cell.dataBtn addTarget:self action:@selector(chooseDoorImg) forControlEvents:1<<6];
        if (_doorImgUrl.length==0) {
            cell.dataImg.image=[UIImage imageNamed:@"bussiness_head"];
        }
        else
        {
            cell.dataImg.image=_headImg;
        }
        //        [cell.dataImg setImageWithURLString:_doorImg placeholderImage:DEFAULTIMAGE];
        return cell;
    }

    else if (indexPath.section==1)
    {
        if (indexPath.row==0) {
            NumberTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"inviteCell"];
            if (!cell) {
                cell=[[NumberTableViewCell alloc]initWithStyle:1 reuseIdentifier:@"inviteCell"];
            }
            cell.selectionStyle=0;
            cell.numberLabel.textColor=MAINCHARACTERCOLOR;
            cell.numberLabel.text=@"邀请码";
            cell.numberLabel.font=[UIFont systemFontOfSize:14];
            
            cell.numberTF.tag=6;
            cell.numberTF.delegate=self;
            //            cell.numberTF.text=_stroePhone;
            [cell.numberTF addTarget:self action:@selector(chooseLongitude:) forControlEvents:UIControlEventEditingChanged];
            cell.numberTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入" attributes:@{NSForegroundColorAttributeName:RGBACOLOR(128, 128, 128, 1),NSFontAttributeName:[UIFont systemFontOfSize:24/2]}];
            //            cell.detailTextLabel.text=_stroePhone;
            //            cell.detailTextLabel.font=[UIFont systemFontOfSize:12*KRatioH];
            //            cell.detailTextLabel.textColor=GRAYCOLOR;
            //            _stroePhone=cell.detailTextLabel.text;
            UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
            lineLabel.backgroundColor=BGMAINCOLOR;
            [cell.contentView addSubview:lineLabel];
            return cell;

        }
       else if (indexPath.row==1) {
            NumberTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"nameCell"];
            if (!cell) {
                cell=[[NumberTableViewCell alloc]initWithStyle:1 reuseIdentifier:@"nameCell"];
            }
            cell.selectionStyle=0;
            cell.numberLabel.textColor=MAINCHARACTERCOLOR;
            cell.numberLabel.text=@"姓名";
            cell.numberLabel.font=[UIFont systemFontOfSize:14];
            
            cell.numberTF.tag=6;
            cell.numberTF.delegate=self;
            //            cell.numberTF.text=_stroePhone;
            [cell.numberTF addTarget:self action:@selector(chooseLongitude:) forControlEvents:UIControlEventEditingChanged];
            cell.numberTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入" attributes:@{NSForegroundColorAttributeName:RGBACOLOR(128, 128, 128, 1),NSFontAttributeName:[UIFont systemFontOfSize:24/2]}];
            //            cell.detailTextLabel.text=_stroePhone;
            //            cell.detailTextLabel.font=[UIFont systemFontOfSize:12*KRatioH];
            //            cell.detailTextLabel.textColor=GRAYCOLOR;
            //            _stroePhone=cell.detailTextLabel.text;
            UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
            lineLabel.backgroundColor=BGMAINCOLOR;
            [cell.contentView addSubview:lineLabel];
            return cell;

        }
       else if (indexPath.row==2) {
            NumberTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"phoneCell"];
            if (!cell) {
                cell=[[NumberTableViewCell alloc]initWithStyle:1 reuseIdentifier:@"phoneCell"];
            }
            cell.selectionStyle=0;
            cell.numberLabel.textColor=MAINCHARACTERCOLOR;
            cell.numberLabel.text=@"手机号";
            cell.numberLabel.font=[UIFont systemFontOfSize:14];
            
            cell.numberTF.tag=6;
            cell.numberTF.delegate=self;
            //            cell.numberTF.text=_stroePhone;
            [cell.numberTF addTarget:self action:@selector(chooseLongitude:) forControlEvents:UIControlEventEditingChanged];
            cell.numberTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入" attributes:@{NSForegroundColorAttributeName:RGBACOLOR(128, 128, 128, 1),NSFontAttributeName:[UIFont systemFontOfSize:24/2]}];
            //            cell.detailTextLabel.text=_stroePhone;
            //            cell.detailTextLabel.font=[UIFont systemFontOfSize:12*KRatioH];
            //            cell.detailTextLabel.textColor=GRAYCOLOR;
            //            _stroePhone=cell.detailTextLabel.text;
            UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
            lineLabel.backgroundColor=BGMAINCOLOR;
            [cell.contentView addSubview:lineLabel];
            return cell;

        }
        else {
            NumberTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"idcardCell"];
            if (!cell) {
                cell=[[NumberTableViewCell alloc]initWithStyle:1 reuseIdentifier:@"idcardCell"];
            }
            cell.selectionStyle=0;
            cell.numberLabel.textColor=MAINCHARACTERCOLOR;
            cell.numberLabel.text=@"身份证号";
            cell.numberLabel.font=[UIFont systemFontOfSize:14];
            
            cell.numberTF.tag=6;
            cell.numberTF.delegate=self;
            //            cell.numberTF.text=_stroePhone;
            [cell.numberTF addTarget:self action:@selector(chooseLongitude:) forControlEvents:UIControlEventEditingChanged];
            cell.numberTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入" attributes:@{NSForegroundColorAttributeName:RGBACOLOR(128, 128, 128, 1),NSFontAttributeName:[UIFont systemFontOfSize:24/2]}];
            //            cell.detailTextLabel.text=_stroePhone;
            //            cell.detailTextLabel.font=[UIFont systemFontOfSize:12*KRatioH];
            //            cell.detailTextLabel.textColor=GRAYCOLOR;
            //            _stroePhone=cell.detailTextLabel.text;
            UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
            lineLabel.backgroundColor=BGMAINCOLOR;
            [cell.contentView addSubview:lineLabel];
            return cell;

        }
    }
    else if(indexPath.section==2)
    {

        if(indexPath.row==0)
        {
            NumberTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell3"];
            if (!cell) {
                cell=[[NumberTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell3"];
            }
            cell.selectionStyle=0;
            cell.numberLabel.text=@"店铺名称";
            cell.numberLabel.font=[UIFont systemFontOfSize:14];
            cell.numberTF.delegate=self;
//            cell.numberTF.text=_mainStroeNameStr;
            cell.numberTF.tag=0;
            [cell.numberTF addTarget:self action:@selector(chooseLongitude:) forControlEvents:UIControlEventEditingChanged];
            cell.numberTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入" attributes:@{NSForegroundColorAttributeName:RGBACOLOR(128, 128, 128, 1),NSFontAttributeName:[UIFont systemFontOfSize:24/2]}];
            UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
            lineLabel.backgroundColor=BGMAINCOLOR;
            [cell.contentView addSubview:lineLabel];
            return cell;
        }
        else if(indexPath.row==1)
        {
            NumberTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell4"];
            if (!cell) {
                cell=[[NumberTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell4"];
            }
            cell.selectionStyle=0;
            cell.numberLabel.text=@"分店名称";
            cell.numberLabel.font=[UIFont systemFontOfSize:14];
            cell.numberTF.tag=1;
            cell.numberTF.delegate=self;
//            cell.numberTF.text=_elseStoreStr;
            [cell.numberTF addTarget:self action:@selector(chooseLongitude:) forControlEvents:UIControlEventEditingChanged];
            cell.numberTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入" attributes:@{NSForegroundColorAttributeName:RGBACOLOR(128, 128, 128, 1),NSFontAttributeName:[UIFont systemFontOfSize:24/2]}];
            UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
            lineLabel.backgroundColor=BGMAINCOLOR;
            [cell.contentView addSubview:lineLabel];
            return cell;
            
        }
        else if(indexPath.row==2)
        {
            NumberTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell5"];
            if (!cell) {
                cell=[[NumberTableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell15"];
            }
            cell.selectionStyle=0;
            cell.numberLabel.textColor=MAINCHARACTERCOLOR;
            cell.numberLabel.text=@"门店地址";
            cell.numberLabel.font=[UIFont systemFontOfSize:14];
            
            cell.numberTF.tag=7;
            cell.numberTF.delegate=self;
//            cell.numberTF.text=_storeAddress;
            [cell.numberTF addTarget:self action:@selector(chooseLongitude:) forControlEvents:UIControlEventEditingChanged];
            cell.numberTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入" attributes:@{NSForegroundColorAttributeName:RGBACOLOR(128, 128, 128, 1),NSFontAttributeName:[UIFont systemFontOfSize:24/2]}];
            
            UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
            lineLabel.backgroundColor=BGMAINCOLOR;
            [cell.contentView addSubview:lineLabel];
            return cell;
            
        }
        else if (indexPath.row==3)
        {
            NumberTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell6"];
            if (!cell) {
                cell=[[NumberTableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell6"];
            }
            cell.selectionStyle=0;
            cell.numberLabel.textColor=MAINCHARACTERCOLOR;
            cell.numberLabel.text=@"门店电话";
            cell.numberLabel.font=[UIFont systemFontOfSize:14];
            
            cell.numberTF.tag=6;
            cell.numberTF.delegate=self;
//            cell.numberTF.text=_stroePhone;
            [cell.numberTF addTarget:self action:@selector(chooseLongitude:) forControlEvents:UIControlEventEditingChanged];
            cell.numberTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入" attributes:@{NSForegroundColorAttributeName:RGBACOLOR(128, 128, 128, 1),NSFontAttributeName:[UIFont systemFontOfSize:24/2]}];
            //            cell.detailTextLabel.text=_stroePhone;
            //            cell.detailTextLabel.font=[UIFont systemFontOfSize:12*KRatioH];
            //            cell.detailTextLabel.textColor=GRAYCOLOR;
            //            _stroePhone=cell.detailTextLabel.text;
            UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
            lineLabel.backgroundColor=BGMAINCOLOR;
            [cell.contentView addSubview:lineLabel];
            return cell;
            
        }
        else if(indexPath.row==4)
        {
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell8"];
            if (!cell) {
                cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell8"];
            }
            cell.selectionStyle=0;
            cell.textLabel.text=@"经营产品分类";
            cell.textLabel.font=[UIFont systemFontOfSize:14];
            cell.textLabel.textColor=MAINCHARACTERCOLOR;
            cell.detailTextLabel.font=[UIFont systemFontOfSize:12];
            cell.detailTextLabel.textColor=GRAYCOLOR;
//            cell.detailTextLabel.text=_categoryName;
            cell.accessoryType=1;
            UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
            lineLabel.backgroundColor=BGMAINCOLOR;
            [cell.contentView addSubview:lineLabel];
            return cell;
        }
        else if(indexPath.row==5)
        {
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell20"];
            if (!cell) {
                cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell20"];
            }
            cell.selectionStyle=0;
            cell.textLabel.text=@"开始营业时间";
            cell.textLabel.font=[UIFont systemFontOfSize:14];
            cell.textLabel.textColor=MAINCHARACTERCOLOR;
            //            if (_allowImgUrl.length==0) {
            //                cell.detailTextLabel.text=@"请上传";
            //            }
            //            else
            //            {
            //                cell.detailTextLabel.text=@"上传成功";
            //            }
//            cell.detailTextLabel.text=_startTime;
            cell.detailTextLabel.font=[UIFont systemFontOfSize:12];
            cell.detailTextLabel.textColor=GRAYCOLOR;
            cell.accessoryType=1;
            
            UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
            lineLabel.backgroundColor=BGMAINCOLOR;
            [cell.contentView addSubview:lineLabel];
            return cell;
            
        }
        else
        {
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell21"];
            if (!cell) {
                cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell21"];
            }
            cell.selectionStyle=0;
            cell.textLabel.text=@"结束营业时间";
            cell.textLabel.font=[UIFont systemFontOfSize:14];
            cell.textLabel.textColor=MAINCHARACTERCOLOR;
            //            if (_allowImgUrl.length==0) {
            //                cell.detailTextLabel.text=@"请上传";
            //            }
            //            else
            //            {
            //                cell.detailTextLabel.text=@"上传成功";
            //            }
//            cell.detailTextLabel.text=_endTime;
            cell.detailTextLabel.font=[UIFont systemFontOfSize:12];
            cell.detailTextLabel.textColor=GRAYCOLOR;
            cell.accessoryType=1;
            
            UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
            lineLabel.backgroundColor=BGMAINCOLOR;
            [cell.contentView addSubview:lineLabel];
            return cell;
            
        }
    }

    else
    {
        if (indexPath.row==0) {
            NumberTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell12"];
            if (!cell) {
                cell=[[NumberTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell12"];
            }
            cell.numberLabel.text=@"营业执照编号";
            cell.numberLabel.font=[UIFont systemFontOfSize:14];
            cell.numberTF.delegate=self;
//            cell.numberTF.text=_numberStr;
            cell.numberTF.tag=4;
            [cell.numberTF addTarget:self action:@selector(chooseLongitude:) forControlEvents:UIControlEventEditingChanged];
            cell.numberTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入" attributes:@{NSForegroundColorAttributeName:RGBACOLOR(128, 128, 128, 1),NSFontAttributeName:[UIFont systemFontOfSize:24/2]}];
            UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
            lineLabel.backgroundColor=BGMAINCOLOR;
            [cell.contentView addSubview:lineLabel];
            return cell;
        }
        else if(indexPath.row==1)
        {
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell13"];
            if (!cell) {
                cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell13"];
            }
            cell.selectionStyle=0;
            cell.textLabel.text=@"营业执照";
            cell.textLabel.textColor=MAINCHARACTERCOLOR;
            cell.textLabel.font=[UIFont systemFontOfSize:14];
            
            if (_licenceImgUrl.length==0) {
                cell.detailTextLabel.text=@"请上传";
            }
            else
            {
                cell.detailTextLabel.text=@"上传成功";
            }
            cell.detailTextLabel.font=[UIFont systemFontOfSize:12];
            cell.detailTextLabel.textColor=GRAYCOLOR;
            cell.accessoryType=1;
            
            UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
            lineLabel.backgroundColor=BGMAINCOLOR;
            [cell.contentView addSubview:lineLabel];
            return cell;
        }
        else
        {
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell14"];
            if (!cell) {
                cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell14"];
            }
            cell.selectionStyle=0;
            cell.textLabel.text=@"许可证";
            cell.textLabel.font=[UIFont systemFontOfSize:14];
            cell.textLabel.textColor=MAINCHARACTERCOLOR;
            if (_allowImgUrl.length==0) {
                cell.detailTextLabel.text=@"请上传";
            }
            else
            {
                cell.detailTextLabel.text=@"上传成功";
            }
            cell.detailTextLabel.font=[UIFont systemFontOfSize:12];
            cell.detailTextLabel.textColor=GRAYCOLOR;
            cell.accessoryType=1;
            return cell;
        }
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 160;
    }
    else
    {
        return H(44);
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
    }
    if (indexPath.section==2&&indexPath.row==4) {
        ClassifyViewController * classifyVC=[[ClassifyViewController alloc]init];
        classifyVC.classify=0;
        [classifyVC setBlock:^(NSDictionary *dict) {
            _categoryName=dict[@"classify"];
            _categoryId=dict[@"cateId"];
            [_tableView reloadData];
        }];
        [self.navigationController pushViewController:classifyVC animated:YES];
    }
    if (indexPath.section==2&&indexPath.row==5) {
        _mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        _mainView.alpha=0.3;
        _mainView.backgroundColor=[UIColor blackColor];
        [[UIApplication sharedApplication].keyWindow addSubview:_mainView];
        
        //[view bringSubviewToFront:self.navigationController.navigationBar];
        
        _bgView=[[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight-474/2*KRatioH, KScreenWidth, 474/2*KRatioH)];
        _bgView.backgroundColor=[UIColor whiteColor];
        [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
        //        _bgView=bgView;
        
        UIControl *cancelBtn=[[UIControl alloc]initWithFrame:CGRectMake(12/2*KRatioW, 0, 100*KRatioW, 85/2*KRatioH)];
        UILabel *cancelLabel=[[UILabel alloc]initWithFrame:cancelBtn.frame];
        cancelLabel.text=@"取消";
        cancelLabel.font=[UIFont systemFontOfSize:28/2*KRatioH];
        cancelLabel.textColor=[UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1];
        cancelLabel.textAlignment=NSTextAlignmentLeft;
        [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn addSubview:cancelLabel];
        [_bgView addSubview:cancelBtn];
        
        
        commitBtn=[[UIControl alloc]initWithFrame:CGRectMake(KScreenWidth-36/2*KRatioW-100*KRatioW, 0, 100*KRatioW, 85/2*KRatioH)];
        UILabel *commitLabel=[[UILabel alloc]initWithFrame:CGRectMake( 0, 0, 88*KRatioW, 85/2*KRatioH)];
        commitLabel.text=@"确定";
        commitLabel.font=[UIFont systemFontOfSize:28/2];
        commitLabel.font=[UIFont boldSystemFontOfSize:28/2];
        commitLabel.textColor=[UIColor colorWithRed:247/255.0 green:137/255.0 blue:0/255.0 alpha:1];
        commitLabel.textAlignment=NSTextAlignmentRight;
        [commitBtn addSubview:commitLabel];
        commitBtn.tag=1000;
        //    commitBtn.backgroundColor=[UIColor redColor];
        [commitBtn addTarget:self action:@selector(commitLabelClickeds:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:commitBtn];
        
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 85/2*KRatioH, KScreenWidth, 1)];
        line.backgroundColor=[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
        [_bgView addSubview:line];
        CGFloat lineMaxY=CGRectGetMaxY(line.frame);
        
        UIPickerView *pv=[[UIPickerView alloc]initWithFrame:CGRectMake(0,lineMaxY , WIDTH, 149.5*KRatioH)];
        pv.delegate=self;
        pv.dataSource=self;
//        pv.backgroundColor=[UIColor cyanColor];
        pv.tag=101;
        [_bgView addSubview:pv];
        
    }
    if (indexPath.section==2&&indexPath.row==6) {
        _mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        _mainView.alpha=0.3;
        _mainView.backgroundColor=[UIColor blackColor];
        [[UIApplication sharedApplication].keyWindow addSubview:_mainView];
        
        //[view bringSubviewToFront:self.navigationController.navigationBar];
        
        _bgView=[[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight-474/2*KRatioH, KScreenWidth, 474/2*KRatioH)];
        _bgView.backgroundColor=[UIColor whiteColor];
        [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
        //        _bgView=bgView;
        
        UIControl *cancelBtn=[[UIControl alloc]initWithFrame:CGRectMake(12/2*KRatioW, 0, 100*KRatioW, 85/2*KRatioH)];
        UILabel *cancelLabel=[[UILabel alloc]initWithFrame:cancelBtn.frame];
        cancelLabel.text=@"取消";
        cancelLabel.font=[UIFont systemFontOfSize:28/2];
        cancelLabel.textColor=[UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1];
        cancelLabel.textAlignment=NSTextAlignmentLeft;
        [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn addSubview:cancelLabel];
        [_bgView addSubview:cancelBtn];
        
        
        commitBtn=[[UIControl alloc]initWithFrame:CGRectMake(KScreenWidth-36/2*KRatioW-100*KRatioW, 0, 100*KRatioW, 85/2*KRatioH)];
        UILabel *commitLabel=[[UILabel alloc]initWithFrame:CGRectMake( 0, 0, 88*KRatioW, 85/2*KRatioH)];
        commitLabel.text=@"确定";
        commitLabel.font=[UIFont systemFontOfSize:28/2];
        commitLabel.font=[UIFont boldSystemFontOfSize:28/2];
        commitLabel.textColor=[UIColor colorWithRed:247/255.0 green:137/255.0 blue:0/255.0 alpha:1];
        commitLabel.textAlignment=NSTextAlignmentRight;
        [commitBtn addSubview:commitLabel];
        commitBtn.tag=1000;
        //    commitBtn.backgroundColor=[UIColor redColor];
        [commitBtn addTarget:self action:@selector(commitLabelClickedss:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:commitBtn];
        
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 85/2*KRatioH, KScreenWidth, 1)];
        line.backgroundColor=[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
        [_bgView addSubview:line];
        CGFloat lineMaxY=CGRectGetMaxY(line.frame);
        
        UIPickerView *pv=[[UIPickerView alloc]initWithFrame:CGRectMake(0,lineMaxY , KScreenWidth, 149.5*KRatioH)];
        pv.delegate=self;
        pv.dataSource=self;
        pv.backgroundColor=[UIColor whiteColor];
        pv.tag=102;
        [_bgView addSubview:pv];
        
    }

    if (indexPath.section==3&&indexPath.row==1) {
        LicenceViewController * licenceVC=[[LicenceViewController alloc]init];
        licenceVC.businessImg=_licenceImgUrl;
        [licenceVC setBlock:^(NSDictionary *dic) {
            _licenceImgUrl=dic[@"imgUrl"];
            [_tableView reloadData];
        }];
        [self.navigationController pushViewController:licenceVC animated:YES];
    }
    if (indexPath.section==3&&indexPath.row==2) {
        
        DMLog(@"点击了");
        AllowViewController * allowVC=[[AllowViewController alloc]init];
        allowVC.licenseImg=_allowImgUrl;
        [allowVC setBlock:^(NSDictionary *dic) {
            _allowImgUrl=dic[@"imgUrl"];
            [_tableView reloadData];
        }];
        [self.navigationController pushViewController:allowVC animated:YES];
    }
    
}

#pragma mark---UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //        NSLog(@"0拍照");
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
        
    }else if(buttonIndex == 1)
    {
        DMLog(@"1相册");
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
        
    }else
    {
        //        NSLog(@"2取消");
    }
}


-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage * image=[info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(selectPic:) withObject:image afterDelay:0.1];
}

#pragma mark 根据地名确定地理坐标
-(void)getCoordinateByAddress:(NSString *)address
{
    
    //地理编码
    
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
        CLPlacemark *placemark=[placemarks firstObject];
        _latitude=[NSString stringWithFormat:@"%f",placemark.location.coordinate.latitude];
        _longitude=[NSString stringWithFormat:@"%f",placemark.location.coordinate.longitude];
        DMLog(@" ---lat=%@,lon=%@---",_latitude,_longitude);
        
    }];
}

#pragma mark - Button

- (void)selectPic:(UIImage*)image
{
    DMLog(@"image%@",image);
    //    [_addButton setImage:image forState:0];
    _headImg=image;
    [_tableView reloadData];
    
    FTPUploadImage *uploadImage= [[FTPUploadImage alloc]init];
    uploadImage.delegate=self;
    [uploadImage FTPUploadImage:@"member" ImageData:image];
    
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    
    [activityView startAnimate];
    
}


-(void)uploadImageComplete:(NSString *)imageUrl
{
    if (imageUrl==nil) {
        
        DMLog(@"上传失败");
        [UIAlertView alertWithTitle:@"温馨提示" message:@"图片上传失败，请重新上传" buttonTitle:nil];
        [activityView stopAnimate];
    }else
    {
        
        DMLog(@"imgUrl---%@",imageUrl);
        //        _uploadBtn.enabled=YES;
        [activityView stopAnimate];
        //        _imgUrl=imageUrl;
        //        _doorImg=[NSString stringWithFormat:@"http://114.215.188.193:8080/consumption/member/%@",imageUrl];
        _doorImgUrl=imageUrl;

        [_tableView reloadData];
        _isUpLoad=YES;
    }
}



#pragma mark - UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView.tag==100) {
        return 1;
    }
    else if (pickerView.tag==101)
    {
        return 2;
    }
    else
    {
        return 2;
    }
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag==100) {
        return _timeArray.count;
    }
    else if (pickerView.tag==101)
    {
        if (component==0) {
            return _HourArr.count;
        }
        else
        {
            return _mintueArr.count;
        }
        //        return _timeArray.count;
    }
    else
    {
        if (component==0) {
            return _HourArr.count;
        }
        else
        {
            return _mintueArr.count;
        }
        //        return _timeArray.count;
    }
    
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if (pickerView.tag==100) {
        return H(20);
    }
    else if (pickerView.tag==101)
    {
        if (component==0) {
            return H(20);
        }
        else
        {
            return H(20);
        }
        
    }
    else
    {
        return H(20);
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (pickerView.tag==100) {
        return WIDTH;
    }
    else if (pickerView.tag==101)
    {
        return WIDTH/2;
    }
    else
    {
        return WIDTH/2;
    }
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag==100) {
        NSString * str=[_timeArray objectAtIndex:row];
        return str;
    }
    else if (pickerView.tag==101)
    {
        if (component==0) {
            NSString * str=[_HourArr objectAtIndex:row];
            return str;
        }
        else
        {
            NSString * str=[_mintueArr objectAtIndex:row];
            return str;
        }
        
    }
    else
    {
        if (component==0) {
            NSString * str=[_HourArr objectAtIndex:row];
            return str;
        }
        else
        {
            NSString * str=[_mintueArr objectAtIndex:row];
            return str;
        }
        
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag==100) {
        commitBtn.tag=row;
    }
    else if (pickerView.tag==101)
    {
        if (component==0) {
            _startHour=[_HourArr objectAtIndex:row];
        }
        else
        {
            _startMinute=[_mintueArr objectAtIndex:row];
        }
        
    }
    else
    {
        if (component==0) {
            _endHour=[_HourArr objectAtIndex:row];
        }
        else
        {
            _endMinute=[_mintueArr objectAtIndex:row];
        }
    }
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}


# pragma mark----百度地图的代理方法
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
    _latitude=[NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    _longitude=[NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
}

#pragma mark - 按钮绑定的方法
-(void)save
{
    [self.view endEditing:YES];
    if (![NSString isLogin]) {
        [self loginUser];
    }
    else if (_numberStr.length==0) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入营业执照编号" buttonTitle:nil];
    }
    else if (_deliveryDistance.description.length==0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入配送距离" buttonTitle:nil];
    }
    else
    {
        DMLog(@"保存");
        if (_isUpLoad==YES) {
            //        _startTime=[NSString stringWithFormat:@"%@,%@",_startHour,_startMinute];
            //        _endTime=[NSString stringWithFormat:@"%@:%@",_endHour,_endMinute];
            DMLog(@"***%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",_storeNameStr,_mainStroeNameStr,_elseStoreStr,_storeAddress,_stroePhone,_codeStr,_priceStr,_deliveryFee,_numberStr,_categoryName,_timeStr,_categoryId,_licenceImgUrl);
            NSDictionary * param=@{@"shopName":_mainStroeNameStr,@"branchName":_elseStoreStr,@"branchPhone":_stroePhone,@"shopAddr":_storeAddress,@"categoryId":_categoryId,@"doorImg":_doorImgUrl,@"businessNum":_numberStr,@"businessImg":_licenceImgUrl,@"licenseImg":_allowImgUrl,@"startBusinessTime":_startTime,@"endBusinessTime":_endTime,@"startSendPrice":_priceStr,@"sendPrice":_deliveryFee,@"transitTime":_timeStr,@"monthOrderNum":@"0",@"sendDistance":_deliveryDistance,@"latitude":_latitude,@"longitude":_longitude};
            [RequstEngine requestHttp:@"1057" paramDic:param blockObject:^(NSDictionary *dic) {
                DMLog(@"1057--%@",dic);
                DMLog(@"error---%@",dic[@"errorMsg"]);
                if ([dic[@"errorCode"] intValue]==00000) {
                    [UIAlertView alertWithTitle:@"温馨提示" message:@"更改信息成功" buttonTitle:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
            
        }
        else
        {
            //        _startTime=[NSString stringWithFormat:@"%@,%@",_startHour,_startMinute];
            //        _endTime=[NSString stringWithFormat:@"%@:%@",_endHour,_endMinute];
            DMLog(@"***%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",_storeNameStr,_mainStroeNameStr,_elseStoreStr,_storeAddress,_stroePhone,_codeStr,_priceStr,_deliveryFee,_numberStr,_categoryName,_timeStr,_categoryId,_licenceImgUrl);
            NSDictionary * param=@{@"shopName":_mainStroeNameStr,@"branchName":_elseStoreStr,@"branchPhone":_stroePhone,@"shopAddr":_storeAddress,@"categoryId":_categoryId,@"businessNum":_numberStr,@"businessImg":_licenceImgUrl,@"licenseImg":_allowImgUrl,@"startBusinessTime":_startTime,@"endBusinessTime":_endTime,@"startSendPrice":_priceStr,@"sendPrice":_deliveryFee,@"transitTime":_timeStr,@"monthOrderNum":@"0",@"sendDistance":_deliveryDistance,@"latitude":_latitude,@"longitude":_longitude};
            [RequstEngine requestHttp:@"1057" paramDic:param blockObject:^(NSDictionary *dic) {
                DMLog(@"1057--%@",dic);
                DMLog(@"error---%@",dic[@"errorMsg"]);
                if ([dic[@"errorCode"] intValue]==00000) {
                    [UIAlertView alertWithTitle:@"温馨提示" message:@"更改信息成功" buttonTitle:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
            
        }
        
    }
    //    else if()
}

-(void)loginUser
{
    LoginViewController * loginVC=[[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}
-(void)cancelBtnClicked
{
    [_mainView removeFromSuperview];
    [_bgView removeFromSuperview];
}

-(void)commitLabelClicked:(UIButton *)sender
{
//    DMLog(@"------%ld",sender.tag);
    _timeStr=[_timeArray objectAtIndex:sender.tag];
    DMLog(@"+++++%@",_timeStr);
    [_mainView removeFromSuperview];
    [_bgView removeFromSuperview];
    _startTime=[NSString stringWithFormat:@"%@:%@",_startHour,_startMinute];
    _endTime=[NSString stringWithFormat:@"%@:%@",_endHour,_endMinute];
    [_tableView reloadData];
}

-(void)commitLabelClickedss:(UIButton *)sender
{
//    DMLog(@"------%ld",sender.tag);
    //    _timeStr=[_timeArray objectAtIndex:sender.tag];
    DMLog(@"+++++%@",_timeStr);
    [_mainView removeFromSuperview];
    [_bgView removeFromSuperview];
    //    _startTime=[NSString stringWithFormat:@"%@:%@",_startHour,_startMinute];
    _endTime=[NSString stringWithFormat:@"%@:%@",_endHour,_endMinute];
    [_tableView reloadData];
}


-(void)commitLabelClickeds:(UIButton *)sender
{
//    DMLog(@"------%ld",sender.tag);
    //    _timeStr=[_timeArray objectAtIndex:sender.tag];
    DMLog(@"+++++%@",_timeStr);
    [_mainView removeFromSuperview];
    [_bgView removeFromSuperview];
    _startTime=[NSString stringWithFormat:@"%@:%@",_startHour,_startMinute];
    //    _endTime=[NSString stringWithFormat:@"%@:%@",_endHour,_endMinute];
    [_tableView reloadData];
}


-(void)chooseLongitude:(UITextField*)textField
{
    if (textField.tag==0) {
        _mainStroeNameStr=textField.text;
    }
    else if(textField.tag==1)
    {
        _elseStoreStr=textField.text;
    }
    else if (textField.tag==2)
    {
        _priceStr=textField.text;
    }else if (textField.tag==3)
    {
        _deliveryFee=textField.text;
    }
    else if (textField.tag==4)
    {
        _numberStr=textField.text;
    }
    else if (textField.tag==6)
    {
        _stroePhone=textField.text;
    }
    else if (textField.tag==7)
    {
        _storeAddress=textField.text;
        //        //初始化BMKLocationService
        //        _locationService = [[BMKLocationService alloc]init];
        //        _locationService.delegate = self;
        //        //启动LocationService
        //        [_locationService startUserLocationService];
        
        [self getCoordinateByAddress:_storeAddress];
        
    }
    else if (textField.tag==8)
    {
        _deliveryDistance=textField.text;
    }
    
    
    
}
-(void)chooseDoorImg
{
    DMLog(@"选择门店首图");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [actionSheet showInView:self.view];
    
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
