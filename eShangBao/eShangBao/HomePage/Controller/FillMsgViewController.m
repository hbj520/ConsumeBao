//
//  FillMsgViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/15.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "FillMsgViewController.h"
#import "FillImageMsgViewController.h"
#import "ClassifyViewController.h"
#import "ChooseAddressViewController.h"
#import "CheckID.h"
#import "CityModel.h"
@interface FillMsgViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView * _tableView;
    NSArray * _dataArr;
    NSString * _classify;
    NSString *_detailedAddr;
    
    NSString * _inviteCode;//邀请码
    NSString * _name;//姓名
    NSString * _idcardno;//身份证
    NSString * _shopName;//商家信息
    NSString * _branchName;//分店名称
    NSString * _branchPhone;//门店电话
    NSString * _phone;//手机号
//    NSString * _detailedAddr;//门店地址
//    NSString * _longitude;//纬度
//    NSString * _latitude;//经度
    NSString * _categoryId;//分类编码
//    NSString * _classify;//分类名称
    
    NSString * _firstStoreImg;
    NSString * _storeImg;
    NSString * _bussnessImg;
    NSString * _allianceimg;
    NSString * _doorImg;
    NSString * _licenseImg;
    NSString * _zhizhaoImg;
    
    //城市信息
    NSString * _cityName;//城市名称
    NSString * _cityId;//城市编码
    NSString * _provinceName;//省份名称
    NSString * _provinceId;//省份编码
//    NSString * _categoryId;
}

@property (nonatomic,strong)CityModel * model;

@end

@implementation FillMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _classify=@"未选择";
    _detailedAddr=@"未选择";
    [self backButton];
    self.title=@"填写商家信息";
    self.view.backgroundColor=RGBACOLOR(249, 249, 249, 1);
    // 加载输入框
    
    if ([_vctype intValue]==0) {
        NSDictionary * param=@{@"shopId":USERID};
        [RequstEngine requestHttp:@"1012" paramDic:param blockObject:^(NSDictionary *dic) {
            DMLog(@"1012---%@",dic);
            if ([dic[@"errorCode"] intValue]==00000) {
                _inviteCode=dic[@"shop"][@"lastInviteCode"];
                _name=dic[@"shop"][@"name"];
                _idcardno=dic[@"shop"][@"idcardno"];
                _shopName=dic[@"shop"][@"shopName"];
                _branchName=dic[@"shop"][@"branchName"];
                _branchPhone=dic[@"shop"][@"branchPhone"];
                _phone=dic[@"shop"][@"phone"];
                _detailedAddr=dic[@"shop"][@"shopAddr"];
                if (_detailedAddr.length==0) {
                    _detailedAddr=@"未选择";
                }
                _classify=dic[@"shop"][@"categoryName"];
                _categoryId=dic[@"shop"][@"categoryId"];
                _firstStoreImg=dic[@"shop"][@"doorImg"];
                _zhizhaoImg=dic[@"shop"][@"businessImg"];
                _allianceimg=dic[@"shop"][@"licenseImg"];
                if (_classify.length==0) {
                    _classify=@"未选择";
                }
                if (_firstStoreImg.length>0) {
                    NSArray *array = [_firstStoreImg componentsSeparatedByString:@"/member/"];
                    _doorImg=array[1];
                    //            _nameImgUrl=[infoModel.imgUrl substringFromIndex:infoModel.imgUrl.length-51];
                    
                }
                else
                {
                    _doorImg=@"";
                }
                
                if (_zhizhaoImg.length>0) {
                    NSArray *array = [_zhizhaoImg componentsSeparatedByString:@"/member/"];
                    _bussnessImg=array[1];
                    
                }
                else
                {
                    _bussnessImg=@"";
                }
                
                if (_allianceimg.length>0) {
                    NSArray *array = [_allianceimg componentsSeparatedByString:@"/member/"];
                    _licenseImg=array[1];
                }
                else
                {
                    _licenseImg=@"";
                }
                
                
            }
            [self loadTextField];
        }];
        
    }
    else
    {
        _inviteCode=@"";
        _name=@"";
        _idcardno=@"";
        _shopName=@"";
        _branchName=@"";
        _branchPhone=@"";
        _phone=@"";
        _categoryId=@"";
        _firstStoreImg=@"";
        _storeImg=@"";
        _bussnessImg=@"";
        _allianceimg=@"";
        _doorImg=@"";
        _licenseImg=@"";
        _zhizhaoImg=@"";
        [self loadTextField];
    }
   

    _dataArr=@[@"门店地址",@"经营品类"];
    
    _saveBtn=[UIButton buttonWithType:0];
    _saveBtn.frame=CGRectMake(0, 0, W(52), 40);
    _saveBtn.titleLabel.font=[UIFont systemFontOfSize:14];
//    [_saveBtn setImage:[UIImage imageNamed:@"saveAddress"] forState:0];
    [_saveBtn setTitle:@"下一步" forState:0];
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:0];
    [_saveBtn addTarget:self action:@selector(saveMsg) forControlEvents:1<<6];
    UIBarButtonItem * rightBtn=[[UIBarButtonItem alloc]initWithCustomView:_saveBtn];
    self.navigationItem.rightBarButtonItem=rightBtn;

    // Do any additional setup after loading the view from its nib.
}

-(void)loadTextField
{
    
    //_vctype  0:成为  1：推荐
    UIView * view=[[UIView alloc]init];
    if ([_vctype intValue]==1) {
        view.frame=CGRectMake(0, H(10)+64, WIDTH, 1);
    }
    else
    {
        view.frame=CGRectMake(0, H(10)+64, WIDTH, H(44));
    }
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel * inviteLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(12), W(90), H(20))];
    inviteLabel.text=@"邀请码";
    inviteLabel.textColor=MAINCHARACTERCOLOR;
//    inviteLabel.textAlignment=NSTextAlignmentCenter;
    inviteLabel.backgroundColor=[UIColor whiteColor];
    inviteLabel.font=[UIFont systemFontOfSize:14];
    [view addSubview:inviteLabel];
    
    _inviteTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(inviteLabel), 0, WIDTH-W(90)-W(12), H(44))];
    _inviteTF.delegate=self;
    _inviteTF.clearButtonMode=1;
    if (_inviteCode.length>0) {
        _inviteTF.text=_inviteCode;
    }
    _inviteTF.returnKeyType=UIReturnKeyDone;
    _inviteTF.backgroundColor=[UIColor whiteColor];
    [_inviteTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    inviteTF.placeholder=@"邀请人的邀请码（选填）";
    _inviteTF.font=[UIFont systemFontOfSize:14];
    _inviteTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"邀请人的邀请码（选填）" attributes:@{NSForegroundColorAttributeName:GRAYCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:28/2]}];
    [view addSubview:_inviteTF];
    
    UIView * backView=[[UIView alloc]init];
    if ([_vctype intValue]==1) {
        backView.frame=CGRectMake(0, kDown(view)+10, WIDTH, H(44)*3);
    }
    else
    {
        backView.frame=CGRectMake(0, kDown(view)+10, WIDTH, H(44)*2);
    }
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    
    UILabel * nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(12), W(90), H(20))];
    nameLabel.text=@"姓名";
    nameLabel.textColor=MAINCHARACTERCOLOR;
    nameLabel.font=[UIFont systemFontOfSize:14];
    [backView addSubview:nameLabel];
    
    _nameTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(nameLabel), 0, WIDTH-W(90)-W(12), H(44))];
    _nameTF.delegate=self;
    _nameTF.clearButtonMode=1;
    [_nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    if (_name.length>0) {
        _nameTF.text=_name;
    }
    _nameTF.returnKeyType=UIReturnKeyDone;
    _nameTF.font=[UIFont systemFontOfSize:14];
    _nameTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入真实姓名" attributes:@{NSForegroundColorAttributeName:GRAYCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:28/2]}];
    [backView addSubview:_nameTF];
    
    UILabel * idNumberLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(_nameTF)+H(12), W(90), H(20))];
    idNumberLabel.text=@"身份证号";
    idNumberLabel.textColor=MAINCHARACTERCOLOR;
    idNumberLabel.font=[UIFont systemFontOfSize:14];
    [backView addSubview:idNumberLabel];
    
    _idNumberTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(idNumberLabel), kDown(_nameTF), WIDTH-W(90)-W(12), H(44))];
    _idNumberTF.delegate=self;
    if (_idcardno.length>0) {
        _idNumberTF.text=_idcardno;
    }
    _idNumberTF.clearButtonMode=1;
    [_idNumberTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _idNumberTF.returnKeyType=UIReturnKeyDone;
    _idNumberTF.keyboardType=1;
//    _idNumberTF.keyboardType=UIKeyboardTypeNumberPad;
    _idNumberTF.font=[UIFont systemFontOfSize:14];
    _idNumberTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入身份证号" attributes:@{NSForegroundColorAttributeName:GRAYCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:28/2]}];
    [backView addSubview:_idNumberTF];
    
    UILabel * loginLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(_idNumberTF)+H(12), W(90), H(20))];
    loginLabel.text=@"登录账号";
    loginLabel.textColor=MAINCHARACTERCOLOR;
    loginLabel.font=[UIFont systemFontOfSize:14];
    [backView addSubview:loginLabel];
    
    _loginTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(idNumberLabel), kDown(_idNumberTF), WIDTH-W(90)-W(12), H(44))];
    _loginTF.delegate=self;
    _loginTF.clearButtonMode=1;
    [_loginTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _loginTF.returnKeyType=UIReturnKeyDone;
    _loginTF.keyboardType=1;
    //    _idNumberTF.keyboardType=UIKeyboardTypeNumberPad;
    _loginTF.font=[UIFont systemFontOfSize:14];
    _loginTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"登录账号为6-14位的数字或字母" attributes:@{NSForegroundColorAttributeName:GRAYCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:28/2]}];
    [backView addSubview:_loginTF];

    for (int i=0; i<3; i++) {
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, i*H(44), WIDTH, H(1))];
        lineLabel.backgroundColor=BGMAINCOLOR;
        [backView addSubview:lineLabel];
    }
    
    UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(backView)+H(10), WIDTH, H(44)*4)];
    coverView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:coverView];
    
    UILabel * mainLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(12), W(90), H(20))];
    mainLabel.text=@"门店名称";
//    mainLabel.layer.borderWidth=0;
    mainLabel.textColor=MAINCHARACTERCOLOR;
    mainLabel.backgroundColor=[UIColor whiteColor];
    mainLabel.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:mainLabel];
    
    _mainTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(mainLabel), 0, WIDTH-W(90)-W(12), H(44))];
    _mainTF.delegate=self;
    _mainTF.clearButtonMode=1;
    if (_shopName.length>0) {
        _mainTF.text=_shopName;
    }
    _mainTF.returnKeyType=UIReturnKeyDone;
    [_mainTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _mainTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入" attributes:@{NSForegroundColorAttributeName:GRAYCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:28/2]}];
    _mainTF.font=[UIFont systemFontOfSize:14];
    _mainTF.backgroundColor=[UIColor whiteColor];
    [coverView addSubview:_mainTF];
    
    UILabel * branchLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(_mainTF)+H(12), W(90), H(20))];
    branchLabel.text=@"分店名称";
    branchLabel.textColor=MAINCHARACTERCOLOR;
    branchLabel.backgroundColor=[UIColor whiteColor];
    branchLabel.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:branchLabel];
    
    _branchTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(branchLabel), kDown(_mainTF), WIDTH-W(90)-W(12), H(44))];
    _branchTF.delegate=self;
    _branchTF.clearButtonMode=1;
    if (_branchName.length>0) {
        _branchTF.text=_branchName;
    }
    _branchTF.tag=10;
    _branchTF.returnKeyType=UIReturnKeyDone;
    [_branchTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _branchTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"(选填)" attributes:@{NSForegroundColorAttributeName:GRAYCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:28/2]}];
    _branchTF.font=[UIFont systemFontOfSize:14];
    _branchTF.backgroundColor=[UIColor whiteColor];
    [coverView addSubview:_branchTF];
    
    UILabel * phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(_branchTF)+H(12), W(90), H(20))];
    phoneLabel.backgroundColor=[UIColor whiteColor];
    phoneLabel.font=[UIFont systemFontOfSize:14];
    phoneLabel.text=@"门店电话";
    phoneLabel.textColor=MAINCHARACTERCOLOR;
    [coverView addSubview:phoneLabel];
    
    _phoneTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(phoneLabel), kDown(_branchTF), WIDTH-W(90)-W(12), H(44))];
    _phoneTF.delegate=self;
    _phoneTF.clearButtonMode=1;
    if (_branchPhone.length>0) {
        _phoneTF.text=_branchPhone;
    }
    _phoneTF.tag=11;
    _phoneTF.returnKeyType=UIReturnKeyDone;
    _phoneTF.keyboardType=UIKeyboardTypeNumberPad;
    [_phoneTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _phoneTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入" attributes:@{NSForegroundColorAttributeName:GRAYCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:28/2]}];
    _phoneTF.font=[UIFont systemFontOfSize:14];
    _phoneTF.backgroundColor=[UIColor whiteColor];
    [coverView addSubview:_phoneTF];
    
    UILabel * telephoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(_phoneTF)+H(12), W(90), H(20))];
    telephoneLabel.backgroundColor=[UIColor whiteColor];
    telephoneLabel.font=[UIFont systemFontOfSize:14];
    telephoneLabel.text=@"手机号码";
    telephoneLabel.textColor=MAINCHARACTERCOLOR;
    [coverView addSubview:telephoneLabel];
    
    _telephoneTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(telephoneLabel), kDown(_phoneTF), WIDTH-W(90)-W(12), H(44))];
    _telephoneTF.clearButtonMode=1;
    if (_phone.length>0) {
        _telephoneTF.text=_phone;
        _telephoneTF.enabled=NO;
    }
    _telephoneTF.tag=12;
    _telephoneTF.returnKeyType=UIReturnKeyDone;
    _telephoneTF.delegate=self;
    [_telephoneTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _telephoneTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入" attributes:@{NSForegroundColorAttributeName:GRAYCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:28/2]}];
    _telephoneTF.font=[UIFont systemFontOfSize:14];
    _telephoneTF.backgroundColor=[UIColor whiteColor];
    [coverView addSubview:_telephoneTF];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, kDown(coverView)+H(10), WIDTH, H(100)) style:0];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=0;
    _tableView.scrollEnabled=NO;
    [self.view addSubview:_tableView];
    
//    UIButton * nextBtn=[UIButton buttonWithType:0];
//    nextBtn.layer.cornerRadius=3;
//    nextBtn.layer.masksToBounds=YES;
//    nextBtn.frame=CGRectMake(W(20), kDown(_tableView)+H(25), WIDTH-W(20)*2, H(40));
//    nextBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
//    [nextBtn addTarget:self action:@selector(jump) forControlEvents:1<<6];
//    [nextBtn setTitle:@"下一步" forState:0];
//    [nextBtn setTitleColor:[UIColor whiteColor] forState:0];
//    [self.view addSubview:nextBtn];
    
    for (int i=0; i<5; i++) {
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0+i*H(44), WIDTH, H(1))];
        lineLabel.backgroundColor=BGMAINCOLOR;
        [coverView addSubview:lineLabel];
    }

}


#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    cell.textLabel.textColor=MAINCHARACTERCOLOR;
    cell.detailTextLabel.font=[UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor=GRAYCOLOR;
    cell.accessoryType=1;
    cell.selectionStyle=0;
    
    UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(49), WIDTH, H(1))];
    lineLabel.backgroundColor=BGMAINCOLOR;
    [cell.contentView addSubview:lineLabel];
    
//    cell.textLabel.text=_dataArr[indexPath.row];
//    cell.detailTextLabel.text=_dataArr[indexPath.row];
    if (indexPath.row==0) {
        
        cell.textLabel.text=@"门店地址";
        cell.detailTextLabel.text=_detailedAddr;
    }
    if (indexPath.row==1) {
        cell.textLabel.text=@"经营品类";
        cell.detailTextLabel.text=_classify;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return H(50);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        ChooseAddressViewController * chooseVC=[[ChooseAddressViewController alloc]init];
        [chooseVC addressTextBlack:^(NSDictionary *dict) {
            
            _detailedAddr=dict[@"address"];
            _latitude=dict[@"latitude"];
            _longitude=dict[@"longitude"];
            _cityId=dict[@"cityId"];
            _cityName=dict[@"cityName"];
            _provinceId=dict[@"provinceId"];
            _provinceName=dict[@"provinceName"];
            [_tableView reloadData];
            
            DMLog(@"--%@.%@,%@,%@,%@,%@,%@",_detailedAddr,_latitude,_longitude,_cityName,_provinceName,_cityId,_provinceId);
            
        }];
        [self.navigationController pushViewController:chooseVC animated:YES];
    }
    if (indexPath.row==1)
    {
        ClassifyViewController * classifyVC=[[ClassifyViewController alloc]init];
        classifyVC.classify=0;
        [classifyVC setBlock:^(NSDictionary *dic) {
            _classify=dic[@"classify"];
            _categoryId=dic[@"cateId"];
            [_tableView reloadData];
        }];
        [self.navigationController pushViewController:classifyVC animated:YES];
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (_branchTF==textField) {
        [UIView animateWithDuration:0.26 animations:^{
            self.view.frame = CGRectMake(0, -80, WIDTH, HEIGHT);
        }];
    }

    if (_phoneTF==textField) {
        [UIView animateWithDuration:0.26 animations:^{
            self.view.frame = CGRectMake(0, -120, WIDTH, HEIGHT);
        }];
    }

    if (_telephoneTF==textField) {
        [UIView animateWithDuration:0.26 animations:^{
            self.view.frame = CGRectMake(0, -180, WIDTH, HEIGHT);
        }];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.26 animations:^{
        self.view.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    }];
//    [self.view endEditing:YES];
    if (_idNumberTF==textField) {
        if (_idNumberTF.text.length>0) {
            BOOL isNum=[CheckID verifyIDCardNumber:_idNumberTF.text];
            if (isNum) {
                
            }
            else
            {
//                [self.view endEditing:NO];
//                [UIAlertView alertWithTitle:@"温馨提示" message:@"身份证号格式不正确或不存在该身份证" buttonTitle:nil];
                
                [UIAlertView alertWithTitle:@"温馨提示" message:@"身份证号格式不正确或不存在该身份证" UIViewController:self UITextField:_idNumberTF];
            }


        }
       
    }
    if (_telephoneTF==textField) {
        if (_telephoneTF.text.length>0) {
            
            NSString *CM = @"^[0-9]{1,11}$";
            NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
            BOOL isNum = [regextestcm evaluateWithObject:_telephoneTF.text];
            DMLog(@"888%d",isNum);
            if (isNum)
            {
                if (_telephoneTF.text.length<11) {
                    [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入11位手机号" buttonTitle:nil];
                }
                else
                {
//                    NSString *regex = @"^1(3[0-9]|5[0-35-9]|8[0-9]|7[0-9])\\d{8}$";
//                    
//                    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//                    
//                    BOOL isMatch = [pred evaluateWithObject:_telephoneTF.text];
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
}
#pragma mark - UITextField绑定的方法
-(void)textFieldDidChange:(UITextField * )textField
{
    
    if (textField.text.length > 18) {
        textField.text = [textField.text substringToIndex:18];
    }
}
#pragma mark - 按钮的绑定方法
//-(void)jump
//{
//    
//    FillImageMsgViewController*fillVC=[[FillImageMsgViewController alloc]init];
//    fillVC.inviteCode=_inviteTF.text;
//    fillVC.shopName=_mainTF.text;
//    fillVC.branchName=_branchTF.text;
//    fillVC.branchPhone=_phoneTF.text;
//    fillVC.shopAddr=_detailedAddr;
//    fillVC.categoryId=_classify;
//    fillVC.latitude=_latitude;
//    fillVC.longitude=_longitude;
//    fillVC.doorImg=_firstStoreImg;
//    fillVC.businessImg=_bussnessImg;
//    fillVC.licenseImg=_allianceimg;
//    fillVC.whichPage=_whichPage;
//    [self.navigationController pushViewController:fillVC animated:YES];
//}

-(void)saveMsg
{
    [self.view endEditing:YES];
    if (_nameTF.text.length==0) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入真实姓名" buttonTitle:nil];
    }
    else if (_idNumberTF.text.length==0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入身份证号" buttonTitle:nil];
    }
  
    else if (_idNumberTF.text.length<18)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入18位身份证号" buttonTitle:nil];
    }
    else if (_loginTF.text.length==0&&[_vctype intValue]==1)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入登录账号" buttonTitle:nil];
    }
    else if (_mainTF.text.length==0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入店铺名称" buttonTitle:nil];
    }
    else if (_phoneTF.text.length==0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入门店电话" buttonTitle:nil];
    }
    else if (_telephoneTF.text.length==0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入手机号码" buttonTitle:nil];
    }
    else if (_detailedAddr.length==0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请选择地址" buttonTitle:nil];
    }
    else if (_categoryId.length==0)
        
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请选择经营分类" buttonTitle:nil];
    }
    else
    {
        BOOL isNum=[CheckID verifyIDCardNumber:_idNumberTF.text];
        if (isNum) {
            
            BOOL isAccord=[NSString validatePhone:_telephoneTF.text];
            if (isAccord) {
                if ([_vctype intValue]==1) {
                    BOOL isNmuber=[NSString checkNumber:_loginTF.text];
                    if (isNmuber) {
                        NSDictionary * param=@{@"checkObj":_loginTF.text,@"type":@"0"};
                        [RequstEngine requestHttp:@"1096" paramDic:param blockObject:^(NSDictionary *dic) {
                            DMLog(@"1096-----%@",dic);
                            DMLog(@"error-----%@",dic[@"errorMsg"]);
                            if ([dic[@"errorCode"] intValue]==0) {
                                
                                NSDictionary * param=@{@"checkObj":_telephoneTF.text,@"type":@"1"};
                                [RequstEngine requestHttp:@"1096" paramDic:param blockObject:^(NSDictionary *dic) {
                                    DMLog(@"1096-----%@",dic);
                                    DMLog(@"error-----%@",dic[@"errorMsg"]);
                                    if ([dic[@"errorCode"] intValue]==0) {
                                        FillImageMsgViewController*fillVC=[[FillImageMsgViewController alloc]init];
                                        fillVC.inviteCode=_inviteTF.text;
                                        fillVC.shopName=_mainTF.text;
                                        fillVC.branchName=_branchTF.text;
                                        fillVC.branchPhone=_phoneTF.text;
                                        fillVC.shopAddr=_detailedAddr;
                                        fillVC.categoryId=_categoryId;
                                        fillVC.name=_nameTF.text;
                                        fillVC.idcardno=_idNumberTF.text;
                                        fillVC.doorImg=_doorImg;
                                        fillVC.businessImg=_bussnessImg;
                                        fillVC.licenseImg=_licenseImg;
                                        fillVC.whichPage=_whichPage;
                                        fillVC.latitude=_latitude;
                                        fillVC.longitude=_longitude;
                                        fillVC.vctype=_vctype;
                                        fillVC.phone=_telephoneTF.text;
                                        fillVC.cityName=_cityName;
                                        fillVC.cityId=_cityId;
                                        fillVC.provinceId=_provinceId;
                                        fillVC.provinceName=_provinceName;
                                        fillVC.loginName=_loginTF.text;
                                        [self.navigationController pushViewController:fillVC animated:YES];
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
                    FillImageMsgViewController*fillVC=[[FillImageMsgViewController alloc]init];
                    fillVC.inviteCode=_inviteTF.text;
                    fillVC.shopName=_mainTF.text;
                    fillVC.branchName=_branchTF.text;
                    fillVC.branchPhone=_phoneTF.text;
                    fillVC.shopAddr=_detailedAddr;
                    fillVC.categoryId=_categoryId;
                    fillVC.name=_nameTF.text;
                    fillVC.idcardno=_idNumberTF.text;
                    fillVC.doorImg=_doorImg;
                    fillVC.businessImg=_bussnessImg;
                    fillVC.licenseImg=_licenseImg;
                    fillVC.whichPage=_whichPage;
                    fillVC.latitude=_latitude;
                    fillVC.longitude=_longitude;
                    fillVC.vctype=_vctype;
                    fillVC.phone=_telephoneTF.text;
                    fillVC.cityName=_cityName;
                    fillVC.cityId=_cityId;
                    fillVC.provinceId=_provinceId;
                    fillVC.provinceName=_provinceName;
                    fillVC.loginName=_loginTF.text;
                    [self.navigationController pushViewController:fillVC animated:YES];
                }
//                BOOL isNmuber = [NSString checkNumber:_loginTF.text];
               
                

            }
            else
            {
                [UIAlertView alertWithTitle:@"温馨提示" message:@"手机号不正确" buttonTitle:nil];
            }
        }
        else
        {
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
