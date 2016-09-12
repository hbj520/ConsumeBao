//
//  ResetPwdViewController.h
//  eShangBao
//
//  Created by Dev on 16/2/1.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPwdViewController : UIViewController


@property(nonatomic,strong)NSString   *codeStr;
@property(nonatomic,strong)NSString   *phoneStr;
@property(nonatomic,strong)NSString   *nameStr;

@property(nonatomic,assign)int                   type;//1 注册 2 找回密码

@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *againPwdTF;
@property (weak, nonatomic) IBOutlet UIButton    *lookBtn;
@property (nonatomic,assign)int jump;//0 忘记密码；1 注册； 2 重置支付密码
@property (nonatomic,retain)NSString * loginName;//登录名
@property (nonatomic,retain)NSString * userPwd;//密码
@property (nonatomic,retain)NSString * captcha;//验证码
@property (nonatomic,retain)NSString * memberId;
@property (weak, nonatomic) IBOutlet UIButton    *completeBtn;
- (IBAction)completeButton:(id)sender;
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *chooseAgreeBtn;
@property (weak, nonatomic) IBOutlet UILabel *agreeLabel;
@property (weak, nonatomic) IBOutlet UIButton *xieyiBtn;

@end
