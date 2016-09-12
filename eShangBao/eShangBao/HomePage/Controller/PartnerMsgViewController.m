//
//  PartnerMsgViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/15.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "PartnerMsgViewController.h"
#import "PartnerPayViewController.h"
#import "CheckID.h"
#import "HHRPayViewController.h"
@interface PartnerMsgViewController ()<UITextFieldDelegate>
{
    NSString * _inviteCode;//邀请码
    NSString * _idCardNo;//身份证号
    NSString * _phone;//手机号
    NSString * _name;//名字
}

@end

@implementation PartnerMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title=@"填写合伙人信息";
    self.view.backgroundColor=RGBACOLOR(249, 249, 249, 1);
    
    NSDictionary * param=@{@"memberId":USERID};
    [RequstEngine requestHttp:@"1003" paramDic:param blockObject:^(NSDictionary *dic) {
        DMLog(@"1003---%@",dic);
        if ([dic[@"errorCode"] intValue]==00000) {
            _inviteCode=dic[@"member"][@"lastInviteCode"];
            _idCardNo=dic[@"member"][@"idcardno"];
            _phone=dic[@"member"][@"phone"];
            _name=dic[@"member"][@"name"];
        }
        [self loadUI];
    }];
    // 加载UI
    
    // Do any additional setup after loading the view.
}

-(void)loadUI
{
    UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(0, H(10)+64, WIDTH, H(50))];
    coverView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:coverView];
    
    UILabel * inviteLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), 0, W(70), H(50))];
    inviteLabel.text=@"邀请码";
    inviteLabel.textColor=MAINCHARACTERCOLOR;
    inviteLabel.textAlignment=NSTextAlignmentLeft;
    inviteLabel.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:inviteLabel];
    
    _inviteTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(inviteLabel)+W(20), 0, WIDTH-W(70)-W(20)-W(12), H(50))];
    _inviteTF.clearButtonMode=1;
    if (_inviteCode.length>0) {
         _inviteTF.text=_inviteCode;
    }
    _inviteTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"邀请人的邀请码（选填）" attributes:@{NSForegroundColorAttributeName:GRAYCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:28/2]}];
    _inviteTF.font=[UIFont systemFontOfSize:14];
    _inviteTF.returnKeyType=UIReturnKeyDone;
    _inviteTF.delegate=self;
    [coverView addSubview:_inviteTF];
    
    UIView * backView=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(coverView)+H(10), WIDTH, H(50)*3)];
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    
    for (int i=0; i<4; i++) {
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, i*H(50), WIDTH, H(1))];
        lineLabel.backgroundColor=BGMAINCOLOR;
        [backView addSubview:lineLabel];
    }
    
    UILabel * nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), 0, W(70), H(50))];
    nameLabel.textAlignment=NSTextAlignmentLeft;
    nameLabel.text=@"姓名";
    nameLabel.textColor=MAINCHARACTERCOLOR;
    nameLabel.font=[UIFont systemFontOfSize:14];
    [backView addSubview:nameLabel];
    
    _nameTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(nameLabel)+W(20), 0, WIDTH-W(70)-W(20)-W(12), H(50))];
    _nameTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入您的姓名" attributes:@{NSForegroundColorAttributeName:GRAYCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:28/2]}];
    if (_name.length>0) {
        _nameTF.text=_name;
    }
    _nameTF.font=[UIFont systemFontOfSize:14];
    _nameTF.returnKeyType=UIReturnKeyDone;
    _nameTF.delegate=self;
    _nameTF.clearButtonMode=1;
    [backView addSubview:_nameTF];
    
    UILabel * IDLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(nameLabel), W(70), H(50))];
    IDLabel.textAlignment=NSTextAlignmentLeft;
    IDLabel.text=@"身份证号";
    IDLabel.textColor=MAINCHARACTERCOLOR;
    IDLabel.font=[UIFont systemFontOfSize:14];
    [backView addSubview:IDLabel];
    
    _IDTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(IDLabel)+W(20), kDown(_nameTF), WIDTH-W(70)-W(20)-W(12), H(50))];
    _IDTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入您的身份证号码" attributes:@{NSForegroundColorAttributeName:GRAYCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:28/2]}];
    if (_idCardNo.length>0) {
        _IDTF.text=_idCardNo;
    }
    _IDTF.font=[UIFont systemFontOfSize:14];
    _IDTF.returnKeyType=UIReturnKeyDone;
    _IDTF.delegate=self;
    _IDTF.clearButtonMode=1;
    [backView addSubview:_IDTF];
    
    UILabel * phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(IDLabel), W(70), H(50))];
    phoneLabel.textAlignment=NSTextAlignmentLeft;
    phoneLabel.text=@"联系电话";
    phoneLabel.textColor=MAINCHARACTERCOLOR;
    phoneLabel.font=[UIFont systemFontOfSize:14];
    [backView addSubview:phoneLabel];
    
    _phoneTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(phoneLabel)+W(20), kDown(_IDTF), WIDTH-W(70)-W(20)-W(12), H(50))];
    _phoneTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入您的联系电话" attributes:@{NSForegroundColorAttributeName:GRAYCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:28/2]}];
    _phoneTF.font=[UIFont systemFontOfSize:14];
    _phoneTF.returnKeyType=UIReturnKeyDone;
    _phoneTF.delegate=self;
    _phoneTF.text=_phone;
    _phoneTF.enabled=NO;
    _phoneTF.clearButtonMode=1;
    [backView addSubview:_phoneTF];
    
    UIButton * accomplishBtn=[UIButton buttonWithType:0];
    accomplishBtn.layer.cornerRadius=3;
    accomplishBtn.layer.masksToBounds=YES;
    accomplishBtn.frame=CGRectMake(W(20), kDown(backView)+H(155), WIDTH-W(20)*2, 40);
    accomplishBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    [accomplishBtn addTarget:self action:@selector(jump) forControlEvents:1<<6];
    [accomplishBtn setTitle:@"下一步" forState:0];
    [accomplishBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:accomplishBtn];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_phoneTF==textField) {
        if (_phoneTF.text.length>0) {
            
            NSString *CM = @"^[0-9]{1,11}$";
            NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
            BOOL isNum = [regextestcm evaluateWithObject:_phoneTF.text];
            DMLog(@"888%d",isNum);
            if (isNum)
            {
                if (_phoneTF.text.length<11) {
                    [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入11位手机号" buttonTitle:nil];
                }
                else
                {
//                    NSString *regex = @"^1(3[0-9]|5[0-35-9]|8[0-9])\\d{8}$";
//                    
//                    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//                    
//                    BOOL isMatch = [pred evaluateWithObject:_phoneTF.text];
//                    
//                    if (!isMatch) {
//                        
//                        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入正确的手机号" buttonTitle:nil];
//                        //            return NO;
//                        
//                    }
                    
                }
                
            }else
            {
                //            [self.view endEditing:YES];
                [UIAlertView alertWithTitle:@"温馨提示" message:@"手机号仅限数字" buttonTitle:nil];
                
            }

        }
    }
    if (_IDTF==textField) {
        if (_IDTF.text.length>0) {
//            NSString *CM = @"^[0-9xX]{1,18}$";
//            NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
            BOOL isNum = [CheckID verifyIDCardNumber:_IDTF.text];
            DMLog(@"888%d",isNum);
            if (isNum)
            {
                if (_IDTF.text.length<18) {
                    [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入18位身份证号" buttonTitle:nil];
                }
                
            }else
            {
                //            [self.view endEditing:YES];
                [UIAlertView alertWithTitle:@"温馨提示" message:@"身份证号格式不正确或不存在该身份证" buttonTitle:nil];
                
            }

        }
    }
    if (_inviteTF==textField) {
        if (_inviteTF.text.length>0) {
            NSString *CM = @"^[0-9a-zA-Z]$";
            NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
            BOOL isNum = [regextestcm evaluateWithObject:_inviteTF.text];
            DMLog(@"888%d",isNum);
            if (!isNum)
            {
//                if (_inviteTF.text.length<18) {
//                    [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入18位身份证号" buttonTitle:nil];
//                }
                
            }else
            {
                //            [self.view endEditing:YES];
                [UIAlertView alertWithTitle:@"温馨提示" message:@"邀请码仅限数字和字母" buttonTitle:nil];
                
            }

        }
    }
}
#pragma mark - 按钮绑定的方法
-(void)jump
{
//    if ([_whichPage intValue]==20) {
//        HHRPayViewController
//    }
//    PartnerPayViewController*partnerPayVC=[[PartnerPayViewController alloc]init];
//    partnerPayVC.name=_nameTF.text;
//    partnerPayVC.idcard=_IDTF.text;
//    partnerPayVC.inviteCode=_inviteTF.text;
//    partnerPayVC.whichPage=0;
//    [self.navigationController pushViewController:partnerPayVC animated:YES];
    
    if (_nameTF.text.length==0) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入姓名" buttonTitle:nil];
    }
    else if (_IDTF.text.length==0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入身份证号码" buttonTitle:nil];
    }
    else if (_phoneTF.text.length==0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入手机号" buttonTitle:nil];
    }
    else
    {
        BOOL isNum = [CheckID verifyIDCardNumber:_IDTF.text];
        DMLog(@"888%d",isNum);
        if (isNum)
        {
            if (_IDTF.text.length<18) {
                [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入18位身份证号" buttonTitle:nil];
            }
            else
            {
            
                BOOL isAccord=[NSString validatePhone:_phoneTF.text];
                if (isAccord) {
                    if ([_whichPage intValue]==20) {
                        HHRPayViewController * hhrVC=[[HHRPayViewController alloc]init];
                        hhrVC.projectModel=_projectModel;
                        hhrVC.name=_nameTF.text;
                        hhrVC.idcard=_IDTF.text;
                        hhrVC.inviteCode=_inviteTF.text;
                        [self.navigationController pushViewController:hhrVC animated:YES];
                    }
                    else
                    {
                        PartnerPayViewController*partnerPayVC=[[PartnerPayViewController alloc]init];
                        partnerPayVC.name=_nameTF.text;
                        partnerPayVC.idcard=_IDTF.text;
                        partnerPayVC.inviteCode=_inviteTF.text;
                        partnerPayVC.whichPage=0;
                        [self.navigationController pushViewController:partnerPayVC animated:YES];
                    }

                }
                else
                {
                     [UIAlertView alertWithTitle:@"温馨提示" message:@"手机号不正确" buttonTitle:nil];
                }
                

            }
            
        }else
        {
            //            [self.view endEditing:YES];
            [UIAlertView alertWithTitle:@"温馨提示" message:@"身份证号格式不正确或不存在该身份证" buttonTitle:nil];
            
        }

       
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
