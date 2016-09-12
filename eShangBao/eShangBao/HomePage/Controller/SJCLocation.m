//
//  SJCLocation.m
//  eShangBao
//
//  Created by Dev on 16/7/4.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "SJCLocation.h"

@implementation SJCLocation


-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        [self createMapView];
    }
    return self;
}

-(void)createMapView
{
    _mapView=[[BMKMapView alloc]initWithFrame:self.bounds];
    [_mapView viewWillAppear];
    _mapView.delegate=self;
    _geocodesearch.delegate = self;
    
    [self addSubview:_mapView];
    
    _mapView.mapType=BMKMapTypeStandard;
    _mapView.showsUserLocation=YES;
    
    _locationService=[[BMKLocationService alloc]init];
    _locationService.delegate=self;
    [_locationService startUserLocationService];
    _geocodesearch=[[BMKGeoCodeSearch alloc]init];

    
}

-(void)locationLatitude:(NSString *)latitude locationLongitude:(NSString *)longitude
{
    BMKCoordinateSpan span={0.003,0.003};
    storeLocation=[[CLLocation alloc]initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    BMKCoordinateRegion region={storeLocation.coordinate,span};
   [_mapView setRegion:region];
    
}

-(void)mapStatusDidChanged:(BMKMapView *)mapView
{
    userMy  =[[RouteAnno alloc]init];
    userMy.coordinate   = storeLocation.coordinate;
    userMy  .type =3;
    userMy.title = _storeName;
    [_mapView addAnnotation:userMy];
}

-(void)setStoreName:(NSString *)storeName
{
    _storeName = storeName;

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
//        if (_isMylocaton) {
            view.image=[UIImage imageNamed:@"location"];
            
//        }else{
//            view.image=[UIImage imageNamed:@"myLocation"];
//            _isMylocaton=YES;
//        }
//        
        //        这是气泡
        view.canShowCallout = TRUE;
        view.draggable=YES;
    }
    view.annotation = routeAnnotation;
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
