//
//  WantRecommendViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/18.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "WantRecommendViewController.h"
#import "BoundViewController.h"
#import "PayViewController.h"
#import "PartnerPayViewController.h"
#import "FillMsgViewController.h"
#import "CheckID.h"
@interface WantRecommendViewController ()<UITextFieldDelegate>
{
    UIButton * _shangjiaBtn;
    UIButton * _partnerBtn;
    UIButton * _tjsjBtn;
    UIButton * _payinCountBtn;
    UIButton * _payinCashBtn;
    UIView   * backView;
    UIButton * payBtn;
    int _choose; //1 合伙人 2 商家 3 推荐商家
    BOOL _payincash;
}

@end

@implementation WantRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title=@"我要推荐";
    self.view.backgroundColor=BGMAINCOLOR;
    _choose=2;
    _payincash=YES;
    
    
    // 加载UI
    [self loadUI];
    // Do any additional setup after loading the view.
}

#pragma mark - loadUI
-(void)loadUI
{
    UILabel * leibieLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(10)+64, W(64), H(20))];
    leibieLabel.text=@"推荐类型";
    leibieLabel.textColor=RGBACOLOR(76, 76, 76, 1);
    leibieLabel.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:leibieLabel];
    
    UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(leibieLabel)+H(10), WIDTH, H(40)*3)];
    coverView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:coverView];
    
    UILabel * shangjiaLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(10), W(100), H(20))];
    shangjiaLabel.text=@"联营超市";
    shangjiaLabel.textColor=MAINCHARACTERCOLOR;
    shangjiaLabel.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:shangjiaLabel];
    
    _shangjiaBtn=[UIButton buttonWithType:0];
    _shangjiaBtn.frame=CGRectMake(KScreenWidth-W(80), 0, W(80), H(40));
    [_shangjiaBtn addTarget:self action:@selector(chooseShangjia) forControlEvents:1<<6];
    [_shangjiaBtn setImage:[UIImage imageNamed:@"yx_clk"] forState:0];
    [coverView addSubview:_shangjiaBtn];
    
    UILabel * partnerLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(shangjiaLabel)+W(10)*2, W(50), H(20))];
    partnerLabel.text=@"合伙人";
    partnerLabel.textColor=MAINCHARACTERCOLOR;
    partnerLabel.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:partnerLabel];
    
    _partnerBtn=[UIButton buttonWithType:0];
    _partnerBtn.frame=CGRectMake(KScreenWidth-W(80), kDown(shangjiaLabel)+H(8), W(80), H(40));
    [_partnerBtn addTarget:self action:@selector(choosePartner) forControlEvents:1<<6];
    [_partnerBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
    [coverView addSubview:_partnerBtn];
    
    UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(39), WIDTH, H(1))];
    lineLabel.backgroundColor=BGMAINCOLOR;
    [coverView addSubview:lineLabel];
    
    UILabel * twolineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(79), WIDTH, H(1))];
    twolineLabel.backgroundColor=BGMAINCOLOR;
    [coverView addSubview:twolineLabel];
    
    
    UILabel * tjsjLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(partnerLabel)+W(10)*2, W(100), H(20))];
    tjsjLabel.text=@"联盟商家";
    tjsjLabel.textColor=MAINCHARACTERCOLOR;
    tjsjLabel.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:tjsjLabel];
    
    _tjsjBtn=[UIButton buttonWithType:0];
    _tjsjBtn.frame=CGRectMake(KScreenWidth-W(80), kDown(partnerLabel)+H(8), W(80), H(40));
    [_tjsjBtn addTarget:self action:@selector(chooseTjsj) forControlEvents:1<<6];
    [_tjsjBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
    [coverView addSubview:_tjsjBtn];

    
    backView=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(coverView)+H(10), WIDTH, H(40)*4)];
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    
    UILabel * nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(10), W(80), H(20))];
    nameLabel.text=@"姓名:";
    nameLabel.textColor=MAINCHARACTERCOLOR;
    nameLabel.font=[UIFont systemFontOfSize:14];
    [backView addSubview:nameLabel];
    
    UILabel * lineLabel1=[[UILabel alloc]initWithFrame:CGRectMake(0, H(39), WIDTH, H(1))];
    lineLabel1.backgroundColor=BGMAINCOLOR;
    [backView addSubview:lineLabel1];
    
    _nameTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(nameLabel), 0, WIDTH-W(12)*3-W(80), H(40))];
    _nameTF.delegate=self;
    _nameTF.tag=10;
    _nameTF.placeholder=@"请输入姓名";
    _nameTF.textColor=MAINCHARACTERCOLOR;
    _nameTF.returnKeyType=UIReturnKeyDone;
    _nameTF.textAlignment=NSTextAlignmentRight;
    [_nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _nameTF.font=[UIFont systemFontOfSize:14];
    [backView addSubview:_nameTF];
    
    UILabel * phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(nameLabel)+H(10)*2, W(80), H(20))];
    phoneLabel.text=@"手机号:";
    phoneLabel.textColor=MAINCHARACTERCOLOR;
    phoneLabel.font=[UIFont systemFontOfSize:14];
    [backView addSubview:phoneLabel];
    
    UILabel * lineLabel2=[[UILabel alloc]initWithFrame:CGRectMake(0, H(39)+H(40), WIDTH, H(1))];
    lineLabel2.backgroundColor=BGMAINCOLOR;
    [backView addSubview:lineLabel2];
    
    _phoneTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(phoneLabel), kDown(nameLabel)+H(10), WIDTH-W(12)*3-W(80), H(40))];
    _phoneTF.tag=11;
    _phoneTF.returnKeyType=UIReturnKeyDone;
    [_phoneTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _phoneTF.placeholder=@"请输入手机号";
    _phoneTF.textColor=MAINCHARACTERCOLOR;
    _phoneTF.textAlignment=NSTextAlignmentRight;
    _phoneTF.delegate=self;
    _phoneTF.font=[UIFont systemFontOfSize:14];
    [backView addSubview:_phoneTF];
    
    UILabel * idLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(phoneLabel)+H(10)*2, W(80), H(20))];
    idLabel.text=@"身份证号:";
    idLabel.textColor=MAINCHARACTERCOLOR;
    idLabel.font=[UIFont systemFontOfSize:14];
    [backView addSubview:idLabel];
    
    _idTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(idLabel), kDown(phoneLabel)+H(10), WIDTH-W(12)*3-W(80), H(40))];
    _idTF.tag=12;
    [_idTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _idTF.returnKeyType=UIReturnKeyDone;
    _idTF.delegate=self;
    _idTF.textColor=MAINCHARACTERCOLOR;
    _idTF.textAlignment=NSTextAlignmentRight;
    _idTF.placeholder=@"请输入身份证号";
    _idTF.font=[UIFont systemFontOfSize:14];
    [backView addSubview:_idTF];
    
    UILabel * lineLabel3=[[UILabel alloc]initWithFrame:CGRectMake(0, H(39)+H(40)+H(40), WIDTH, H(1))];
    lineLabel3.backgroundColor=BGMAINCOLOR;
    [backView addSubview:lineLabel3];
    
    UILabel * loginLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(idLabel)+H(10)*2, W(80), H(20))];
    loginLabel.text=@"登录账号:";
    loginLabel.textColor=MAINCHARACTERCOLOR;
    loginLabel.font=[UIFont systemFontOfSize:14];
    [backView addSubview:loginLabel];
    
    _loginTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(loginLabel), kDown(idLabel)+H(10), WIDTH-W(12)*3-W(80), H(40))];
    _loginTF.tag=13;
    [_loginTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _loginTF.returnKeyType=UIReturnKeyDone;
    _loginTF.delegate=self;
    _loginTF.keyboardType=UIKeyboardTypeASCIICapable;
    _loginTF.textColor=MAINCHARACTERCOLOR;
    _loginTF.textAlignment=NSTextAlignmentRight;
    _loginTF.placeholder=@"登录账号为6-14位的数字或字母";
    _loginTF.font=[UIFont systemFontOfSize:14];
    [backView addSubview:_loginTF];
    
//    UILabel * styleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(backView)+H(5), W(80), H(20))];
//    styleLabel.text=@"支付方式:";
//    styleLabel.textColor=RGBACOLOR(76, 76, 76, 1);
//    styleLabel.font=[UIFont systemFontOfSize:14*KRatioH];
//    [self.view addSubview:styleLabel];
//    
//    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(styleLabel)+H(5), WIDTH, H(40)*2)];
//    view.backgroundColor=[UIColor whiteColor];
//    [self.view addSubview:view];
//    
//    UILabel * payinCashLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(10), W(65), H(20))];
//    payinCashLabel.text=@"线上支付";
//    payinCashLabel.textColor=MAINCHARACTERCOLOR;
//    payinCashLabel.font=[UIFont systemFontOfSize:14*KRatioH];
//    [view addSubview:payinCashLabel];
//    
//    UILabel * lineLabel3=[[UILabel alloc]initWithFrame:CGRectMake(0, H(39), WIDTH, H(1))];
//    lineLabel3.backgroundColor=BGMAINCOLOR;
//    [view addSubview:lineLabel3];
//    
//    _payinCashBtn=[UIButton buttonWithType:0];
//    _payinCashBtn.frame=CGRectMake(kRight(payinCashLabel)+W(210)-W(15), 0, W(36), H(40));
//    [_payinCashBtn addTarget:self action:@selector(choosePayinCash) forControlEvents:1<<6];
//    [_payinCashBtn setImage:[UIImage imageNamed:@"yx_clk"] forState:0];
//    [view addSubview:_payinCashBtn];
//    
//    
//    UILabel * payinMoneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(payinCashLabel)+H(10)*2, W(65), H(20))];
//    payinMoneyLabel.text=@"线下支付";
//    payinMoneyLabel.textColor=MAINCHARACTERCOLOR;
//    payinMoneyLabel.font=[UIFont systemFontOfSize:14*KRatioH];
//    [view addSubview:payinMoneyLabel];
//    
//    _payinCountBtn=[UIButton buttonWithType:0];
//    _payinCountBtn.frame=CGRectMake(kRight(payinMoneyLabel)+W(210)-W(15), kDown(payinCashLabel)+H(8), W(36), H(40));
//    [_payinCountBtn addTarget:self action:@selector(choosePayinCount) forControlEvents:1<<6];
//    [_payinCountBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
//    [view addSubview:_payinCountBtn];
    
    payBtn=[UIButton buttonWithType:0];
//    payBtn.titleLabel.textAlignment=NSTextAlignmentRight;
    payBtn.layer.cornerRadius=3;
    payBtn.layer.masksToBounds=YES;
    payBtn.frame=CGRectMake(W(20), kDown(backView)+H(60), WIDTH-W(20)*2, 40);
    payBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    [payBtn addTarget:self action:@selector(jump) forControlEvents:1<<6];
    [payBtn setTitle:@"去支付" forState:0];
    [payBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:payBtn];
    
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==10) {
        [UIView animateWithDuration:0.26 animations:^{
            self.view.frame=CGRectMake(0, -20, WIDTH, HEIGHT);
        }];
        
    }
    
    if (textField.tag==11) {
        [UIView animateWithDuration:0.26 animations:^{
            self.view.frame=CGRectMake(0, -60, WIDTH, HEIGHT);
        }];
    }
    
    if (textField.tag==12) {
        [UIView animateWithDuration:0.26 animations:^{
            self.view.frame=CGRectMake(0, -100, WIDTH, HEIGHT);
        }];
    }
    if (textField.tag==13) {
        [UIView animateWithDuration:0.26 animations:^{
            self.view.frame=CGRectMake(0, -140, WIDTH, HEIGHT);
        }];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.26 animations:^{
        self.view.frame=CGRectMake(0, 0, WIDTH, HEIGHT);
    }];
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    return YES;
//}
#pragma mark - 按钮绑定的方法
-(void)chooseShangjia
{
    _choose=2;
    [_shangjiaBtn setImage:[UIImage imageNamed:@"yx_clk"] forState:0];
    [_partnerBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
    [_tjsjBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
    [payBtn setTitle:@"去支付" forState:0];
    backView.hidden=NO;
}

-(void)choosePartner
{
    _choose=1;
    [_shangjiaBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
    [_partnerBtn setImage:[UIImage imageNamed:@"yx_clk"] forState:0];
    [_tjsjBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
    [payBtn setTitle:@"去支付" forState:0];
    backView.hidden=NO;
}

-(void)chooseTjsj
{
    _choose=3;
    [_shangjiaBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
    [_partnerBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
    [_tjsjBtn setImage:[UIImage imageNamed:@"yx_clk"] forState:0];
    [payBtn setTitle:@"去推荐" forState:0];
    backView.hidden=YES;
}

-(void)choosePayinCash
{
    _payincash=YES;
    [_payinCashBtn setImage:[UIImage imageNamed:@"yx_clk"] forState:0];
    [_payinCountBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
}

-(void)choosePayinCount
{
    _payincash=NO;
    [_payinCountBtn setImage:[UIImage imageNamed:@"yx_clk"] forState:0];
    [_payinCashBtn setImage:[UIImage imageNamed:@"yx_nor"] forState:0];
}

-(void)jump
{
    DMLog(@"去支付");
    DMLog(@"%@,%@,%@,%d",_nameTF.text,_phoneTF.text,_idTF.text,_choose);
    
    if (_choose==3) {
        
        FillMsgViewController *allianceVC=[[FillMsgViewController alloc]init];
        allianceVC.whichPage=@"10";
        allianceVC.vctype=@"1";
        [self.navigationController pushViewController:allianceVC animated:YES];
        return;
    }
    
    if ([_nyStatus intValue]!=1) {

        [UIAlertView alertWithTitle:@"温馨提示" message:@"对不起，您还不是正式的合伙人，不能进行此操作" buttonTitle:nil];
        return;
    }
    
    if (_nameTF.text.length==0) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入姓名" buttonTitle:nil];
    }
    else if (_phoneTF.text.length==0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入手机号" buttonTitle:nil];
    }
    else if (_idTF.text.length==0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入身份证号" buttonTitle:nil];
    }
    else if (_loginTF.text.length==0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入登录账号" buttonTitle:nil];
    }
    else if (_loginTF.text.length<6||_loginTF.text.length>14)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"登录名为6-14位的数字或字母" buttonTitle:nil];
    }
    else
    {
        BOOL isNumber= [CheckID verifyIDCardNumber:_idTF.text];
        if (isNumber) {
            
            BOOL isNumber=[NSString checkNumber:_loginTF.text];
            if (isNumber) {
                NSDictionary * param=@{@"checkObj":_phoneTF.text,@"type":@"1"};
                [RequstEngine requestHttp:@"1096" paramDic:param blockObject:^(NSDictionary *dic) {
                    DMLog(@"1096-----%@",dic);
                    DMLog(@"error-----%@",dic[@"errorMsg"]);
                    if ([dic[@"errorCode"] intValue]==0) {
                        NSDictionary * param=@{@"checkObj":_loginTF.text,@"type":@"0"};
                        [RequstEngine requestHttp:@"1096" paramDic:param blockObject:^(NSDictionary *dic) {
                            DMLog(@"1096-----%@",dic);
                            DMLog(@"error-----%@",dic[@"errorMsg"]);
                            if ([dic[@"errorCode"] intValue]==0) {
                                if (_choose==2) {
                                    PayViewController * payVC=[[PayViewController alloc]init];
                                    payVC.tuiName=_nameTF.text;
                                    payVC.phone=_phoneTF.text;
                                    payVC.idNumber=_idTF.text;
                                    payVC.loginName=_loginTF.text;
                                    payVC.etype=[NSString stringWithFormat:@"%d",_choose];
                                    payVC.whichPage=1;
                                    [self.navigationController pushViewController:payVC animated:YES];
                                }
                                else
                                {
                                    PartnerPayViewController * payVC=[[PartnerPayViewController alloc]init];
                                    payVC.tuiName=_nameTF.text;
                                    payVC.phone=_phoneTF.text;
                                    payVC.idNumber=_idTF.text;
                                    payVC.loginName=_loginTF.text;
                                    payVC.etype=[NSString stringWithFormat:@"%d",_choose];
                                    payVC.whichPage=1;
                                    [self.navigationController pushViewController:payVC animated:YES];
                                }
                                
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
            else
            {
                [UIAlertView alertWithTitle:@"温馨提示" message:@"登录名为6-14位的数字或字母" buttonTitle:nil];
            }
            
            
        }
        else
        {
             [UIAlertView alertWithTitle:@"温馨提示" message:@"身份证号格式不正确或不存在该身份证" buttonTitle:nil];
        }
       
    }
    
    
//    BoundViewController * boundVC=[[BoundViewController alloc]init];
//    [self.navigationController pushViewController:boundVC animated:YES];
}

#pragma mark - UITextField绑定的方法
-(void)textFieldDidChange:(UITextField * )textField
{
    if (textField==_nameTF) {
        if (textField.text.length > 10) {
            textField.text = [textField.text substringToIndex:10];
        }
    }
    else
    {
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
        }
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
