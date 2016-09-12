//
//  SJCLocation.h
//  eShangBao
//
//  Created by Dev on 16/7/4.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "RouteAnno.h"


@interface SJCLocation : UIView<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKShareURLSearchDelegate,BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate>
{
    BMKMapView            *_mapView;
    BMKLocationService    *_locationService;
    BMKPoiSearch          *_search;
    BMKGeoCodeSearch      *_geocodesearch;
    BMKMapManager *mapmanger;
    RouteAnno *userMy;
    CLLocation  *storeLocation;
}
@property(nonatomic,strong)NSString          *latitude;//纬度
@property(nonatomic,strong)NSString          *longitude;//经度
@property(nonatomic,strong)NSString          *storeName;

-(void)locationLatitude:(NSString *)latitude locationLongitude:(NSString *)longitude;

@end
