//
//  LoginViewController.m
//  eShangBao
//
//  Created by Dev on 16/1/30.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistedViewController.h"
#import "ForgotPwdViewController.h"


@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"登录";
    
    _loginBtn.layer.cornerRadius=5;
    _loginBtn.layer.masksToBounds=YES;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark textFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==1) {
        _loginImge.image=[UIImage imageNamed:@"登录1_03"];
        _pwdImage.image=[UIImage imageNamed:@"登录1_10"];
    }
    if (textField.tag==2) {
        
        _pwdImage.image=[UIImage imageNamed:@"登录_06"];
        _loginImge.image=[UIImage imageNamed:@"登录_03"];
    }
    
    DMLog(@"dd");
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _pwdImage.image=[UIImage imageNamed:@"登录1_10"];
    _loginImge.image=[UIImage imageNamed:@"登录_03"];

    DMLog(@"玩了");
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ButtonClick

- (IBAction)backBtnClick:(id)sender {
//    self.navigationController.navigationBarHidden=NO;
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)forgetPwd:(id)sender {
    
    ForgotPwdViewController *gorgotVC=[[ForgotPwdViewController alloc]init];
    gorgotVC.jump=0;
    [self.navigationController pushViewController:gorgotVC animated:YES];
    DMLog(@"忘记密码");
    
}

- (IBAction)loginButtonClick:(id)sender {
    
    if (_loginNameTF.text.length==0) {
        
        [UIAlertView alertWithTitle:@"温馨提示" message:@"登录名不能为空" buttonTitle:nil];
        return;
    }
    if (_pwdTF.text.length==0) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入密码" buttonTitle:nil];
        return;
    }
    NSDictionary *param=@{@"loginName":_loginNameTF.text,@"pwd":_pwdTF.text};
    [RequstEngine requestHttp:@"1001" paramDic:param blockObject:^(NSDictionary *dic) {
        
        DMLog(@"%@",dic);
        if ([dic[@"errorCode"] intValue]==0) {
            
            DMLog(@"name---%@",dic[@"member"][@"levelName"]);
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"member"][@"memberId"] forKey:@"userID"];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"member"][@"type"] forKey:@"userType"];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"member"][@"levelName"] forKey:@"levelName"];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"member"][@"parterLevel"] forKey:@"parterLevel"];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"member"][@"partnerAgencyPayStatus"] forKey:@"partnerAgencyPayStatus"];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"member"][@"goldNum"] forKey:@"goldNum"];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"member"][@"inviteCode"] forKey:@"inviteCode"];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"member"][@"phone"] forKey:@"selfPhone"];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"member"][@"loginName"] forKey:@"loginName"];
            [[NSUserDefaults standardUserDefaults] synchronize];
//            self.navigationController.navigationBarHidden=NO;
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else{
            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
        }
    }];
    
    DMLog(@"登录");
}

- (IBAction)registedButtonClick:(id)sender {
    
    RegistedViewController *registeVC=[[RegistedViewController alloc]init];
    registeVC.jump=1;
    [self.navigationController pushViewController:registeVC animated:YES];
    DMLog(@"去注册");
}
@end
