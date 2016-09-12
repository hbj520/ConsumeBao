//
//  AppDelegate.m
//  eShangBao
//
//  Created by doumee on 16/1/13.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import "CustomTabbarController.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import "WXApiObject.h"
#import "LinkPageViewController.h"

#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"

#import "JPUSHService.h"
//#import "RootViewController.h"
#import <AdSupport/AdSupport.h>
#import "YGQJPushHelper.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()<BMKGeneralDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]];
    
    
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"H2NUhPW1xtc96s9qx9k9bXdj"  generalDelegate:self];
    
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    // 向微信注册
    [WXApi registerApp:@"wxbbcf236b07638282" withDescription:@"demo 2.0"];
    [self shareConfiguration];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"one"]) {
        [self linkPageRoot];
    }else{
        
        [self mianVcRoot];
    }
    
    [YGQJPushHelper setupWithOptions:launchOptions];
    
    return YES;
}

-(void)shareConfiguration
{
    [ShareSDK registerApp:@"1009afc3e7910"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"3415760994"
                                           appSecret:@"6d04b63e7b932e3db9b96183080292f9"
                                         redirectUri:@"http://www.doumee.com/app/xiaofeibao/index.html"
                                            authType:SSDKAuthTypeBoth];
                 break;
                 //微信
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxf652d0555c43ebef"
                                       appSecret:@"8f3c90a365d9b87aee42bb9adce4d187"];
                 break;
                 //qq
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105153803"
                                      appKey:@"64crRZFM2OAVNfY2"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];

}


-(void)linkPageRoot{
    LinkPageViewController * linkPage=[[LinkPageViewController alloc]init];
    self.window.rootViewController=linkPage;
    void(^myBlock)(void)=^{
        
        [self mianVcRoot];
        
    };
    linkPage.Block=myBlock;
    
    
}

-(void)mianVcRoot{
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >=7) {
        self.window.clipsToBounds = YES;
        self.window.frame = CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height);
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    CustomTabbarController *custom = [[CustomTabbarController alloc]init];
    self.window.rootViewController = custom;

}


#pragma mark BMKGeneralDelegate
-(void)onGetNetworkState:(int)iError{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}
-(void)onGetPermissionState:(int)iError{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService]processOrderWithPaymentResult:url
                                                 standbyCallback:^(NSDictionary *resultDic)
         {
              DMLog(@"results = %@", resultDic);
             if ([resultDic[@"resultStatus"] intValue]==9000) {
                 NSDictionary * param=@{@"orderId":ORDERID,@"payType":@"2"};
                 [RequstEngine requestHttp:@"1063" paramDic:param blockObject:^(NSDictionary *dic) {
                     DMLog(@"1063---%@",dic);
                     DMLog(@"error---%@",dic[@"errorMsg"]);
                 }];
             }
                                                     
        }];
    }
    
    [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            DMLog(@"result = %@",resultDic);
        }];
        return YES;
    }else{
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
}



-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){  
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                DMLog(@"支付成功");
                break;
            default:
                DMLog(@"支付失败");
                break;
        }
    }
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [YGQJPushHelper registerDeviceToken:deviceToken];
    DMLog(@"55555-------%@",deviceToken);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    //    DMLog(@"11111111%@",userInfo);
    //    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    //    if (application.applicationState == UIApplicationStateActive) {
    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"推送消息"
    //                                                            message:alert
    //                                                           delegate:self
    //                                                  cancelButtonTitle:@"OK"
    //                                                  otherButtonTitles:nil];
    //        [alertView show];
    //    }
    //    [application setApplicationIconBadgeNumber:0];
    //    [JPUSHService handleRemoteNotification:userInfo];
    DMLog(@"11111-------%@",userInfo);
    [YGQJPushHelper handleRemoteNotification:userInfo completion:nil];
    
    //    AVSpeechSynthesizer *av = [[AVSpeechSynthesizer alloc]init];
    //    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:userInfo[@"aps"][@"alert"]];  //需要转换的文本
    //    [av speakUtterance:utterance];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
// ios7.0以后才有此功能
- (void)application:(UIApplication *)application didReceiveRemoteNotification
                   :(NSDictionary *)userInfo fetchCompletionHandler
                   :(void (^)(UIBackgroundFetchResult))completionHandler {
    [YGQJPushHelper handleRemoteNotification:userInfo completion:completionHandler];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"push"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    DMLog(@"adfadsf----%@",userInfo);
    
//    if (_infoDic.count>0)return;
//    
//    if ([userInfo[@"key"] intValue]==1) {
//        
//        if ([isOrder intValue]==1) {
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
//                                                            message:@"您有新的订单请刷新数据"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"取消"
//                                                  otherButtonTitles:nil];
//            [alert show];
//            
//            return;
//        }
//        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeBadgeValue" object:nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:userInfo[@"aps"][@"alert"]
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        [alert show];
        
//    }
    
    
    
    // 应用正处理前台状态下，不会收到推送消息，因此在此处需要额外处理一下
    //    if (application.applicationState == UIApplicationStateActive) {
    //
    //
    //
    //
    //
    //
    //    }
    //    else if(application.applicationState==UIApplicationStateBackground)
    //    {
    //
    //    }
    //    else
    //    {
    //
    //    }
    
    DMLog(@"22222-------%@",userInfo);
    return;
}

#pragma maak- 获取当前页面
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [YGQJPushHelper showLocalNotificationAtFront:notification];
    
    DMLog(@"66666-----%@",notification.alertBody);
    
    return;
}

#endif

@end
