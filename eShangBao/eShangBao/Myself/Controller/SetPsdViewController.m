//
//  SetPsdViewController.m
//  eShangBao
//
//  Created by doumee on 16/3/16.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "SetPsdViewController.h"

@interface SetPsdViewController ()<UITextFieldDelegate>
{
    NSString * _phoneStr;
    
    NSTimer             *codeTime;
    int                 time;
    UIButton * _checkBtn;
    NSString * captcha;//验证码
    NSString * _loginName;//登录名
    TBActivityView *activityView;
    
    int                 type;
}

@end

@implementation SetPsdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title=@"设置密码";
    self.view.backgroundColor=BGMAINCOLOR;
    
    _phoneStr=[[NSUserDefaults standardUserDefaults]objectForKey:@"selfPhone"];
    _loginName=[[NSUserDefaults standardUserDefaults]objectForKey:@"loginName"];
    time=120;
    codeTime =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(myCodeTime) userInfo:nil repeats:YES];
    [codeTime setFireDate:[NSDate distantFuture]];
    [self loadUI];
    // Do any additional setup after loading the view.
}

-(void)myCodeTime
{
    time--;
    
    if (type==0) {
        if (time==0) {
            
            [codeTime setFireDate:[NSDate distantFuture]];
            //        _checkBtn.hidden=NO;
            //        _codeLabel.hidden=YES;
            [_checkBtn setTitle:@"获取验证码" forState:0];
            [_checkBtn setTitleColor:[UIColor whiteColor] forState:0];
            _checkBtn.backgroundColor=MAINCOLOR;
            [_getSpeechCheckBtn setTitleColor:MAINCOLOR forState:0];
            _getSpeechCheckBtn.enabled=YES;
            _checkBtn.enabled=YES;
            time=120;
            return;
        }
        //    _codeLabel.text=[NSString stringWithFormat:@"已发送(%ds)",time];
        [_checkBtn setTitle:[NSString stringWithFormat:@"已发送(%ds)",time] forState:0];
    }
    else
    {
        if (time==0) {
            
            [codeTime setFireDate:[NSDate distantFuture]];
            //        _checkBtn.hidden=NO;
            //        _codeLabel.hidden=YES;
//            [_checkBtn setTitle:@"获取验证码" forState:0];
            [_checkBtn setTitleColor:[UIColor whiteColor] forState:0];
            _checkBtn.backgroundColor=MAINCOLOR;
            _checkBtn.enabled=YES;
            _getSpeechCheckLabel.hidden=YES;
            _getSpeechCheckBtn.hidden=NO;
            time=120;
            return;
        }
        //    _codeLabel.text=[NSString stringWithFormat:@"已发送(%ds)",time];
        _getSpeechCheckLabel.text=[NSString stringWithFormat:@"已发送，请注意接听电话（%ds）",time];
    }
   
    
}


-(void)loadUI
{
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, H(10)+64, WIDTH, H(44))];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
    _pswTF=[[UITextField alloc]initWithFrame:CGRectMake(W(12), 0, WIDTH, H(44))];
    _pswTF.placeholder=@"请输入通宝币支付密码";
    _pswTF.delegate=self;
    _pswTF.returnKeyType=UIReturnKeyDone;
    _pswTF.keyboardType=UIKeyboardTypeAlphabet;
    _pswTF.backgroundColor=[UIColor whiteColor];
    _pswTF.font=[UIFont systemFontOfSize:14];
    [view addSubview:_pswTF];
    
    UIView * view1=[[UIView alloc]initWithFrame:CGRectMake(0, H(10)+kDown(view), WIDTH, H(44))];
    view1.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view1];

    _againPswTF=[[UITextField alloc]initWithFrame:CGRectMake(W(12), 0, WIDTH, H(44))];
    _againPswTF.placeholder=@"请再次输入通宝币支付密码";
    _againPswTF.delegate=self;
    _againPswTF.keyboardType=UIKeyboardTypeAlphabet;
    _againPswTF.returnKeyType=UIReturnKeyDone;
    _againPswTF.backgroundColor=[UIColor whiteColor];
    _againPswTF.font=[UIFont systemFontOfSize:14];
    [view1 addSubview:_againPswTF];
    
    UIView * view2=[[UIView alloc]initWithFrame:CGRectMake(0, H(10)+kDown(view1), WIDTH, H(44))];
    view2.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view2];
    
    UILabel * phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(12), W(100), H(20))];
    NSString *phoneTwo=[_phoneStr substringFromIndex:7];
    NSString *phoneOne=[_phoneStr substringToIndex:3];
    DMLog(@"%@--%@",phoneOne,phoneTwo);
    phoneLabel.text=[NSString stringWithFormat:@"%@****%@",phoneOne,phoneTwo];
    phoneLabel.textColor=MAINCHARACTERCOLOR;
    phoneLabel.font=[UIFont systemFontOfSize:14];
    [view2 addSubview:phoneLabel];
    
    _checkBtn=[UIButton buttonWithType:0];
    _checkBtn.frame=CGRectMake(kRight(phoneLabel)+W(100), H(6), W(100), H(30));
    _checkBtn.backgroundColor=MAINCOLOR;
    _checkBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    _checkBtn.layer.cornerRadius=3;
    _checkBtn.layer.masksToBounds=YES;
    [_checkBtn addTarget:self action:@selector(checkingCode) forControlEvents:1<<6];
    [_checkBtn setTitle:@"获取验证码" forState:0];
    [_checkBtn setTitleColor:[UIColor whiteColor] forState:0];
    [view2 addSubview:_checkBtn];
    
    UIView * view3=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(view2)+H(10), WIDTH, H(44))];
    view3.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view3];
    
    _checkTF=[[UITextField alloc]initWithFrame:CGRectMake(W(12), 0, WIDTH-W(12)*2, H(44))];
    _checkTF.placeholder=@"请输入验证码";
    _checkTF.delegate=self;
    _checkTF.keyboardType=UIKeyboardTypeNumberPad;
    _checkTF.font=[UIFont systemFontOfSize:14];
    [view3 addSubview:_checkTF];
    
    _getSpeechCheckLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(view3)+10, 228, 20)];
    _getSpeechCheckLabel.font=[UIFont systemFontOfSize:14];
//    _getSpeechCheckLabel.text=@"验证码收不到，试试获取语音验证码";
//    _getSpeechCheckLabel.textColor=MAINCOLOR;
//    _getSpeechCheckLabel.backgroundColor=[UIColor redColor];
    [self.view addSubview:_getSpeechCheckLabel];
    
    _getSpeechCheckBtn=[UIButton buttonWithType:0];
    _getSpeechCheckBtn.frame=CGRectMake(W(12), kDown(view3)+10, 228, 20);
    [_getSpeechCheckBtn setTitle:@"验证码收不到，试试获取语音验证码" forState:0];
    _getSpeechCheckBtn.titleLabel.font=[UIFont systemFontOfSize:14];
//    _getSpeechCheckBtn.titleLabel.textAlignment=NSTextAlignmentLeft;
    [_getSpeechCheckBtn setTitleColor:MAINCOLOR forState:0];
    [_getSpeechCheckBtn addTarget:self action:@selector(getSpeechCheckNumber) forControlEvents:1<<6];
    [self.view addSubview:_getSpeechCheckBtn];
    
    UIButton * saveBtn=[UIButton buttonWithType:0];
    saveBtn.layer.masksToBounds=YES;
    saveBtn.layer.cornerRadius=3;
    saveBtn.frame=CGRectMake(W(20), kDown(view3)+H(80), WIDTH-W(20)*2, 40);
    saveBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    [saveBtn addTarget:self action:@selector(jump) forControlEvents:1<<6];
    [saveBtn setTitle:@"确定" forState:0];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:saveBtn];
    


}

-(void)getSpeechCheckNumber
{
    DMLog(@"获取语音验证码");
    type=1;
    
    [codeTime setFireDate:[NSDate distantPast]];
    
    [UIAlertView alertWithTitle:@"温馨提示" message:@"验证码已发出，请注意接听手机来电" buttonTitle:nil];
    
    NSDictionary *param=@{@"phone":_phoneStr,@"actionType":@"1",@"type":@"1"};
    [RequstEngine requestHttp:@"1046" paramDic:param blockObject:^(NSDictionary *dic) {
        
        DMLog(@"1046-----%@",dic);
        DMLog(@"error----%@",dic[@"errorMsg"]);
        if ([dic[@"errorCode"] intValue]==0) {
            
            captcha=dic[@"captcha"];
            _checkBtn.enabled=NO;
            _checkBtn.backgroundColor=BGMAINCOLOR;
            [_checkBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
            _getSpeechCheckBtn.hidden=YES;
            _getSpeechCheckLabel.hidden=NO;
//            [_getSpeechCheckBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
//            _getSpeechCheckBtn.enabled=NO;
            
        }else{
            
            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
            
        }
        DMLog(@"captcha");
        
    }];

}

-(void)checkingCode
{
    
    type=0;
    DMLog(@"获取验证码");
    [codeTime setFireDate:[NSDate distantPast]];
    
    [UIAlertView alertWithTitle:@"温馨提示" message:@"验证码已发出，请查看短信" buttonTitle:nil];
    
    NSDictionary *param=@{@"phone":_phoneStr,@"actionType":@"1",@"type":@"0"};
    [RequstEngine requestHttp:@"1046" paramDic:param blockObject:^(NSDictionary *dic) {
        
        DMLog(@"1046-----%@",dic);
        DMLog(@"error----%@",dic[@"errorMsg"]);
        if ([dic[@"errorCode"] intValue]==0) {
            
            captcha=dic[@"captcha"];
            _checkBtn.enabled=NO;
            _checkBtn.backgroundColor=BGMAINCOLOR;
            [_checkBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
            [_getSpeechCheckBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
            _getSpeechCheckBtn.enabled=NO;
            
        }else{
            
            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
            
        }
        DMLog(@"captcha");
        
    }];

    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


-(void)jump
{
    DMLog(@"绑定");
    if (_pswTF.text.length==0) {
        
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入密码" buttonTitle:nil];
        return;
    }
    else if (![_pswTF.text isEqualToString:_againPswTF.text]) {
        
        [UIAlertView alertWithTitle:@"温馨提示" message:@"输入密码前后不一致" buttonTitle:nil];
        return;
        
    }
    else if (_checkTF.text.length==0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入验证码" buttonTitle:nil];
        return;
    }
    else
    {
        NSDictionary * param=@{@"phone":_phoneStr,@"captcha":captcha};
        [RequstEngine requestHttp:@"1047" paramDic:param blockObject:^(NSDictionary *dic) {
            DMLog(@"1047-----%@",dic);
            DMLog(@"error----%@",dic[@"errorMsg"]);
            if ([dic[@"errorCode"]intValue]==00000) {
                NSDictionary * params=@{@"memberId":USERID,@"userPwd":_pswTF.text,@"captcha":[NSString stringWithFormat:@"%@",captcha],@"actionType":@"1"};
                [RequstEngine requestHttp:@"1048" paramDic:params blockObject:^(NSDictionary *dic) {
                    DMLog(@"1048-----%@",dic);
                    DMLog(@"error----%@",dic[@"errorMsg"]);
                    if ([dic[@"errorCode"]intValue]==00000) {
                        [UIAlertView alertWithTitle:@"温馨提示" message:@"设置密码成功" buttonTitle:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else
                    {
                        [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                    }
                }];
            }
            else
            {
                [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
            }
        }];

    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
