//
//  NicknameViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/20.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "NicknameViewController.h"

@interface NicknameViewController ()<UITextFieldDelegate>
{
    UITextField * _nameTF;
}

@end

@implementation NicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title=@"更换昵称";
    self.view.backgroundColor=BGMAINCOLOR;
    
    // 加载UI
    [self loadUI];
    // Do any additional setup after loading the view.
}

#pragma mark - loadUI
-(void)loadUI
{
    UIView *coverView=[[UIView alloc]initWithFrame:CGRectMake(0, H(15)+64, WIDTH, H(40))];
    coverView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:coverView];
    
    _nameTF=[[UITextField alloc]initWithFrame:CGRectMake(W(12), 0, WIDTH-W(12), H(40))];
    _nameTF.delegate=self;
    _nameTF.placeholder=@"请输入昵称";
    _nameTF.font=[UIFont systemFontOfSize:14];
    _nameTF.text=_nickName;
    _nameTF.clearButtonMode=1;
    [_nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _nameTF.returnKeyType=UIReturnKeyDone;
    
    [coverView addSubview:_nameTF];
    
    UILabel * detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(coverView)+H(5), WIDTH-W(12), H(20))];
    detailLabel.text=@"好名字让你的好友更容易记住你";
    detailLabel.textColor=RGBACOLOR(128, 128, 128, 1);
    detailLabel.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:detailLabel];
    
    _sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.frame=CGRectMake( W(20), H(3), W(30), H(20));
    _sureBtn.enabled=NO;
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(backto) forControlEvents:1<<6];
    _sureBtn.titleLabel.textAlignment=NSTextAlignmentRight;
    _sureBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    
    UIBarButtonItem*rightItem1=[[UIBarButtonItem alloc]initWithCustomView:_sureBtn];
    self.navigationItem.rightBarButtonItem=rightItem1;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}


#pragma mark - 按钮绑定的方法
-(void)backto
{
    DMLog(@"nickname--%@",_nameTF.text);
    NSDictionary * dic=@{@"nickName":_nameTF.text};
    _block(dic);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextField绑定的方法
-(void)textFieldDidChange:(UITextField * )textField
{
    if (textField.text.length > 10) {
        textField.text = [textField.text substringToIndex:10];
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
