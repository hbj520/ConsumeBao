//
//  AddressViewController.m
//  eShangBao
//
//  Created by Dev on 16/1/21.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "AddressViewController.h"
#import "ChooseAddrViewController.h"
#import "LoginViewController.h"
@interface AddressViewController ()
{
    NSString *addressStr;
    NSString *latitude;
    NSString *longitude;
    TBActivityView  *activityView;
}

@property(nonatomic,strong)UIButton *selectedBtn;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    
    if (_addrModel!=nil) {
        
        self.title=@"编辑收货地址";
        [self settingAddressInfo];
        
    }else{
        self.title=@"新增收货地址";
        _selectedBtn=(UIButton *)[self.view viewWithTag:1];
    }
    
    if (![NSString isLogin]) {
        [self loginUser];
    }
    else
    {
        [self saveAddressButton];
    }

    

    // Do any additional setup after loading the view from its nib.
}

-(void)loginUser
{
    LoginViewController * loginVC=[[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

//配置编辑
-(void)settingAddressInfo
{
    _userName.text=_addrModel.name;
    _selectedBtn=(UIButton *)[self.view viewWithTag:[_addrModel.sex intValue]+1];
    if ([_addrModel.sex intValue]==0) {
        
        UIButton *newBtn=(UIButton *)[self.view viewWithTag:2];
        [_selectedBtn setImage:[UIImage imageNamed:@"3-(2)选择_03"] forState:0];
        [newBtn setImage:[UIImage imageNamed:@"3-(2)选择_06"] forState:0];

        
    }else{
        
        
        UIButton *newBtn=(UIButton *)[self.view viewWithTag:1];
        [_selectedBtn setImage:[UIImage imageNamed:@"3-(2)选择_03"] forState:0];
        [newBtn setImage:[UIImage imageNamed:@"3-(2)选择_06"] forState:0];
    }
    _phoneTF.text=_addrModel.phone;
    latitude=_addrModel.latitude;
    longitude=_addrModel.longitude;
    addressStr=_addrModel.positon;
    _floorTF.text=_addrModel.details;
    _chooseVeiw.hidden=YES;
    [_addressBtn setTitle:addressStr forState:0];
}

-(void)saveAddressButton
{
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"saveAddress"] style:UIBarButtonItemStylePlain target:self action:@selector(saveAddress)];
    self.navigationItem.rightBarButtonItem=rightBtn;
}
-(void)saveAddress
{
    DMLog(@"保存地址");
    
    if (_userName.text.length==0) {
        
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入收货人姓名" buttonTitle:nil];
        return;
    }
    if (_phoneTF.text.length==0) {
        
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入收货人电话号码" buttonTitle:nil];
        return;
    }
    if (![NSString validatePhone:_phoneTF.text]) {
        
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入正确的电话号码" buttonTitle:nil];
        return;
    }
    if (addressStr.length==0) {
        
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请选择收货地址" buttonTitle:nil];
        return;
    }
    if (_floorTF.text.length==0) {
        
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入详细地址" buttonTitle:nil];
        return;
    }
    
    [activityView startAnimate];
    DMLog(@"---%@",addressStr);
    
    if (_addrModel!=nil) {
        //编辑
        NSDictionary * param=@{@"addrId":_addrModel.addrId,@"name":_userName.text,@"sex":[NSString stringWithFormat:@"%ld",_selectedBtn.tag-1],@"phone":_phoneTF.text,@"positon":addressStr,@"details":_floorTF.text,@"latitude":latitude,@"longitude":longitude};
        
        
        [RequstEngine requestHttp:@"1015" paramDic:param blockObject:^(NSDictionary *dic) {
            DMLog(@"1015--address==%@",dic);
            [activityView stopAnimate];
            if ([dic[@"errorCode"] intValue]==00000) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        return;
        
    }
    NSDictionary * param=@{@"name":_userName.text,@"sex":[NSString stringWithFormat:@"%ld",_selectedBtn.tag-1],@"phone":_phoneTF.text,@"positon":addressStr,@"details":_floorTF.text,@"latitude":latitude,@"longitude":longitude};
    DMLog(@"%@",param);

    
    [RequstEngine requestHttp:@"1014" paramDic:param blockObject:^(NSDictionary *dic) {
        
        DMLog(@"1014=%@",dic);
        [activityView stopAnimate];
        if ([dic[@"errorCode"] intValue]==0000) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sirAndMadamBtn:(id)sender {
    
    UIButton *newBtn=(UIButton *)sender;
    
    if (newBtn!=_selectedBtn) {
        
        [newBtn setImage:[UIImage imageNamed:@"3-(2)选择_03"] forState:0];
        [_selectedBtn setImage:[UIImage imageNamed:@"3-(2)选择_06"] forState:0];
        _selectedBtn=newBtn;
    }
}

- (IBAction)addressButton:(id)sender {
    
    ChooseAddrViewController *chooseVC=[[ChooseAddrViewController alloc]init];
    [chooseVC returnText:^(NSDictionary *addrssDic) {
        
        DMLog(@"%@",addrssDic);
        latitude=addrssDic[@"latitude"];
        longitude=addrssDic[@"longitude"];
        addressStr=addrssDic[@"name"];
        _chooseVeiw.hidden=YES;
        [_addressBtn setTitle:addrssDic[@"name"] forState:0];
        
    }];
    
    [self.navigationController pushViewController:chooseVC animated:YES];
    DMLog(@"添加地址");
}
@end
