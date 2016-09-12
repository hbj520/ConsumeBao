//
//  YGQJPushHelper.h
//  eShangBao
//
//  Created by doumee on 16/7/5.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface YGQJPushHelper : NSObject

// 在应用启动的时候调用
+ (void)setupWithOptions:(NSDictionary *)launchOptions;

// 在appdelegate注册设备处调用
+ (void)registerDeviceToken:(NSData *)deviceToken;

// ios7以后，才有completion，否则传nil
+ (void)handleRemoteNotification:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion;

// 显示本地通知在最前面
+ (void)showLocalNotificationAtFront:(UILocalNotification *)notification;

@end
