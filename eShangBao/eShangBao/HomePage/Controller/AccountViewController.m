//
//  AccountViewController.m
//  eShangBao
//
//  Created by doumee on 16/2/19.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "AccountViewController.h"
#import "SetPsdViewController.h"
@interface AccountViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    NSString * _biPwd;
}

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];

    [self loadUI];

    self.title=@"付款";
    self.view.backgroundColor=BGMAINCOLOR;
    
    // 加载UI
    
    // Do any additional setup after loading the view.
}

-(void)loadUI
{
    _headImg=[[UIImageView alloc]init];
    _headImg.bounds=CGRectMake(0, 0, W(60), H(60));
    _headImg.center=CGPointMake(WIDTH/2, H(50)+64);
//    _headImg.image=[UIImage imageNamed:@"fir_nam"];
    [_headImg setImageWithURLString:_headImgUrl placeholderImage:@"头像"];
    _headImg.layer.cornerRadius=_headImg.frame.size.width/2;
    _headImg.layer.masksToBounds=YES;
    _headImg.contentMode=2;
    [self.view addSubview:_headImg];
    
    _nickNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(_headImg)+H(5), WIDTH, H(20))];
    _nickNameLabel.text=_loginName;
    _nickNameLabel.font=[UIFont systemFontOfSize:16*KRatioH];
    _nickNameLabel.textColor=MAINCHARACTERCOLOR;
    _nickNameLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_nickNameLabel];
    
    _phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(_nickNameLabel)+H(5), WIDTH, H(20))];
    _phoneLabel.text=_phone;
    _phoneLabel.font=[UIFont systemFontOfSize:14*KRatioH];
    _phoneLabel.textColor=GRAYCOLOR;
    _phoneLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:_phoneLabel];
    
    UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(_phoneLabel)+H(25), WIDTH, H(44)*2)];
    coverView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:coverView];
    
    UILabel * coinLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(12), W(45), H(20))];
    coinLabel.text=@"通宝币";
    coinLabel.textAlignment=NSTextAlignmentLeft;
    coinLabel.font=[UIFont systemFontOfSize:14*KRatioH];
    [coverView addSubview:coinLabel];
    
    _coinTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(coinLabel)+W(10), 0, WIDTH-W(45)-W(12)-W(10), H(44))];
    _coinTF.keyboardType=UIKeyboardTypeDecimalPad;
    _coinTF.returnKeyType=UIReturnKeyDone;
    _coinTF.placeholder=@"请输入通宝币数量，小数最多两位";
    _coinTF.delegate=self;
    _coinTF.font=[UIFont systemFontOfSize:14*KRatioH];
    [coverView addSubview:_coinTF];
    
    UILabel * remarkLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(_coinTF)+H(12), W(45), H(20))];
    remarkLabel.textAlignment=NSTextAlignmentLeft;
    remarkLabel.text=@"备注";
    remarkLabel.font=[UIFont systemFontOfSize:14*KRatioH];
    [coverView addSubview:remarkLabel];
    
    _rematkTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(remarkLabel)+W(10), kDown(_coinTF), WIDTH-W(45)-W(12)-W(10), H(44))];
    _rematkTF.delegate=self;
    _rematkTF.tag=11;
    _rematkTF.returnKeyType=UIReturnKeyDone;
    _rematkTF.placeholder=@"20字以内";
    _rematkTF.font=[UIFont systemFontOfSize:14*KRatioH];
    [coverView addSubview:_rematkTF];
    
    for (int i=0; i<3; i++) {
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(0)+H(44)*i, WIDTH, H(1))];
        lineLabel.backgroundColor=BGMAINCOLOR;
        [coverView addSubview:lineLabel];
    }
    
    _surePayBtn=[UIButton buttonWithType:0];
    _surePayBtn.layer.cornerRadius=3;
    _surePayBtn.layer.masksToBounds=YES;
    _surePayBtn.backgroundColor=MAINCOLOR;
    _surePayBtn.frame=CGRectMake(W(15), kDown(coverView)+H(65), WIDTH-W(15)*2, 40);
    [_surePayBtn setTitle:@"确认付款" forState:0];
    [_surePayBtn addTarget:self action:@selector(surePayMoney) forControlEvents:1<<6];
    [_surePayBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:_surePayBtn];
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(_surePayBtn)+H(5), WIDTH, H(20))];
    label.text=@"请核对无误后付款";
    label.font=[UIFont systemFontOfSize:14*KRatioH];
    label.textColor=GRAYCOLOR;
    label.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:label];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==11) {
        [UIView animateWithDuration:0.26 animations:^{
            self.view.frame=CGRectMake(0, -50, WIDTH, HEIGHT);
        }];
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==11) {
        [UIView animateWithDuration:0.26 animations:^{
            self.view.frame=CGRectMake(0, 0, WIDTH, HEIGHT);
        }];
    }
    
}
#pragma mark - 按钮绑定的方法
-(void)surePayMoney
{
    if (_coinTF.text.length==0) {
         [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入通报币数量" buttonTitle:nil];
    }
    else
    {
        NSString *CM = @"^[0-9]+(.[0-9]{1,2})?$";
        NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
        BOOL isNum = [regextestcm evaluateWithObject:_coinTF.text];
        if (isNum) {
            
            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"请输入通宝币支付密码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
            [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
            dialog.tag=10;
            [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeASCIICapable];
            
            //设置输入框的键盘类型
            UITextField *tf = [dialog textFieldAtIndex:0];
            tf.layer.cornerRadius=3;
            tf.delegate=self;
            tf.layer.masksToBounds=YES;
            tf.secureTextEntry=YES;
            [dialog show];
          
        }
        else
        {
            [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入正确的通宝币数量，小数最多两位" buttonTitle:nil];
        }

    }
   
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     [[alertView textFieldAtIndex:buttonIndex] resignFirstResponder];
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
        {
           

            if (alertView.tag==10) {
                _biPwd=[alertView textFieldAtIndex:0].text;
                if (_biPwd.length==0) {
                    [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入通宝币支付密码" buttonTitle:nil];
                }
                else
                {
                    NSDictionary * param=@{@"inviteCode":_inviteCode,@"goldNum":_coinTF.text,@"info":_rematkTF.text,@"payPwd":_biPwd};
                    [RequstEngine requestHttp:@"1041" paramDic:param blockObject:^(NSDictionary *dic) {
                        DMLog(@"1041--%@",dic);
                        DMLog(@"error===%@",dic[@"errorMsg"]);
                        if ([dic[@"errorCode"]intValue]==00000) {
                            [UIAlertView alertWithTitle:@"温馨提示" message:@"转账已成功" buttonTitle:nil];
//                            [UIAlertView alertWithTitle:@"温馨提示" message:@"转账成功" UIViewController:self];
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }
                        else if ([dic[@"errorCode"] isEqualToString:@"00018"])
                        {
                            //                        [activityView stopAnimate];
                            [self.view endEditing:YES];
                            UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:dic[@"errorMsg"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
                            alertView.delegate=self;
                            alertView.tag=12;
                            [alertView show];
                        }
                        else
                        {
                            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                        }
                        
                    }];
                    
                }
                
            }
            else
            {
                DMLog(@"跳去设置密码页");
                [self.view endEditing:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*1), dispatch_get_current_queue(), ^{
                    
                    SetPsdViewController * setVC=[[SetPsdViewController alloc]init];
                    [self.navigationController pushViewController:setVC animated:YES];
                    //                    }];
                });
            }

        }
            break;
        default:
            break;
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
