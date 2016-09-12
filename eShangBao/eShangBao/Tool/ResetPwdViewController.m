//
//  ResetPwdViewController.m
//  eShangBao
//
//  Created by Dev on 16/2/1.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "ResetPwdViewController.h"
#import "WebViewController.h"
@interface ResetPwdViewController ()
{
    BOOL _isSeletect;//是否同意
    NSMutableArray * _withdrawArr;
    NSMutableArray * _contentArr;

    NSString       * _withdrawStr;
    
    NSString       * _elseWithStr;
    TBActivityView *activityView;
}

@end

@implementation ResetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    _isSeletect=NO;
    self.fd_prefersNavigationBarHidden=YES;
    _titleName.text=(_type==1)?@"注册":@"找回密码";
    _completeBtn.layer.cornerRadius=5;
    _completeBtn.layer.masksToBounds=YES;
    if (_type==1) {
        _chooseAgreeBtn.hidden=NO;
        _agreeLabel.hidden=NO;
        _xieyiBtn.hidden=NO;
    }
    else
    {
        _chooseAgreeBtn.hidden=YES;
        _agreeLabel.hidden=YES;
        _xieyiBtn.hidden=YES;
    }
    _withdrawArr = [NSMutableArray arrayWithCapacity:0];
    _contentArr  = [NSMutableArray arrayWithCapacity:0];
    
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)completeButton:(id)sender {
    
    if (_pwdTF.text.length==0) {
        
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入密码" buttonTitle:nil];
        return;
    }
    else if (![_pwdTF.text isEqualToString:_againPwdTF.text]) {
        
        [UIAlertView alertWithTitle:@"温馨提示" message:@"输入密码前后不一致" buttonTitle:nil];
        return;

    }
    else if (_isSeletect==NO&&_type==1)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请先同意消费宝用户协议" buttonTitle:nil];
    }
    else
    {
        if (_jump==0) {
            NSDictionary * param=@{@"memberId":_memberId,@"userPwd":_pwdTF.text,@"captcha":_captcha,@"actionType":@"0"};
            [RequstEngine requestHttp:@"1048" paramDic:param blockObject:^(NSDictionary *dic) {
                DMLog(@"1048----%@",dic);
                DMLog(@"error-----%@",dic[@"errorMsg"]);
                if ([dic[@"errorCode"]intValue]==00000) {
                    [UIAlertView alertWithTitle:@"温馨提示" message:@"修改登录密码成功" buttonTitle:nil];
//                    [self.navigationController ]
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                }
            }];
        }
        else if (_jump==1)
        {
            NSDictionary  *param=@{@"phone":_phoneStr,@"loginName":_nameStr,@"captcha":_codeStr,@"pwd":_pwdTF.text};
            [RequstEngine requestHttp:@"1002" paramDic:param blockObject:^(NSDictionary *dic) {
                
                DMLog(@"%@",dic);
                
                
                if ([dic[@"errorCode"] intValue]==0) {
                    
                    
                    [[NSUserDefaults standardUserDefaults] setObject:dic[@"member"][@"memberId"] forKey:@"userID"];
                    [[NSUserDefaults standardUserDefaults] setObject:dic[@"member"][@"inviteCode"] forKey:@"inviteCode"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [UIAlertView alertWithTitle:@"温馨提示" message:@"注册成功" buttonTitle:nil];
                    
                    NSArray *viewArr=self.navigationController.viewControllers;
                    UIViewController *newView=[viewArr objectAtIndex:viewArr.count-4];
                    [self.navigationController popToViewController:newView animated:YES];
                    return;
                    
                }else{
                    
                    UIAlertView  *aletView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:dic[@"errorMsg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [aletView show];
                }
                
                
            }];

        }
        else
        {
            NSDictionary * param=@{@"loginName":_loginName,@"userPwd":_pwdTF.text,@"captcha":_captcha,@"actionType":@"1"};
            [RequstEngine requestHttp:@"1048" paramDic:param blockObject:^(NSDictionary *dic) {
                DMLog(@"1048----%@",dic);
                DMLog(@"error-----%@",dic[@"errorMsg"]);
                if ([dic[@"errorCode"]intValue]==00000) {
                    [UIAlertView alertWithTitle:@"温馨提示" message:@"修改支付密码成功" buttonTitle:nil];
                }
            }];
 
        }
    }
    
    
    DMLog(@"完成");
    
}

- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)chooseISAgree:(id)sender {
    //同意或不同意
    static int i=0;
    i++;
    if (i%2==1) {
        _isSeletect=YES;
        [_chooseAgreeBtn setBackgroundImage:[UIImage imageNamed:@"checked"] forState:0];
    }
    else
    {
        _isSeletect=NO;
        [_chooseAgreeBtn setBackgroundImage:[UIImage imageNamed:@"uncheck"] forState:0];
    }

}
- (IBAction)chooseNagotiate:(id)sender {
    
    [activityView startAnimate];
    //点击协议
//    NSDictionary * param=@{@"requestType":@"1"};
//    [RequstEngine requestHttp:@"1058" paramDic:nil blockObject:^(NSDictionary *dic) {
//        DMLog(@"1058----%@",dic);
//        DMLog(@"error----%@",dic[@"errorMsg"]);
//        if ([dic[@"errorCode"] intValue]==0) {
//            WebViewController *advertringVC=[[WebViewController alloc]init];
//            advertringVC.hidesBottomBarWhenPushed=YES;
//            //            advertringVC.adModel=model;
//            //            advertringVC.add=0;
//            advertringVC.content=dic[@"data"][@"content"];
//            [self.navigationController pushViewController:advertringVC animated:YES];
//        }
//    }];
    
    [RequstEngine requestHttp:@"1058" paramDic:nil blockObject:^(NSDictionary *dict) {
        DMLog(@"1058----%@",dict);
        DMLog(@"error---%@",dict[@"errorMsg"]);
        if ([dict[@"errorCode"] intValue]==0) {
            [activityView stopAnimate];
            for (NSDictionary * newDic in dict[@"dataList"]) {
                
                [_withdrawArr addObject:newDic[@"name"]];
                [_contentArr addObject:newDic[@"content"]];
                //
                for (int i=0; i<_withdrawArr.count; i++) {
                    if ([_withdrawArr[i] isEqualToString:@"REGISTER_INFO"]) {
                        _withdrawStr=_contentArr[i];
                    }
//                    if ([_withdrawArr[i] isEqualToString:@"WITHDRAW_RATE"]) {
//                        _elseWithStr=_contentArr[i];
//                    }
                }
                
                
            }
            
            WebViewController *advertringVC=[[WebViewController alloc]init];
            advertringVC.hidesBottomBarWhenPushed=YES;
            //            advertringVC.adModel=model;
            //            advertringVC.add=0;
            advertringVC.content=_withdrawStr;
            [self.navigationController pushViewController:advertringVC animated:YES];
        }
        else
        {
            [activityView stopAnimate];
            [UIAlertView alertWithTitle:@"温馨提示" message:dict[@"errorMsg"] buttonTitle:nil];
        }
        //        DMLog(@"----%@,%@,%@",_deliveryFeeArr,_startPriceArr,_deliveryFee);

    }];

}
- (IBAction)lookPwdBtn:(id)sender {
    
    _lookBtn.selected=!_lookBtn.selected;
    if (_lookBtn.isSelected) {
        
        [_lookBtn setImage:[UIImage imageNamed:@"可见_07"] forState:0];
        _pwdTF.secureTextEntry=NO;
    }
    else{
        
        [_lookBtn setImage:[UIImage imageNamed:@"注册1_03"] forState:0];
        _pwdTF.secureTextEntry=YES;
    }
}
@end
