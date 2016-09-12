//
//  LoginViewController.h
//  eShangBao
//
//  Created by Dev on 16/1/30.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *loginImge;
@property (weak, nonatomic) IBOutlet UITextField *loginNameTF;



@property (weak, nonatomic) IBOutlet UIImageView *pwdImage;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;

/**
 *  忘记密码
 *
 *  @param sender
 */
- (IBAction)forgetPwd:(id)sender;
/**
 *  登录
 *
 *  @param sender
 */
- (IBAction)loginButtonClick:(id)sender;
/**
 *  注册
 *
 *  @param sender 
 */
- (IBAction)registedButtonClick:(id)sender;

@end
