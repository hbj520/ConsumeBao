//
//  RegistedViewController.h
//  eShangBao
//
//  Created by Dev on 16/1/30.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistedViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *pwdView;

@property (weak, nonatomic) IBOutlet UILabel *codeLabel;

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;//获取验证码

@property (weak, nonatomic) IBOutlet UILabel *getSpeechCheckLabel;
@property (weak, nonatomic) IBOutlet UIButton *getSpeechCheckBtn;

@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *againPwdTF;
@property (assign,nonatomic)int jump;//0 忘记密码；1 注册； 2 重置支付密码
/**
 *  获取验证码
 *
 *  @param sender 
 */
- (IBAction)getCoedButtonClick:(id)sender;

/**
 *  下一步
 *
 *  @param sender
 */
- (IBAction)nextButtonClick:(id)sender;

/**
 *  已有账号登陆
 *
 *  @param sender
 */
- (IBAction)loginButtonClick:(id)sender;

/**
 *  返回按钮
 *
 *  @param sender
 */
- (IBAction)backButtonClick:(id)sender;

@end
