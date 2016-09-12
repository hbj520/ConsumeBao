//
//  RegistedViewController.m
//  eShangBao
//
//  Created by Dev on 16/1/30.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "RegistedViewController.h"
#import "ResetPwdViewController.h"

@interface RegistedViewController ()<UITextFieldDelegate>
{
    NSTimer            *codeTime;
    int                time;//记录时间
    NSString           *codeStr;
    int                speechTime;
    int                type;
}

@end

@implementation RegistedViewController

-(void)viewWillDisappear:(BOOL)animated
{
//    codeTime=nil;
    [codeTime invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.fd_prefersNavigationBarHidden=YES;
    time=120;
    speechTime=120;
    _codeTF.delegate=self;
    _codeTF.tag=12;
    codeTime =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(codeTimeClick) userInfo:nil repeats:YES];
    [codeTime setFireDate:[NSDate distantFuture]];
    _nextBtn.layer.cornerRadius=5;
    _nextBtn.layer.masksToBounds=YES;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==12) {
        [UIView animateWithDuration:0.26 animations:^{
            self.view.frame=CGRectMake(0, -50, WIDTH, HEIGHT);
        }];
        
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==12) {
        [UIView animateWithDuration:0.26 animations:^{
            self.view.frame=CGRectMake(0, 0, WIDTH, HEIGHT);
        }];
        
    }
}
-(void)codeTimeClick
{
    
    time--;
    
    if (type==0) {
        //短信验证码
        if (time==0) {
            
            [codeTime setFireDate:[NSDate distantFuture]];
            _codeBtn.hidden=NO;
            _codeLabel.hidden=YES;
            [_getSpeechCheckBtn setTitleColor:MAINCOLOR forState:0];
            _getSpeechCheckBtn.enabled=YES;
            time=120;
            return;
        }
        _codeLabel.text=[NSString stringWithFormat:@"已发送(%ds)",time];
    }
    else
    {
        //语音验证码
        if (time==0) {
            
            [codeTime setFireDate:[NSDate distantFuture]];
            [_codeBtn setTitleColor:MAINCOLOR forState:0];
            _codeBtn.backgroundColor=[UIColor clearColor];
            _codeBtn.enabled=YES;
            
            _getSpeechCheckLabel.hidden=YES;
            _getSpeechCheckBtn.hidden=NO;
//            [_getSpeechCheckBtn setTitleColor:MAINCOLOR forState:0];
//            _getSpeechCheckBtn.enabled=YES;
            time=120;
            return;
        }
        _getSpeechCheckLabel.text=[NSString stringWithFormat:@"已发送，请注意接听电话（%ds）",time];
//        [_getSpeechCheckBtn setTitle:[NSString stringWithFormat:@"已发送，请注意接听电话（%ds）",time] forState:0];
    }
    
    

    
    DMLog(@"1");
}
- (void)didReceiveMemoryWarning {
    
    
    [super didReceiveMemoryWarning];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)nextButtonClick:(id)sender {
    
    if (_nameTF.text.length==0) {
        
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入登录名" buttonTitle:nil];
        return;
    }
   else if (_nameTF.text.length<6||_nameTF.text.length>14) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"登录名为6-14位的数字或字母" buttonTitle:nil];
   }
   else if (_phoneTF.text.length==0) {
       [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入手机号" buttonTitle:nil];
   }
   else if (_codeTF.text.length==0) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入验证码" buttonTitle:nil];
    }
    else
    {
        BOOL isNmuber=[NSString checkNumber:_nameTF.text];
        if (isNmuber) {
            NSDictionary * params=@{@"phone":_phoneTF.text,@"captcha":_codeTF.text};
            [RequstEngine requestHttp:@"1047" paramDic:params blockObject:^(NSDictionary *dic) {
                DMLog(@"1047-----%@",dic);
                DMLog(@"error----%@",dic[@"errorMsg"]);
                if ([dic[@"errorCode"]intValue]==0) {
                    NSDictionary *param=@{@"loginName":_nameTF.text};
                    [RequstEngine requestHttp:@"1056" paramDic:param blockObject:^(NSDictionary *dic) {
                        //        [activityView stopAnimate];
                        
                        DMLog(@"%@",dic);
                        DMLog(@"error---%@",dic[@"errorMsg"]);
                        if ([dic[@"errorCode"] isEqualToString:@"105601"]) {
                            
                            [self nextResetPwdViewContoroller];
                            
                        }
                        if ([dic[@"errorCode"] intValue]==0) {
                            
                            [UIAlertView alertWithTitle:@"温馨提示" message:@"对不起，该用户名已被注册" buttonTitle:nil];
                        }
                        
                    }];
                    
                }
                else
                {
                    [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                }
            }];

        }
        else
        {
            [UIAlertView alertWithTitle:@"温馨提示" message:@"登录名为6-14位的数字或字母" buttonTitle:nil];
        }
       
    }
    
    
}

-(void)nextResetPwdViewContoroller
{
    if (_phoneTF.text.length==0) {
        
        [UIAlertView alertWithTitle:@"温馨提示" message:@"电话号码不能为空" buttonTitle:nil];
        return;
    }
    if (![_codeTF.text isEqualToString:codeStr]) {
        
        [UIAlertView alertWithTitle:@"温馨提示" message:@"验证码输入错误" buttonTitle:nil];
        return;
    }
    ResetPwdViewController *resetVC=[[ResetPwdViewController alloc]init];
    resetVC.type=1;
    resetVC.jump=_jump;
    resetVC.nameStr=_nameTF.text;
    resetVC.phoneStr=_phoneTF.text;
    resetVC.codeStr=_codeTF.text;
    [self.navigationController pushViewController:resetVC animated:YES];
}

- (IBAction)loginButtonClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backButtonClick:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)getSpeechCheckNumber:(id)sender {
    
//    获取语音验证码
    
    type=1;
    
    if (![NSString validatePhone:_phoneTF.text]) {
        
        UIAlertView  *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    NSDictionary *param=@{@"phone":_phoneTF.text,@"actionType":@"0",@"type":@"1"};
    [RequstEngine requestHttp:@"1046" paramDic:param blockObject:^(NSDictionary *dic) {
        DMLog(@"1046---%@",dic);
        DMLog(@"%@",dic[@"errorMsg"]);
        
        if ([dic[@"errorCode"] intValue]==0) {
            
            codeStr=dic[@"captcha"];
            [_codeBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
            _codeBtn.enabled=NO;
            _getSpeechCheckBtn.hidden=YES;
            _getSpeechCheckLabel.hidden=NO;
            [codeTime setFireDate:[NSDate distantPast]];
            UIAlertView  *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"验证码已发出，请注意接听手机来电" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        else
        {
            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
        }
    }];

    
    
    
}
- (IBAction)getCoedButtonClick:(id)sender {
    
    type=0;
    
    if (![NSString validatePhone:_phoneTF.text]) {
        
        UIAlertView  *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    NSDictionary *param=@{@"phone":_phoneTF.text,@"actionType":@"0",@"type":@"0"};
    [RequstEngine requestHttp:@"1046" paramDic:param blockObject:^(NSDictionary *dic) {
        DMLog(@"1046---%@",dic);
        DMLog(@"%@",dic[@"errorMsg"]);
        
        if ([dic[@"errorCode"] intValue]==0) {
            
            codeStr=dic[@"captcha"];
            _codeBtn.hidden=YES;
            _codeLabel.hidden=NO;
            [_getSpeechCheckBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
            _getSpeechCheckBtn.enabled=NO;
            [codeTime setFireDate:[NSDate distantPast]];
            UIAlertView  *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"验证码已发出，请查看短信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        else
        {
            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
        }
    }];
}
@end
