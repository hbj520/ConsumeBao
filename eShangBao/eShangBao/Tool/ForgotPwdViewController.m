//
//  ForgotPwdViewController.m
//  eShangBao
//
//  Created by Dev on 16/2/1.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "ForgotPwdViewController.h"
#import "ResetPwdViewController.h"

@interface ForgotPwdViewController ()<UITextFieldDelegate>
{
    NSTimer             *codeTime;
    int                 time;
    int                 nextNum;//1 输入登录名称 2 输入验证码
    int                type;
    
    NSString            *memberId;
    NSString            *phone;
    TBActivityView      *activityView;
    NSString            *captcha;
    
}

@end

@implementation ForgotPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self backButton];
    self.fd_prefersNavigationBarHidden=YES;
    nextNum=1;
    time=120;
    _codeTf.delegate=self;
    _codeTf.tag=12;
    codeTime =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(myCodeTime) userInfo:nil repeats:YES];
    [codeTime setFireDate:[NSDate distantFuture]];
    _nextBtn.layer.cornerRadius=5;
    _nextBtn.layer.masksToBounds=YES;
    
    //activityView=[TBActivityView alloc]initWithFrame:<#(CGRect)#>;
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
 
    
    // Do any additional setup after loading the view from its nib.
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

-(void)myCodeTime
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
        
    }
    
    
    
    
}
- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)codeButtonClick:(id)sender {
    
     type=0;

    NSDictionary *param=@{@"phone":phone,@"actionType":@"1",@"type":@"0"};
    [RequstEngine requestHttp:@"1046" paramDic:param blockObject:^(NSDictionary *dic) {
        
        DMLog(@"1046---%@",dic);
        
        if ([dic[@"errorCode"] intValue]==0) {
            
            captcha=dic[@"captcha"];
            [_getSpeechCheckBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
            _getSpeechCheckBtn.enabled=NO;
            _codeBtn.hidden=YES;
            _codeLabel.hidden=NO;
            [codeTime setFireDate:[NSDate distantPast]];
            [UIAlertView alertWithTitle:@"温馨提示" message:@"验证码已发出，请查看短信" buttonTitle:nil];
            
        }else{
            
            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
            
        }
        DMLog(@"captcha");
        
    }];
    
    
}
- (IBAction)nextBtnClick:(id)sender {
    
    if (nextNum==1) {
        
        if (_nameTF.text.length==0) {
            [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入登录名" buttonTitle:nil];
            return;
        }
        
        [activityView startAnimate];
        NSDictionary *param=@{@"loginName":_nameTF.text};
        [RequstEngine requestHttp:@"1056" paramDic:param blockObject:^(NSDictionary *dic) {
            
            [activityView stopAnimate];
            DMLog(@"%@",dic);
            if ([dic[@"errorCode"] intValue]==0) {
                
                phone=dic[@"member"][@"phone"];
                memberId=dic[@"member"][@"memberId"];
                nextNum=2;
                _codeView.hidden=NO;
                _getSpeechCheckBtn.hidden=NO;
                NSString *phoneTwo=[phone substringFromIndex:7];
                NSString *phoneOne=[phone substringToIndex:3];
                
                DMLog(@"%@--%@",phoneOne,phoneTwo);
                _phoneLabel.text=[NSString stringWithFormat:@"%@****%@",phoneOne,phoneTwo];
            }
            else
            {
                [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
            }
            
        }];
    }else{
        
        
        if (_codeTf.text.length==0) {
            
            [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入验证码" buttonTitle:nil];
            return;
            
        }
        if (![_codeTf.text isEqualToString:captcha]) {
            
            [UIAlertView alertWithTitle:@"温馨提示" message:@"验证码不正确，请重新输入" buttonTitle:nil];
            return;
        }
        
        NSDictionary *param=@{@"phone":phone,@"captcha":_codeTf.text};
        
        [RequstEngine requestHttp:@"1047" paramDic:param blockObject:^(NSDictionary *dic) {
            
            
            if ([dic[@"errorCode"] intValue]==0) {
                
                [self pushResetVC];
            }
            else{
                [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
            }
            
        }];
        
        
    }
    

}

-(void)pushResetVC
{
//    if (nextNum==1) {
//        
//        _codeView.hidden=NO;
//        nextNum=2;
//        return;
//    }
    
    ResetPwdViewController  *reseVC=[[ResetPwdViewController alloc]init];
    reseVC.jump=_jump;
    reseVC.loginName=_nameTF.text;
    reseVC.captcha=_codeTf.text;
    reseVC.memberId=memberId;
    [self.navigationController pushViewController:reseVC animated:YES];

}

- (IBAction)toLoginButtonClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getSpeechCheckLabelClick:(UIButton *)sender {
    
    
    
    type=1;
    NSDictionary *param=@{@"phone":phone,@"actionType":@"1",@"type":@"1"};
    [RequstEngine requestHttp:@"1046" paramDic:param blockObject:^(NSDictionary *dic) {
        
        
        DMLog(@"1046---%@",dic);
        DMLog(@"%@",dic[@"errorMsg"]);
        
        if ([dic[@"errorCode"] intValue]==0) {
            
            captcha=dic[@"captcha"];
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
@end
