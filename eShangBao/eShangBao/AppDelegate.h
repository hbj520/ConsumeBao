//
//  AppDelegate.h
//  eShangBao
//
//  Created by doumee on 16/1/13.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager* _mapManager;
}

@property (strong, nonatomic) UIWindow *window;


@end

