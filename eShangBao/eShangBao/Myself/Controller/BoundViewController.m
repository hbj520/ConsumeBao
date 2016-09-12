
//
//  BoundViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/19.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "BoundViewController.h"
#import "BankCardViewController.h"
#import "LoginViewController.h"
@interface BoundViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    NSString * _captcha;//验证码
    NSTimer  * _timer;
    int        i;
    int        _type;
}

@end

@implementation BoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.view.backgroundColor=BGMAINCOLOR;
    self.title=@"更换手机号码";
    i=120;
    // 加载UI
    [self loadUI];
    // Do any additional setup after loading the view.
}

-(void)loadUI
{
    UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(0, H(10)+64, WIDTH, H(40)*3)];
    coverView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:coverView];
    
    _phoneTF=[[UITextField alloc]initWithFrame:CGRectMake( W(12), 0, WIDTH-W(12)-W(90), H(40))];
    _phoneTF.returnKeyType=UIReturnKeyDone;
    _phoneTF.placeholder=@"输入新的手机号";
    _phoneTF.delegate=self;
//    _phoneTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"输入您的手机号" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:19/255.0 green:19/255.0  blue:19/255.0  alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:32*KRatioH]}];
    _phoneTF.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:_phoneTF];
    
    
    _checkBtn=[UIButton buttonWithType:0];
    _checkBtn.frame=CGRectMake(kRight(_phoneTF), H(5), W(80), H(30));
    _checkBtn.backgroundColor=RGBACOLOR(251, 98, 7, 1);
    _checkBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [_checkBtn addTarget:self action:@selector(checkPsw) forControlEvents:1<<6];
    [_checkBtn setTitle:@"获取验证码" forState:0];
    _checkBtn.layer.cornerRadius=3;
    _checkBtn.layer.masksToBounds=YES;
    [_checkBtn setTitleColor:[UIColor whiteColor] forState:0];
    [coverView addSubview:_checkBtn];
    
    _checkTF=[[UITextField alloc]initWithFrame:CGRectMake(W(12), kDown(_phoneTF), WIDTH-W(12)-W(80), H(40))];
//    _checkTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:19/255.0 green:19/255.0  blue:19/255.0  alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:32*KRatioH]}];
    _checkTF.returnKeyType=UIReturnKeyDone;
    _checkTF.placeholder=@"请输入验证码";
    _checkTF.delegate=self;
    _checkTF.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:_checkTF];
    
    
    _pswTF=[[UITextField alloc]initWithFrame:CGRectMake(W(12), kDown(_checkTF), WIDTH-W(12)-50, H(40))];
    _pswTF.delegate=self;
//    _pswTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:19/255.0 green:19/255.0  blue:19/255.0  alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:32*KRatioH]}];
    _pswTF.returnKeyType=UIReturnKeyDone;
    _pswTF.secureTextEntry=YES;
    _pswTF.placeholder=@"请输入登录密码";
    _pswTF.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:_pswTF];
    
    _askBtn=[UIButton buttonWithType:0];
    _askBtn.frame=CGRectMake(kRight(_pswTF), kDown(_checkTF), 40, 40);
    [_askBtn addTarget:self action:@selector(askMsg) forControlEvents:1<<6];
    [_askBtn setImage:[UIImage imageNamed:@"ask_icon_gray"] forState:0];
    [coverView addSubview:_askBtn];
    
    for (int j=0; j<2; j++) {
        UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(39)+j*H(40), WIDTH, H(1))];
        lineLabel.backgroundColor=BGMAINCOLOR;
        [coverView addSubview:lineLabel];
    }
    
    _getSpeechCheckLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(coverView)+10, 228, 20)];
    _getSpeechCheckLabel.font=[UIFont systemFontOfSize:14];
    //    _getSpeechCheckLabel.text=@"验证码收不到，试试获取语音验证码";
    //    _getSpeechCheckLabel.textColor=MAINCOLOR;
    //    _getSpeechCheckLabel.backgroundColor=[UIColor redColor];
    [self.view addSubview:_getSpeechCheckLabel];
    
    _getSpeechCheckBtn=[UIButton buttonWithType:0];
    _getSpeechCheckBtn.frame=CGRectMake(W(12), kDown(coverView)+10, 228, 20);
    [_getSpeechCheckBtn setTitle:@"验证码收不到，试试获取语音验证码" forState:0];
    _getSpeechCheckBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    //    _getSpeechCheckBtn.titleLabel.textAlignment=NSTextAlignmentLeft;
    [_getSpeechCheckBtn setTitleColor:MAINCOLOR forState:0];
    [_getSpeechCheckBtn addTarget:self action:@selector(getSpeechCheckNumber) forControlEvents:1<<6];
    [self.view addSubview:_getSpeechCheckBtn];
    
    UIButton * boundBtn=[UIButton buttonWithType:0];
    boundBtn.layer.masksToBounds=YES;
    boundBtn.layer.cornerRadius=3;
    boundBtn.frame=CGRectMake(W(20), kDown(coverView)+H(60), WIDTH-W(20)*2, 40);
    boundBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    [boundBtn addTarget:self action:@selector(jump) forControlEvents:1<<6];
    [boundBtn setTitle:@"确定" forState:0];
    [boundBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:boundBtn];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}


#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
            
        case 1:
        {
            [RequstEngine requestHttp:@"1088" paramDic:nil blockObject:^(NSDictionary *dic) {
                DMLog(@"1088---%@",dic);
                if ([dic[@"errorCode"] intValue]==0) {
//                    _bankName=dic[@"record"][@"bankName"];
//                    _bankNO=dic[@"record"][@"bankNo"];
//                    _weixin=dic[@"record"][@"weixinNo"];
//                    _alipay=dic[@"record"][@"alipayNo"];
//                    _bankUserName=dic[@"record"][@"bankPN"];
//                    _alipayUserName=dic[@"record"][@"alipayPN"];
//                    _dataArr=[NSMutableArray arrayWithObjects:_bankName,_bankNO,@"",_weixin,@"",_alipay, nil];
//                    _helpLabel.text=[NSString stringWithFormat:@"如需要帮助或有疑问，欢迎致电%@",dic[@"record"][@"linkPhone"]];
                    NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",dic[@"record"][@"linkPhone"]];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];

                    
                }
                else
                {
                    [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                }
            }];

        }
            
            break;
        default:
            break;
    }
}
#pragma mark - 按钮绑定的方法

#pragma mark - 获取短信验证码
-(void)checkPsw
{
    _type=0;

    
    if (_phoneTF.text.length==0) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入手机号码" buttonTitle:nil];
        
    }
    else if (![NSString validatePhone:_phoneTF.text]) {
        
        UIAlertView  *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
//        return;
    }
    else
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        [_timer fire];
        NSDictionary * param=@{@"phone":_phoneTF.text,@"actionType":@"2",@"type":@"0"};
        [RequstEngine requestHttp:@"1046" paramDic:param blockObject:^(NSDictionary *dic) {
            DMLog(@"1046----%@",dic);
            DMLog(@"error----%@",dic[@"errorMsg"]);
            if ([dic[@"errorCode"] intValue]==00000) {
                _captcha=dic[@"captcha"];
                _checkBtn.enabled=NO;
                _checkBtn.backgroundColor=BGMAINCOLOR;
                [_checkBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
                [_getSpeechCheckBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
                _getSpeechCheckBtn.enabled=NO;
            }
            else
            {
                [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
            }
        }];

    }
}

#pragma mark - 获取语音验证码

-(void)getSpeechCheckNumber
{
    DMLog(@"获取语音验证码");
    _type=1;
    
    if (_phoneTF.text.length==0) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入手机号" buttonTitle:nil];
    }
    
    else if (![NSString validatePhone:_phoneTF.text]) {
        
        UIAlertView  *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        //
    }
    else
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        [_timer fire];
        
        [UIAlertView alertWithTitle:@"温馨提示" message:@"验证码已发出，请注意接听手机来电" buttonTitle:nil];
        
        NSDictionary *param=@{@"phone":_phoneTF.text,@"actionType":@"2",@"type":@"1"};
        [RequstEngine requestHttp:@"1046" paramDic:param blockObject:^(NSDictionary *dic) {
            
            DMLog(@"1046-----%@",dic);
            DMLog(@"error----%@",dic[@"errorMsg"]);
            if ([dic[@"errorCode"] intValue]==0) {
                
                _captcha=dic[@"captcha"];
                
                _checkBtn.enabled=NO;
                _checkBtn.backgroundColor=BGMAINCOLOR;
                [_checkBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
                [_getSpeechCheckBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
                _getSpeechCheckBtn.enabled=NO;
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
    
}

#pragma mark - 询问客服
-(void)askMsg
{
    UIAlertView * askAlert=[[UIAlertView alloc]initWithTitle:@"提示信息" message:@"如果忘记登录密码，请致电我们客服协助您更换手机号" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"联系客服", nil];
    askAlert.delegate=self;
    [askAlert show];
}



-(void)loginUser
{
    LoginViewController * loginVC=[[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}


#pragma mark - 计时器方法
// 定时器方法
- (void)onTimer
{
    
    if (_type==0) {
        // 手机验证码
        [_checkBtn setTitle:[NSString stringWithFormat:@"%ds",i] forState:UIControlStateNormal];
//                _checkBtn.userInteractionEnabled=NO;
        
        if (i == 0)
        {
            [_timer invalidate];
            [_checkBtn setTitle:@"获取验证码" forState:0];
            [_checkBtn setTitleColor:[UIColor whiteColor] forState:0];
            _checkBtn.backgroundColor=MAINCOLOR;
            [_getSpeechCheckBtn setTitleColor:MAINCOLOR forState:0];
            _getSpeechCheckBtn.enabled=YES;
//            _checkBtn.enabled=YES;
            i = 120;
        }
        
    }
    else
    {
        _getSpeechCheckLabel.text=[NSString stringWithFormat:@"已发送，请注意接听电话（%ds）",i];
        //        _checkBtn.userInteractionEnabled=NO;
        
        if (i == 0)
        {
            [_timer invalidate];
            [_checkBtn setTitle:@"获取验证码" forState:0];
            [_checkBtn setTitleColor:[UIColor whiteColor] forState:0];
            _checkBtn.enabled=YES;
            _checkBtn.backgroundColor=MAINCOLOR;
            _getSpeechCheckBtn.hidden=NO;
            [_getSpeechCheckBtn setTitleColor:MAINCOLOR forState:0];
            _getSpeechCheckBtn.enabled=YES;
            _getSpeechCheckLabel.hidden=YES;
            //            _checkBtn.enabled=YES;
            
            i = 120;
        }
        
    }
    
    i--;
    
}

-(void)jump
{
    if (![NSString isLogin]) {
        [self loginUser];
    }
    else if (_phoneTF.text.length==0) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入手机号" buttonTitle:nil];
    }
    else if (_checkTF.text.length==0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入验证码" buttonTitle:nil];
    }
    else if (_pswTF.text.length==0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入密码" buttonTitle:nil];
    }
    else
    {
        NSDictionary * dict=@{@"phone":_phoneTF.text,@"captcha":_checkTF.text};
        [RequstEngine requestHttp:@"1047" paramDic:dict blockObject:^(NSDictionary *dics) {
//
            if ([dics[@"errorCode"]intValue]==00000) {
                NSDictionary * param=@{@"newPhone":_phoneTF.text,@"captcha":_checkTF.text,@"pwd":_pswTF.text};
                [RequstEngine requestHttp:@"1095" paramDic:param blockObject:^(NSDictionary *dic) {
                    DMLog(@"1095--%@",dic);
                    DMLog(@"error--%@",dic[@"errorMsg"]);
                    if ([dic[@"errorCode"] intValue]==00000) {
                        [UIAlertView alertWithTitle:@"温馨提示" message:@"更换手机号成功" buttonTitle:nil];
                        _block(_phoneTF.text);
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
                [UIAlertView alertWithTitle:@"温馨提示" message:dics[@"errorMsg"] buttonTitle:nil];
            }
        }];

    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
