//
//  UIViewController+root.m
//  eShangBao
//
//  Created by Dev on 16/1/19.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "UIViewController+root.h"
#import "LoginViewController.h"

@implementation UIViewController (root)

-(void)backButton
{
    
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-20, -60)
//                                                             forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
//    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
//    self.tabBarController.tabBar.backgroundColor = [UIColor clearColor];
    
    
    UIButton * backsBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backsBtn.frame=CGRectMake( W(0), H(3), W(20), H(20));
    backsBtn.enabled=NO;
    [backsBtn addTarget:self action:@selector(scanAction) forControlEvents:1<<6];
    [backsBtn setImage:[UIImage imageNamed:@"返回_03"] forState:0];
    UIBarButtonItem*rightItem1=[[UIBarButtonItem alloc]initWithCustomView:backsBtn];
    self.navigationItem.leftBarButtonItem=rightItem1;
    
    
//    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    [backBtn setImage:[UIImage imageNamed:@"alert_success_icon"]];
//    self.navigationItem.backBarButtonItem = backBtn;
}

-(void)scanAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)backOtherButton
{

    UIBarButtonItem *backIetm = [[UIBarButtonItem alloc] init];
    [backIetm setTitle:@""];
    self.navigationItem.backBarButtonItem=backIetm;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

-(void)loginUser
{
    LoginViewController *loginVC=[[LoginViewController alloc]init];
    loginVC.hidesBottomBarWhenPushed=YES;
    //loginVC.fd_interactivePopDisabled
    [self.navigationController pushViewController:loginVC animated:YES];
}

@end
