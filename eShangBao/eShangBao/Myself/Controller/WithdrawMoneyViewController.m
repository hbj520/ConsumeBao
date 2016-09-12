//
//  WithdrawMoneyViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/20.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "WithdrawMoneyViewController.h"
#import "BankCardViewController.h"
#import "BoundViewController.h"
#import "BankCardViewController.h"
@interface WithdrawMoneyViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UITextField * _bankTF;
    UITextField * _nameTF;
    UITextField * _IDTF;
    UITextField * _moneyTF;
    
    UIView * coverView;
    NSString * _bankName;//银行名称
    NSString * _bankUsername;//持卡人姓名
    NSString * _idcardno;//身份证号
    NSString * _memberType;//用户类型
    NSString * _isShop;//是否是联盟商家
    NSString * _partnerAgencyPayStatus;//是否付款
    TBActivityView * activityView;
    NSMutableArray * _withdrawArr;
    NSMutableArray * _contentArr;
    NSString       * _withdrawStr;
    
    NSString       * _elseWithStr;
//    NSString * _bankUsername;//持卡人姓名

}

@end

@implementation WithdrawMoneyViewController
//-(void)viewWillAppear:(BOOL)animated
//{
//    
//    [super viewWillAppear:YES];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title=@"提现";
    self.view.backgroundColor=BGMAINCOLOR;
    
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    
    [activityView startAnimate];
    _withdrawArr=[NSMutableArray arrayWithCapacity:0];
    _contentArr=[NSMutableArray arrayWithCapacity:0];
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
                    if ([_withdrawArr[i] isEqualToString:@"SHOPWITHDRAW_RATE"]) {
                        _withdrawStr=_contentArr[i];
                    }
                    if ([_withdrawArr[i] isEqualToString:@"WITHDRAW_RATE"]) {
                        _elseWithStr=_contentArr[i];
                    }
                }
            }
            
            NSDictionary * param=@{@"memberId":USERID};
            [RequstEngine requestHttp:@"1003" paramDic:param blockObject:^(NSDictionary *dic) {
                DMLog(@"1003--%@",dic);
                [activityView stopAnimate];
                _bankNo=dic[@"member"][@"bankNo"];
                _bankName=dic[@"member"][@"bankName"];
                _bankUsername=dic[@"member"][@"bankUsername"];
                _idcardno=dic[@"member"][@"idcardno"];
                _memberType=dic[@"member"][@"type"];
                _isShop=dic[@"member"][@"isShop"];
                _partnerAgencyPayStatus=dic[@"member"][@"partnerAgencyPayStatus"];
                if (_bankNo.length!=0) {
                    [self loadUI];
                    [self loadBank];
                }
                else
                {
                    [self loadUI];
                }
            }];

            
//            [self loadUI];
//            [self loadBank];
        }
        else
        {
            [activityView stopAnimate];
        }
//        DMLog(@"----%@,%@,%@",_deliveryFeeArr,_startPriceArr,_deliveryFee);
        
    }];
    
    if (_returnBate==nil) {
        NSDictionary * param=@{@"shopId":USERID};
        [RequstEngine requestHttp:@"1012" paramDic:param blockObject:^(NSDictionary *dic) {
            DMLog(@"1012---%@",dic);
            DMLog(@"error----%@",dic[@"errorMsg"]);
            if ([dic[@"errorCode"] intValue]==0) {
                
                
                _returnBate=dic[@"shop"][@"returnGoldRate"];

                     }
            

        }];
        
        return;

    }

    // 加载UI
//    [self loadUI];
    // Do any additional setup after loading the view.
}

#pragma mark - loadUI
-(void)loadUI
{
    coverView=[[UIView alloc]initWithFrame:CGRectMake(0, H(5)+64, WIDTH, H(40))];
    coverView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:coverView];
    
    UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(15), H(10), W(150), H(20))];
    if (_type==0) {
        titleLabel.text=@"可提现金额:";
    }
    else
    {
        titleLabel.text=@"可用的通宝币数量:";
    }

    
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.textColor=RGBACOLOR(80, 80, 80, 1);
    [coverView addSubview:titleLabel];
    
    UILabel * accountLabel=[[UILabel alloc]init];
    accountLabel.textColor=RGBACOLOR(80, 80, 80, 1);
    if (_type==0) {
        accountLabel.text=[NSString stringWithFormat:@"￥%.2f",[_remain floatValue]];
    }
    else
    {
        accountLabel.text=[NSString stringWithFormat:@"%.2f",[_coinCount floatValue]];
    }
    
    accountLabel.font=[UIFont boldSystemFontOfSize:14];
    CGSize size =  [self sizeWithString:accountLabel.text font:accountLabel.font];
    accountLabel.frame = CGRectMake(kRight(titleLabel)+W(10), H(12), size.width, size.height);
    [coverView addSubview:accountLabel];
    
    UILabel * unitLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(accountLabel)+W(3), H(9), W(50), H(20))];
    unitLabel.textColor=RGBACOLOR(80, 80, 80, 1);
    if (_type==0) {
        unitLabel.hidden=YES;
    }
    else
    {
        unitLabel.text=@"( 个 )";
    }
    
    unitLabel.font=[UIFont systemFontOfSize:12];
    [coverView addSubview:unitLabel];
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(W(15), kDown(coverView)+H(10), W(65), H(20))];
    label.textColor=RGBACOLOR(128, 128, 128, 1);
    label.font=[UIFont systemFontOfSize:14];
    label.text=@"收款账户";
    [self.view addSubview:label];
    
    UILabel * addLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(label)+H(10), WIDTH, H(40))];
    addLabel.backgroundColor=[UIColor whiteColor];
    addLabel.text=@"+ 请添加银行卡";
    addLabel.textAlignment=NSTextAlignmentCenter;
    addLabel.textColor=RGBACOLOR(80, 80, 80, 1);
    addLabel.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:addLabel];
    
    UIButton * addButton=[UIButton buttonWithType:0];
    addButton.frame=CGRectMake(0, kDown(label)+H(10), WIDTH, H(40));
    addButton.titleLabel.font=[UIFont systemFontOfSize:14*KRatioH];
    [addButton addTarget:self action:@selector(addBankCard) forControlEvents:1<<6];
//    addButton.backgroundColor=[UIColor cyanColor];
    [self.view addSubview:addButton];
    
    
    UIButton * applyBtn=[UIButton buttonWithType:0];
    applyBtn.layer.masksToBounds=YES;
    applyBtn.layer.cornerRadius=3;
    applyBtn.frame=CGRectMake(W(20), kDown(addButton)+H(240), WIDTH-W(20)*2, H(40));
    applyBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    [applyBtn addTarget:self action:@selector(jump) forControlEvents:1<<6];
    [applyBtn setTitle:@"申请提现" forState:0];
    [applyBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:applyBtn];

}

-(void)loadBank
{
    UIButton * alterBtn=[UIButton buttonWithType:0];
    alterBtn.frame=CGRectMake(W(270), kDown(coverView)+H(10), W(40), H(20));
    [alterBtn setTitle:@"修改" forState:0];
    [alterBtn setTitleColor:RGBACOLOR(80, 80, 80, 1) forState:0];
    alterBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    alterBtn.backgroundColor=[UIColor whiteColor];
    [alterBtn addTarget:self action:@selector(alterMsg) forControlEvents:1<<6];
    [self.view addSubview:alterBtn];
    
    UIView * backView=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(alterBtn)+H(10), WIDTH, H(40)*3)];
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    
    UILabel * bankLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(10), W(100), H(20))];
    bankLabel.text=@"开户银行:";
    bankLabel.textColor=MAINCHARACTERCOLOR;
    bankLabel.font=[UIFont systemFontOfSize:14];
    [backView addSubview:bankLabel];
    
    _bankTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(bankLabel), 0, WIDTH-W(12)-W(100), H(40))];
    _bankTF.text=_bankName;
    _bankTF.delegate=self;
    _bankTF.enabled=NO;
    _bankTF.textColor=RGBACOLOR(80, 80, 80, 1);
    _bankTF.font=[UIFont systemFontOfSize:14];
    [backView addSubview:_bankTF];
    
    UILabel * nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(_bankTF)+H(10), W(100), H(20))];
    nameLabel.text=@"持卡人姓名:";
    nameLabel.textColor=MAINCHARACTERCOLOR;
    nameLabel.font=[UIFont systemFontOfSize:14];
    [backView addSubview:nameLabel];
    
    _nameTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(nameLabel), kDown(_bankTF), WIDTH-W(12)-W(100), H(40))];
    _nameTF.text=_bankUsername;
    _nameTF.delegate=self;
    _nameTF.enabled=NO;
    _nameTF.textColor=RGBACOLOR(80, 80, 80, 1);
    _nameTF.font=[UIFont systemFontOfSize:14];
    [backView addSubview:_nameTF];
    
    UILabel * IDLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(_nameTF)+H(10), W(100), H(20))];
    IDLabel.text=@"银行卡号:";
    IDLabel.textColor=MAINCHARACTERCOLOR;
    IDLabel.font=[UIFont systemFontOfSize:14];
    [backView addSubview:IDLabel];
    
    _IDTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(IDLabel), kDown(_nameTF), WIDTH-W(12)-W(100), H(40))];
    _IDTF.text=_bankNo;
    _IDTF.delegate=self;
    _IDTF.enabled=NO;
    _IDTF.textColor=RGBACOLOR(80, 80, 80, 1);
    _IDTF.font=[UIFont systemFontOfSize:14];
    [backView addSubview:_IDTF];
    
    for (int i=0; i<2; i++) {
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(39)+i*H(40), WIDTH, H(1))];
        lineLabel.backgroundColor=BGMAINCOLOR;
        [backView addSubview:lineLabel];
    }
    
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(backView)+H(10), WIDTH, H(40))];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel * moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(10), W(100), H(20))];
    moneyLabel.text=@"提现金额:";
    moneyLabel.textColor=MAINCHARACTERCOLOR;
    moneyLabel.font=[UIFont systemFontOfSize:14];
    [view addSubview:moneyLabel];
    
    _moneyTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(moneyLabel), 0, WIDTH-W(12)-W(100), H(40))];
//    _moneyTF.text=@"300";
    _moneyTF.placeholder=@"请输入提现金额";
    _moneyTF.font=[UIFont systemFontOfSize:14];
    _moneyTF.delegate=self;
    _moneyTF.textColor=RGBACOLOR(80, 80, 80, 1);
//    _moneyTF.font=[UIFont systemFontOfSize:14*KRatioH];
    _moneyTF.keyboardType=UIKeyboardTypeNumberPad;
    [view addSubview:_moneyTF];

   
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(view)+H(10), WIDTH-W(12)*2, H(50))];
    label.numberOfLines=0;
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=GRAYCOLOR;
    [self.view addSubview:label];
    
    //提现收入
    if (_type==0) {
//        if ([_isShop intValue]==0) {
        
            label.text=[NSString stringWithFormat:@"提现将从此次提现金额中扣除%.f%@手续费",[_withdrawStr floatValue]*100,@"%"];
//        }
//        else
//        {
//            label.text=[NSString stringWithFormat:@"提现将从此次提现金额中扣除%.f%@手续费",[_withdrawStr floatValue]*100,@"%"];
//        }
        
    }
    else
    {
        // 提现通宝币
        if (([_memberType intValue]==2&&[_partnerAgencyPayStatus intValue]==1)||[_isShop intValue]==1) {
//            label.hidden=YES;
            label.text=[NSString stringWithFormat:@"提现将从此次提现金额中扣除%.f%@手续费",[_withdrawStr floatValue]*100,@"%"];
            
        }
        else
        {
//            label.hidden=NO;
            label.text=[NSString stringWithFormat:@"提现将从此次提现金额中扣除%.f%@手续费，请确保提现金额为500或500的整数倍",[_elseWithStr floatValue]*100,@"%"];
        }
    }
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
            if (_bankNo.length!=0) {
                if (_type==0) {
                    NSDictionary * param=@{@"money":_moneyTF.text};
                    [RequstEngine requestHttp:@"1077" paramDic:param blockObject:^(NSDictionary *dic) {
                        DMLog(@"1077--%@",dic);
                        DMLog(@"error---%@",dic[@"errorMsg"]);
                        if ([dic[@"errorCode"] intValue]==00000) {
                            [UIAlertView alertWithTitle:@"温馨提示" message:@"提现成功" buttonTitle:nil];
                            [self.navigationController popViewControllerAnimated:YES];
                        }else
                        {
                            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                        }
                    }];
                    
                }
                else
                {
                    if ([_memberType intValue]==2) {
                        NSDictionary * param=@{@"goldNum":_moneyTF.text};
                        [RequstEngine requestHttp:@"1033" paramDic:param blockObject:^(NSDictionary *dic) {
                            DMLog(@"1033--%@",dic);
                            DMLog(@"error---%@",dic[@"errorMsg"]);
                            if ([dic[@"errorCode"] intValue]==00000) {
                                [UIAlertView alertWithTitle:@"温馨提示" message:@"提现成功" buttonTitle:nil];
                                [self.navigationController popViewControllerAnimated:YES];
                            }else
                            {
                                [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                            }
                        }];
                        
                    }
                    else
                    {
                        BOOL isInt=[self judgeStr:@"500" with:_moneyTF.text];
                        if (isInt==YES) {
                            NSDictionary * param=@{@"goldNum":_moneyTF.text};
                            [RequstEngine requestHttp:@"1033" paramDic:param blockObject:^(NSDictionary *dic) {
                                DMLog(@"1033--%@",dic);
                                DMLog(@"error---%@",dic[@"errorMsg"]);
                                if ([dic[@"errorCode"] intValue]==00000) {
                                    [UIAlertView alertWithTitle:@"温馨提示" message:@"提现成功" buttonTitle:nil];
                                    [self.navigationController popViewControllerAnimated:YES];
                                }else
                                {
                                    [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                                }
                            }];
                            
                        }
                        else
                        {
                            [UIAlertView alertWithTitle:@"温馨提示" message:@"您输入的金额有误，请按提示输入" buttonTitle:nil];
                        }
                    }
                    
                }
                
            }

        }
            
            break;
        default:
            break;
    }
}
#pragma mark - 按钮绑定的方法
-(void)addBankCard
{
    DMLog(@"添加银行卡");
    
    BankCardViewController * bandCardVC=[[BankCardViewController alloc]init];
    [bandCardVC setBlock:^(NSDictionary *dict) {
        _bankNo=dict[@"bankNO"];
        _bankName=dict[@"bankName"];
        _bankUsername=dict[@"name"];
        [self loadBank];
    }];
    [self.navigationController pushViewController:bandCardVC animated:YES];
}

-(void)jump
{
    if (_bankNo.length==0) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请先添加银行卡" buttonTitle:nil];
    }
    else if (_moneyTF.text.length==0) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入提现金额" buttonTitle:nil];
    }
    else
    {
        if (_type==0) {
//            if ([_isShop intValue]==0) {
            
                NSString * str=[NSString stringWithFormat:@"尊敬的客户您好，提现%@元，需要扣除%.2f元手续费，实际到账%.2f元",_moneyTF.text,[_moneyTF.text floatValue]*[_withdrawStr floatValue],[_moneyTF.text floatValue]-[_moneyTF.text floatValue]*[_withdrawStr floatValue]];
                UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                alertView.delegate=self;
                [alertView show];
//
//            }
//            else
//            {
//
//                
//                NSString * str=[NSString stringWithFormat:@"尊敬的客户您好，提现%@元，需要扣除%.2f元费用，实际到账%.2f元",_moneyTF.text,[_moneyTF.text floatValue]*([_returnBate floatValue]+[_withdrawStr floatValue]),[_moneyTF.text floatValue]-[_moneyTF.text floatValue]*([_returnBate floatValue]+[_withdrawStr floatValue])];
//                UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//                alertView.delegate=self;
//                [alertView show];
//            }
            
        }
        else
        {
            if (([_memberType intValue]==2&&[_partnerAgencyPayStatus intValue]==1)||[_isShop intValue]==1) {
                NSString * str=[NSString stringWithFormat:@"尊敬的客户您好，提现%@元，需要扣除%.2f元手续费，实际到账%.2f元",_moneyTF.text,[_moneyTF.text floatValue]*[_withdrawStr floatValue],[_moneyTF.text floatValue]-[_moneyTF.text floatValue]*[_withdrawStr floatValue]];
                UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                alertView.delegate=self;
                [alertView show];
            }
            else
            {
                NSString * str=[NSString stringWithFormat:@"尊敬的客户您好，提现%@元，需要扣除%.2f元手续费，实际到账%.2f元",_moneyTF.text,[_moneyTF.text floatValue]*[_elseWithStr floatValue],[_moneyTF.text floatValue]-[_moneyTF.text floatValue]*[_elseWithStr floatValue]];
                UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                alertView.delegate=self;
                [alertView show];
            }
           
        }
       
        
    }
}

-(BOOL)judgeStr:(NSString *)str1 with:(NSString *)str2

{
    
    int a=[str1 intValue];
    
    double s1=[str2 doubleValue];
    
    int s2=[str2 intValue];
    
    
    
    if (s1/a-s2/a>0) {
        
        return NO;
        
    }
    
    return YES;
    
}
-(void)alterMsg
{
    BankCardViewController * bandCardVC=[[BankCardViewController alloc]init];
    [self.navigationController pushViewController:bandCardVC animated:YES];
}
#pragma mark - 自适应字体大小
// 定义成方法方便多个label调用 增加代码的复用性
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(320, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
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
