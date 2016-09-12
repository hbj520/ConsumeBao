//
//  YGQJPushHelper.m
//  eShangBao
//
//  Created by doumee on 16/7/5.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "YGQJPushHelper.h"
#import "JPUSHService.h"
@implementation YGQJPushHelper

+ (void)setupWithOptions:(NSDictionary *)launchOptions {
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    // ios8之后可以自定义category
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
        // ios8之前 categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
#endif
    }
#else
    // categories 必须为nil
    [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    
    // Required
//    [JPUSHService setupWithOption:launchOptions];
    [JPUSHService setupWithOption:launchOptions appKey:@"0117f9fec4eb2277c8607b68" channel:@"App Store" apsForProduction:false advertisingIdentifier:nil];
    
   
    return;
}

//- (void)networkDidLogin:(NSNotification *)notification {
//    
//    
//    
//}

+ (void)registerDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
    DMLog(@"44444----%@",deviceToken);
    return;
}

+ (void)handleRemoteNotification:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion {
    [JPUSHService handleRemoteNotification:userInfo];
    DMLog(@"33333------%@",userInfo);
    if (completion) {
        completion(UIBackgroundFetchResultNewData);
    }
    return;
}

+ (void)showLocalNotificationAtFront:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
//    DMLog(@"-------%@",userInfo);
    return;
}

@end
