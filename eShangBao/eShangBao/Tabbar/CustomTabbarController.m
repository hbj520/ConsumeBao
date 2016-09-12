//
//  CustomTabbarController.m
//  自定义tabbar
//
//  Created by Hanguoxiang on 15-1-28.
//  Copyright (c) 2015年 zhangyuanyuan. All rights reserved.
//

#import "CustomTabbarController.h"

#define EACH_W(A) ([UIScreen mainScreen].bounds.size.width/A)
#define EACH_H (self.tabBar.bounds.size.height)
#define BTNTAG 10000
#import "SellerViewController.h"
#import "OrderViewController.h"
#import "MyselfViewController.h"
#import "MainViewController.h"

@interface CustomTabbarController ()

@end

@implementation CustomTabbarController
{
    UIButton *_button;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
            }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initControllers];
    
}
#pragma mark - 如果想添加控制器到tabbar里面在这里面实例化就行
- (void)initControllers
{
    MainViewController *homeVC = [[MainViewController alloc]init];
    homeVC.title=@"消费宝";
    SellerViewController *sellerVC = [[SellerViewController alloc]init];
    sellerVC.title=@"商家";
    OrderViewController *orderVC = [[OrderViewController alloc]init];
    orderVC.title=@"订单";
    MyselfViewController *myselfVC = [[MyselfViewController alloc]init];
    myselfVC.title=@"我的";
    
    NSArray *viewController=@[homeVC,sellerVC,orderVC,myselfVC];
    NSArray * normImage = @[@"homeIcon",@"mallIcon",@"orderIcon",@"myselfIcon"];
    NSMutableArray *navArrs=[NSMutableArray arrayWithCapacity:0];
    int i=0;
    for (UIViewController *addView in viewController) {
        
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:addView];
        nav.navigationBar.barTintColor=MAINCOLOR;
        nav.fd_prefersNavigationBarHidden=YES;
        self.navigationController.navigationBarHidden=YES;

        [nav.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        nav.tabBarItem.image=[UIImage imageNamed:normImage[i]];
        [navArrs addObject:nav];
        i++;
        self.tabBarController.tabBar.backgroundColor = [UIColor clearColor];
//        self.tabBarController.tabBar.selectionIndicatorImage = nil;
    }
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    [self.tabBar setTintColor:MAINCOLOR];
//    self.tabBarController.tabBar.backgroundColor = [UIColor clearColor];
    self.viewControllers=navArrs;
}
@end
