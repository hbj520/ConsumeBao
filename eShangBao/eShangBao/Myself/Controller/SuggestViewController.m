//
//  SuggestViewController.m
//  MashangdaoProgram
//
//  Created by Mac on 15/8/31.
//  Copyright (c) 2015年 ygq. All rights reserved.
//

#import "SuggestViewController.h"
#import "LoginViewController.h"
@interface SuggestViewController ()<UITextViewDelegate>
{
    UITextView* _deviceTF; //建议栏输入框
    UIButton* _commitButton; // 提交按钮

}

@property(nonatomic,copy) UILabel *textLabel;
@end

@implementation SuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    if (![NSString isLogin]) {
        [self loginUser];
    }
    else
    {
        [self loadUI];
    }
    
    self.title=@"建议和反馈";
    self.view.backgroundColor=BGMAINCOLOR;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    // Do any additional setup after loading the view.
}

-(void)loginUser
{
    LoginViewController * loginVC=[[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}
// 加载UI
-(void)loadUI
{
//    //    创建返回按钮
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame = CGRectMake(0, 0, H(30), H(40));
//    //    backButton.backgroundColor=[UIColor cyanColor];
//    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_返回_普通@3x.png"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = leftItem;
    
    //  右侧的按钮
    _commitButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _commitButton.frame=CGRectMake(0, 0, W(44), H(44));
    _commitButton.titleLabel.font=[UIFont systemFontOfSize:16];
    //    commitButton.backgroundColor=[UIColor redColor];
    [_commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_commitButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    //  输入框
    _deviceTF=[[UITextView alloc]initWithFrame:CGRectMake(0, H(1), WIDTH, H(260))];
    //    _deviceTF.layer.borderWidth=1;
    //    _deviceTF.backgroundColor=[UIColor cyanColor];
    //    _deviceTF.placeholder=@"请输入您的建议";
    _deviceTF.backgroundColor=[UIColor whiteColor];
    _deviceTF.textColor=RGBACOLOR(80, 80, 80, 1);
    _deviceTF.delegate=self;
    _deviceTF.scrollEnabled=NO;
    _deviceTF.keyboardType=UIKeyboardTypeDefault;
    _deviceTF.font=[UIFont systemFontOfSize:14];
    _deviceTF.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_deviceTF];
    
    _textLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(10), H(8), WIDTH, H(20))];
    _textLabel.text=@"请输入您的建议";
    _textLabel.font=[UIFont systemFontOfSize:14];
    //    _textLabel.textColor=[UIColor grayColor];
    _textLabel.enabled=NO;
    _textLabel.backgroundColor=[UIColor clearColor];
    [_deviceTF addSubview:_textLabel];

}


#pragma mark-----UITextFiledDelegate协议方法

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    //        NSLog(@"1111");
    
    if (_deviceTF.text!=nil) {
        [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [_commitButton addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [_commitButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [_commitButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    //        NSLog(@"2222");
    
    _deviceTF.text=textView.text;
    //        NSLog(@"11111%@",textView);
    
}

-(void)textViewDidChange:(UITextView *)textView
{
//    self.textLabel =  textView.text;
    if (textView.text.length == 0) {
        _textLabel.text = @"请输入您的建议";
    }else{
        _textLabel.text = @"";
    }
}

#pragma mark---UI绑定的方法

// 点击提交按钮调用的方法
-(void)commit
{
    //        NSLog(@"---%@",_deviceTF.text);
    [_deviceTF resignFirstResponder];
    [self.view endEditing:YES];
   
    if ([_deviceTF.text isEqualToString:@""]) {
        //        NSLog(@"执行了");
        UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"提示信息" message:@"请输入您的意见" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else if (([[_deviceTF.text stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]]length]==0)) {
        SHOWALERTVIEW(@"输入内容不能只是空格")
        _textLabel.text=@"";
    }
    else {

        NSDictionary * param=@{@"content":_deviceTF.text};
        [RequstEngine requestHttp:@"1043" paramDic:param blockObject:^(NSDictionary *dic) {
            DMLog(@"1043---%@",dic);
            if ([dic[@"errorCode"] intValue]==00000) {
                [UIAlertView alertWithTitle:@"温馨提示" message:@"提交成功" buttonTitle:nil];
            }
            else
            {
                [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
            }
        }];
        _deviceTF.text=nil;
    }
}

//// 返回按钮绑定的方法
//-(void)backTo
//{
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    SidebarViewController *sidebarVC = [[SidebarViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sidebarVC];
//    window.rootViewController = nav;
//    [_deviceTF resignFirstResponder];
//    //    if ([[SidebarViewController share] respondsToSelector:@selector(showSideBarControllerWithDirection:)]) {
//    //        [[SidebarViewController share] showSideBarControllerWithDirection:SideBarShowDirectionLeft];
//    //    }
//}



// 让键盘下去调用的方法
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
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
