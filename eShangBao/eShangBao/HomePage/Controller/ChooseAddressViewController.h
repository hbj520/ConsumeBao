//
//  ChooseAddressViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/23.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "HomeModel.h"
#import "CityModel.h"


typedef void(^ReturnAddress)(NSDictionary *dic);


@interface ChooseAddressViewController : UIViewController
{
    BMKMapView              *_mapView;
    BMKLocationService      *_loactionService;
    BMKGeoCodeSearch        *_geocodesearch;
}

@property(nonatomic,copy) ReturnAddress addressTextBlack;

@property (nonatomic,retain) UILabel * detailAddressLabel;

@property (nonatomic,retain)UITextField * remarkTF;

@property (nonatomic,strong)CityModel * model;

@property (weak, nonatomic) IBOutlet UILabel *chooseAddressName;//选择 的地址

@property (weak, nonatomic) IBOutlet UIView *BMmapView;//显示地图的View

@property (weak, nonatomic) IBOutlet UIView *bottomView;//底部的View

@property (weak, nonatomic) IBOutlet UITextField *addrTF;
@property (weak, nonatomic) IBOutlet UIButton *determineBtn;//确定按钮
@property (weak, nonatomic) IBOutlet UIView *hiddenView;
@property (weak, nonatomic) IBOutlet UITextField *detailsAddr;

@property(nonatomic,assign)int whichPage;//哪一页
-(void)addressTextBlack:(ReturnAddress)black;


@end
