
//
//  BankCardViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/20.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "BankCardViewController.h"
#import "DepositViewController.h"
#import "WithdrawMoneyViewController.h"
#import "ChooseBankViewController.h"
@interface BankCardViewController ()<SCXCreatePopViewDelegate,ButtonClick,UITextFieldDelegate>
{
    NSString * _bankName;
    NSTimer * _timer;
//    UIButton * _checkBtn;
    int i;
    
    NSString * _bankAddr;//开户行所在城市
    NSString * _bankNo;//银行卡号
    NSString * _bankUsername;//持卡人姓名
    NSString * _idcardno;//身份证号
    
//    NSString * _captcha;
    NSString * _phone;
    
    int        _type;
}
@property(nonatomic,retain) NSString * captcha;

@end

@implementation BankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    NSDictionary * param=@{@"memberId":USERID};
    [RequstEngine requestHttp:@"1003" paramDic:param blockObject:^(NSDictionary *dic) {
        DMLog(@"1003---%@",dic);
        _bankAddr=dic[@"member"][@"bankAddr"];
        _bankNo=dic[@"member"][@"bankNo"];
        if (_bankNo.length==0) {
            _bankName=@"请选择";
        }
        else
        {
            _bankName=dic[@"member"][@"bankName"];
        }
        
        _bankUsername=dic[@"member"][@"bankUsername"];
        self.phoneNumber=dic[@"member"][@"phone"];
        [self loadUI];
    }];
    self.title=@"添加银行卡";
    self.view.backgroundColor=BGMAINCOLOR;
    
    // 加载UI
    
    i =120;
    // Do any additional setup after loading the view.
}

#pragma mark - loadUI
-(void)loadUI
{
    UIView * coverView=[[[UIView alloc]initWithFrame:CGRectMake(0, H(10)+64, WIDTH, H(160))] autorelease];
    coverView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:coverView];
    
    UILabel *bankLabel=[[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(10), W(65), H(20))] autorelease];
    bankLabel.text=@"开户银行";
    bankLabel.font=[UIFont systemFontOfSize:14];
    bankLabel.textColor=MAINCHARACTERCOLOR;
    [coverView addSubview:bankLabel];
    
    _bankNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(bankLabel)+W(52), H(10), W(160), H(20))];
//    _bankNameLabel.backgroundColor=[UIColor cyanColor];
    _bankNameLabel.text=_bankName;
    _bankNameLabel.textAlignment=NSTextAlignmentRight;
    _bankNameLabel.textColor=RGBACOLOR(80, 80, 80, 1);
    _bankNameLabel.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:_bankNameLabel];
    
    _addBtn=[UIButton buttonWithType:0];
    _addBtn.frame=CGRectMake(kRight(_bankNameLabel)+W(5), H(15), W(10), H(10));
//    addBtn.backgroundColor=[UIColor redColor];
    [_addBtn setImage:[UIImage imageNamed:@"添加_03"] forState:0];
    [coverView addSubview:_addBtn];
    
    _button=[UIButton buttonWithType:0];
    _button.frame=CGRectMake(kRight(bankLabel)+W(52), H(10), W(180), H(20));
//    button.backgroundColor=[UIColor cyanColor];
    [_button addTarget:self action:@selector(enlarge) forControlEvents:1<<6];
    [coverView addSubview:_button];
    
    UILabel * cityLabel=[[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(bankLabel)+H(10)*2, W(16*8), H(20))] autorelease];
    cityLabel.text=@"开户银行所在城市";
    cityLabel.textColor=MAINCHARACTERCOLOR;
    cityLabel.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:cityLabel];
    
    _cityTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(cityLabel), kDown(bankLabel)+H(10), WIDTH-W(12)-W(16*8)-W(30), H(40))];
    _cityTF.returnKeyType=UIReturnKeyDone;
    if (_bankAddr.length==0) {
        _cityTF.placeholder=@"请输入所在城市";
    }
    else
    {
        _cityTF.text=_bankAddr;
    }
    
    _cityTF.delegate=self;
    _cityTF.textAlignment=NSTextAlignmentRight;
    _cityTF.textColor=RGBACOLOR(84, 82, 82, 1);
    _cityTF.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:_cityTF];
    
    UILabel * bankCardNumberLabel=[[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(cityLabel)+H(10)*2, W(16*8), H(20))] autorelease];
    bankCardNumberLabel.text=@"请输入银行卡号";
    bankCardNumberLabel.textColor=MAINCHARACTERCOLOR;
    bankCardNumberLabel.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:bankCardNumberLabel];
    
    _cardNumberTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(bankCardNumberLabel), kDown(cityLabel)+H(10), WIDTH-W(12)-W(16*8)-W(30), H(40))];
    _cardNumberTF.returnKeyType=UIReturnKeyDone;
    if (_bankNo.length==0) {
        _cardNumberTF.placeholder=@"请输入银行卡号";
    }else
    {
        _cardNumberTF.text=_bankNo;
    }
    
    _cardNumberTF.delegate=self;
    _cardNumberTF.textAlignment=NSTextAlignmentRight;
    _cardNumberTF.textColor=RGBACOLOR(84, 82, 82, 1);
    _cardNumberTF.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:_cardNumberTF];
    
    UILabel * nameLabel=[[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(bankCardNumberLabel)+H(10)*2, W(16*8), H(20))] autorelease];
    nameLabel.text=@"收款人姓名";
    nameLabel.textColor=MAINCHARACTERCOLOR;
    nameLabel.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:nameLabel];
    
    _nameTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(nameLabel), kDown(bankCardNumberLabel)+H(10), WIDTH-W(12)-W(16*8)-W(30), H(40))];
    _nameTF.returnKeyType=UIReturnKeyDone;
    if (_bankUsername.length==0) {
        _nameTF.placeholder=@"请输入收款人姓名";
    }
    else
    {
        _nameTF.text=_bankUsername;
    }
    
    _nameTF.delegate=self;
    _nameTF.textAlignment=NSTextAlignmentRight;
    _nameTF.textColor=RGBACOLOR(84, 82, 82, 1);
    _nameTF.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:_nameTF];
    
    for (int j=0; j<3; j++) {
        UILabel * lineLabel=[[[UILabel alloc]initWithFrame:CGRectMake(0, H(39)*j+H(40), WIDTH, H(1))] autorelease];
        lineLabel.backgroundColor=BGMAINCOLOR;
        [coverView addSubview:lineLabel];
    }
    
    UIView * backView=[[[UIView alloc]initWithFrame:CGRectMake(0, kDown(coverView)+H(10), WIDTH, H(80))] autorelease];
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    
    UILabel * phoneLabel=[[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(10), W(16*8), H(20))] autorelease];
    phoneLabel.text=@"您已绑定的手机号";
    phoneLabel.textColor=MAINCHARACTERCOLOR;
    phoneLabel.font=[UIFont systemFontOfSize:14];
    [backView addSubview:phoneLabel];
    
    _phoneTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(phoneLabel), 0, WIDTH-W(12)-W(16*8)-W(30), H(40))];
    NSString *phoneTwo=[_phoneNumber substringFromIndex:7];
    NSString *phoneOne=[_phoneNumber substringToIndex:3];
    DMLog(@"%@--%@",phoneOne,phoneTwo);
    _phoneTF.text=[NSString stringWithFormat:@"%@****%@",phoneOne,phoneTwo];
//    _phoneTF.text=_phoneNumber;
    _phoneTF.enabled=NO;
    _phoneTF.returnKeyType=UIReturnKeyDone;
    _phoneTF.delegate=self;
    _phoneTF.textAlignment=NSTextAlignmentRight;
    _phoneTF.textColor=RGBACOLOR(84, 82, 82, 1);
    _phoneTF.font=[UIFont systemFontOfSize:14];
    [backView addSubview:_phoneTF];
    
    UILabel * checkLabel=[[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(_phoneTF)+H(10), W(16*4), H(20))] autorelease];
    checkLabel.text=@"验证码";
    checkLabel.textColor=MAINCHARACTERCOLOR;
    checkLabel.font=[UIFont systemFontOfSize:14];
    [backView addSubview:checkLabel];
    
    _checkTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(checkLabel), kDown(_phoneTF), WIDTH-W(12)-W(16*8)-W(50), H(40))];
    _checkTF.returnKeyType=UIReturnKeyDone;
    _checkTF.placeholder=@"请输入验证码";
    _checkTF.delegate=self;
    _checkTF.textAlignment=NSTextAlignmentRight;
    _checkTF.textColor=RGBACOLOR(84, 82, 82, 1);
    _checkTF.font=[UIFont systemFontOfSize:14];
    [backView addSubview:_checkTF];
    
    self.checkBtn=[UIButton buttonWithType:0];
    self.checkBtn.layer.masksToBounds=YES;
    self.checkBtn.layer.cornerRadius=3;
    self.checkBtn.frame=CGRectMake(kRight(_checkTF)+W(20), kDown(_phoneTF)+H(5), W(65), H(30));
    self.checkBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    [self.checkBtn setTitle:@"免费获取" forState:0];
    [self.checkBtn setTitleColor:[UIColor whiteColor] forState:0];
    self.checkBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.checkBtn addTarget:self action:@selector(checkNumber) forControlEvents:1<<6];
    [backView addSubview:self.checkBtn];
    
    UILabel * lineLabel=[[[UILabel alloc]initWithFrame:CGRectMake(0, H(39), WIDTH, H(1))] autorelease];
    lineLabel.backgroundColor=BGMAINCOLOR;
    [backView addSubview:lineLabel];
    
    
    _getSpeechCheckLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(backView)+10, 228, 20)];
    _getSpeechCheckLabel.font=[UIFont systemFontOfSize:14];
    //    _getSpeechCheckLabel.text=@"验证码收不到，试试获取语音验证码";
    //    _getSpeechCheckLabel.textColor=MAINCOLOR;
    //    _getSpeechCheckLabel.backgroundColor=[UIColor redColor];
    [self.view addSubview:_getSpeechCheckLabel];
    
    _getSpeechCheckBtn=[UIButton buttonWithType:0];
    _getSpeechCheckBtn.frame=CGRectMake(W(12), kDown(backView)+10, 228, 20);
    [_getSpeechCheckBtn setTitle:@"验证码收不到，试试获取语音验证码" forState:0];
    _getSpeechCheckBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    //    _getSpeechCheckBtn.titleLabel.textAlignment=NSTextAlignmentLeft;
    [_getSpeechCheckBtn setTitleColor:MAINCOLOR forState:0];
    [_getSpeechCheckBtn addTarget:self action:@selector(getSpeechCheckNumber) forControlEvents:1<<6];
    [self.view addSubview:_getSpeechCheckBtn];

    
    _saveBtn=[UIButton buttonWithType:0];
    _saveBtn.layer.masksToBounds=YES;
    _saveBtn.layer.cornerRadius=3;
    _saveBtn.frame=CGRectMake(W(20), kDown(backView)+H(80), WIDTH-W(20)*2, 40);
    _saveBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    [_saveBtn addTarget:self action:@selector(jump) forControlEvents:1<<6];
    [_saveBtn setTitle:@"保存" forState:0];
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:_saveBtn];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark--自定义下拉菜单代理方法,点击下拉菜单某一行时候对应的响应时间，点击完成后试图要消失，用一个block通知；
-(void)tableViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath andPopType:(popType)popViewType{

    _bankName=_titleNameArray[indexPath.row];
    _bankNameLabel.text=_bankName;
    DMLog(@"--%@",_bankName);
    _menu.delegate=nil;
    _menu.tableViewDelegate=nil;
    [_menu dismissWithCompletion:nil];//点击完成后视图消失;
}

#pragma mark - 按钮绑定的方法
-(void)enlarge
{
    
    ChooseBankViewController * chooseVC=[[ChooseBankViewController alloc]init];
    [chooseVC setBlock:^(NSString * bankName) {
        _bankName=bankName;
        _bankNameLabel.text=_bankName;
    }];
    [self.navigationController pushViewController:chooseVC animated:YES];
    
}

-(void)dealloc
{
    [super dealloc];
    _menu.delegate=nil;
    _menu.tableViewDelegate=nil;
    [_bankNameLabel release];
    [_cityTF release];
    [_cardNumberTF release];
    [_nameTF release];
    [_phoneTF release];
    [_checkTF release];
    [_addBtn release];
    [_button release];
    [_checkBtn release];
    [_saveBtn release];
//    [_captcha release];
//    _phoneNumber=nil;
//    [_phoneNumber release];
}

-(void)getSpeechCheckNumber
{
    DMLog(@"获取语音验证码");
    _type=1;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [_timer fire];
    
    [UIAlertView alertWithTitle:@"温馨提示" message:@"验证码已发出，请注意接听手机来电" buttonTitle:nil];
    
    NSDictionary *param=@{@"phone":self.phoneNumber,@"actionType":@"1",@"type":@"1",@"type":@"1"};
    [RequstEngine requestHttp:@"1046" paramDic:param blockObject:^(NSDictionary *dic) {
        
        DMLog(@"1046-----%@",dic);
        DMLog(@"error----%@",dic[@"errorMsg"]);
        if ([dic[@"errorCode"] intValue]==0) {
            
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

-(void)checkNumber
{
    DMLog(@"--");
    _type=0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [_timer fire];
    NSDictionary * param=@{@"phone":self.phoneNumber,@"actionType":@"1",@"type":@"0"};
    [RequstEngine requestHttp:@"1046" paramDic:param blockObject:^(NSDictionary *dic) {
        DMLog(@"1046----%@",dic);
        DMLog(@"error----%@",dic[@"errorMsg"]);
        if ([dic[@"errorCode"] intValue]==00000) {
            self.captcha=dic[@"captcha"];
            
            _checkBtn.enabled=NO;
            _checkBtn.backgroundColor=BGMAINCOLOR;
            [_checkBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
            [_getSpeechCheckBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
            _getSpeechCheckBtn.enabled=NO;
//            [self.captcha retain];
//            SHOWALERTVIEW(@"您的验证码为%@",_captcha)
//            NSString * str=[NSString stringWithFormat:@"您的验证码为\n%@",_captcha];
////            [str retain];
//            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:str delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//            [alert show];
            [UIAlertView alertWithTitle:@"温馨提示" message:@"您的验证码已发出，请查看短信" buttonTitle:nil];
        }
        else
        {
            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
        }
    }];

}


// 定时器方法
- (void)onTimer
{
    
    if (_type==0) {
        // 手机验证码
        [_checkBtn setTitle:[NSString stringWithFormat:@"%ds",i] forState:UIControlStateNormal];
//        _checkBtn.userInteractionEnabled=NO;
        
        if (i == 0)
        {
            [_timer invalidate];
            [_checkBtn setTitle:@"免费获取" forState:0];
            [_checkBtn setTitleColor:[UIColor whiteColor] forState:0];
            _checkBtn.backgroundColor=MAINCOLOR;
            [_getSpeechCheckBtn setTitleColor:MAINCOLOR forState:0];
            _getSpeechCheckBtn.enabled=YES;
            _checkBtn.enabled=YES;
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
            [_checkBtn setTitle:@"免费获取" forState:0];
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
//    DepositViewController * depositVC=[[DepositViewController alloc]init];
//    [self.navigationController pushViewController:depositVC animated:YES];
    DMLog(@"银行卡绑定");
    if ([_bankName isEqualToString:@"请选择"]) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请选择银行卡类型" buttonTitle:nil];
        
    }
    else if (_cardNumberTF.text.length==0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入银行卡号码" buttonTitle:nil];
    }
    else if (_cityTF.text.length==0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入开户行所在地" buttonTitle:nil];
    }
    else if (_nameTF.text.length==0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入收款人姓名" buttonTitle:nil];
    }
    else if (_checkTF.text.length==0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入验证码" buttonTitle:nil];
    }
    else
    {
        DMLog(@"---%@,%@",_phoneNumber,_captcha);
        NSDictionary * dict=@{@"phone":self.phoneNumber,@"captcha":_checkTF.text};
        [RequstEngine requestHttp:@"1047" paramDic:dict blockObject:^(NSDictionary *dic) {
            DMLog(@"1047----%@",dic);
            DMLog(@"error-----%@",dic[@"errorMsg"]);
            if ([dic[@"errorCode"]intValue]==00000) {
                NSDictionary * param=@{@"bankName":_bankName,@"bankNo":_cardNumberTF.text,@"bankUsername":_nameTF.text,@"bankAddr":_cityTF.text,@"captcha":_checkTF.text};
                DMLog(@"%@,%@,%@,%@,%@",_bankName,_cardNumberTF.text,_nameTF.text,_cityTF.text,_checkTF.text);
                [RequstEngine requestHttp:@"1032" paramDic:param blockObject:^(NSDictionary *dic) {
                    DMLog(@"***%@",dic);
                    if ([dic[@"errorCode"] intValue]==00000) {
//                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
                        NSDictionary * dic=@{@"bankName":_bankName,@"bankNO":_cardNumberTF.text,@"name":_nameTF.text};
                        _block(dic);
                        [self.navigationController popViewControllerAnimated:YES];
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
