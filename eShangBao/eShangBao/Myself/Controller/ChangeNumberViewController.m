
//
//  ChangeNumberViewController.m
//  eShangBao
//
//  Created by doumee on 16/8/12.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "ChangeNumberViewController.h"
#import "BoundViewController.h"
@interface ChangeNumberViewController ()<UIAlertViewDelegate,UITextFieldDelegate>
{
    NSString * biPwd;
}

@end

@implementation ChangeNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title=@"更换手机号";
    self.view.backgroundColor=BGMAINCOLOR;
    
    [self loadUI];
    // Do any additional setup after loading the view.
}


-(void)loadUI
{
    UIImageView * bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2-W(58)/2, 27+64, W(58), H(120))];
    bgImg.image=[UIImage imageNamed:@"mobile_bg"];
    [self.view addSubview:bgImg];
    
    
    UILabel * phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, kDown(bgImg)+20, WIDTH-15*2, 20)];
    phoneLabel.text=[NSString stringWithFormat:@"当前手机号: %@",_phone];
    phoneLabel.textColor=MAINCHARACTERCOLOR;
    phoneLabel.textAlignment=NSTextAlignmentCenter;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:phoneLabel.text];
    //设置：在0-3个单位长度内的内容显示成红色
    [str addAttribute:NSForegroundColorAttributeName value:GRAYCOLOR range:NSMakeRange(0, 6)];
    phoneLabel.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:phoneLabel];
    
    UIButton * changeBtn=[UIButton buttonWithType:0];
    //    payBtn.titleLabel.textAlignment=NSTextAlignmentRight;
    changeBtn.layer.cornerRadius=3;
    changeBtn.layer.masksToBounds=YES;
    changeBtn.frame=CGRectMake(W(20), kDown(phoneLabel)+H(40), WIDTH-W(20)*2, 40);
    changeBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    [changeBtn addTarget:self action:@selector(changeNumber) forControlEvents:1<<6];
    [changeBtn setTitle:@"更换手机号" forState:0];
    [changeBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:changeBtn];

    
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
            
        case 1:
        {
            biPwd=[alertView textFieldAtIndex:0].text;
            
            NSDictionary * param=@{@"loginName":@"",@"":@""};
        }
            
            break;
        default:
            break;
    }
}


#pragma mark - 更换手机号
-(void)changeNumber
{
//    BoundViewController * boundVC=[[BoundViewController alloc]init];
//    [self.navigationController pushViewController:boundVC animated:YES];
    
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"验证原始密码" message:@"如果忘记原密码，请致电我们客服协助您更换手机号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    dialog.tag=11;
    [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeASCIICapable];
    
    //设置输入框的键盘类型
    UITextField *tf = [dialog textFieldAtIndex:0];
    tf.layer.cornerRadius=3;
    tf.layer.masksToBounds=YES;
    tf.secureTextEntry=YES;
    [dialog show];
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
