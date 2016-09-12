//
//  LockVIPViewController.m
//  eShangBao
//
//  Created by doumee on 16/6/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "LockVIPViewController.h"

@interface LockVIPViewController ()
{
    UITextField * _phoneTF;
    UIButton    * _accomplishBtn;
}

@end

@implementation LockVIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title=@"锁定会员";
    self.view.backgroundColor=BGMAINCOLOR;
    
    [self loadUI];
    // Do any additional setup after loading the view.
}

//加载UI
-(void)loadUI
{
    UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 20+64, WIDTH-15*2, 20)];
    titleLabel.textColor=RGBACOLOR(139, 139, 139, 1);
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.text=@"请输入您要锁定的会员手机号";
    [self.view addSubview:titleLabel];
    
    _phoneTF=[[UITextField alloc]initWithFrame:CGRectMake(0, kDown(titleLabel)+10, WIDTH, 45)];
    _phoneTF.backgroundColor=[UIColor whiteColor];
    _phoneTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName:RGBACOLOR(139, 139, 139, 1),NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _phoneTF.textColor=MAINCHARACTERCOLOR;
    _phoneTF.keyboardType=UIKeyboardTypeNumberPad;
    _phoneTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, _phoneTF.frame.size.height)];
    _phoneTF.leftViewMode = UITextFieldViewModeAlways;
    _phoneTF.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_phoneTF];
    
    _accomplishBtn=[UIButton buttonWithType:0];
    _accomplishBtn.layer.cornerRadius=3;
    _accomplishBtn.layer.masksToBounds=YES;
    _accomplishBtn.frame=CGRectMake(15, kDown(_phoneTF)+200, WIDTH-15*2, 40);
    _accomplishBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    //    [_accomplishBtn addTarget:self action:@selector(accomplish) forControlEvents:1<<6];
    [_accomplishBtn setTitle:@"绑定" forState:0];
    [_accomplishBtn addTarget:self action:@selector(accomplish) forControlEvents:1<<6];
    [_accomplishBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:_accomplishBtn];
    

}

-(void)accomplish
{
    DMLog(@"绑定手机号");
    if (_phoneTF.text.length==0) {
//        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入手机号码" UIViewController:self UITextField:_phoneTF];
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入手机号码" buttonTitle:nil];
    }
    else
    {
        NSDictionary * param=@{@"phone":_phoneTF.text};
        [RequstEngine requestHttp:@"1081" paramDic:param blockObject:^(NSDictionary *dic) {
            DMLog(@"1081----%@",dic);
            DMLog(@"error----%@",dic[@"errorMsg"]);
            if ([dic[@"errorCode"] intValue]==0) {
                [UIAlertView alertWithTitle:@"温馨提示" message:@"绑定会员成功" UIViewController:self];
            }
            else
            {
                [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
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
