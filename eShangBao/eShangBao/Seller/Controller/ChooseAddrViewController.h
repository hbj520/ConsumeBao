//
//  ChooseAddrViewController.h
//  eShangBao
//
//  Created by Dev on 16/1/23.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

typedef void (^ReturnAddrBlock)(NSDictionary *addrssDic);

@interface ChooseAddrViewController : UIViewController
{
    BMKMapView            *_mapView;
    BMKLocationService    *_locationService;
    BMKPoiSearch          *_search;
    BMKGeoCodeSearch      *_geocodesearch;
}

@property (nonatomic, copy) ReturnAddrBlock returnTextBlock;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIView *BMMapView;
@property (weak, nonatomic) IBOutlet UITableView *addrTabel;
@property (weak, nonatomic) IBOutlet UILabel *chooseLabel;
@property (weak, nonatomic) IBOutlet UIView *titalView;

- (void)returnText:(ReturnAddrBlock)block;


@end
