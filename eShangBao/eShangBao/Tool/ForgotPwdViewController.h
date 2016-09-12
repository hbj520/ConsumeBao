//
//  ForgotPwdViewController.h
//  eShangBao
//
//  Created by Dev on 16/2/1.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPwdViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTf;
- (IBAction)codeButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UIButton *getSpeechCheckBtn;
@property (weak, nonatomic) IBOutlet UILabel *getSpeechCheckLabel;

@property (weak, nonatomic) IBOutlet UIView *nemeView;
@property (weak, nonatomic) IBOutlet UIView *codeView;


- (IBAction)nextBtnClick:(id)sender;
- (IBAction)toLoginButtonClick:(id)sender;
- (IBAction)getSpeechCheckLabelClick:(UIButton *)sender;


@property(nonatomic,assign)int jump;//0 忘记密码；1 注册； 2 重置支付密码
@end
