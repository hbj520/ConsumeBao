//
//  PromptViewController.m
//  eShangBao
//
//  Created by doumee on 16/3/16.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "PromptViewController.h"
#import "OrderDetailViewController.h"
@interface PromptViewController ()

@end

@implementation PromptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title=@"提示";
    self.view.backgroundColor=BGMAINCOLOR;
    
    [self loadUI];
    
    UIButton * button=[UIButton buttonWithType:0];
    button.frame=CGRectMake(0, 0, 30, 40);
    
    [self backOtherButton];
    UIBarButtonItem * left=[[UIBarButtonItem alloc]initWithCustomView:button];
//    UINavigationItem * [leftBar= x]
    self.navigationItem.leftBarButtonItem=left;
    
    // Do any additional setup after loading the view.
}


-(void)loadUI
{
    UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(120), WIDTH, H(35))];
    titleLabel.text=@"恭喜您兑换成功！";
    titleLabel.textColor=MAINCHARACTERCOLOR;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UIImageView * successImg=[[UIImageView alloc]initWithFrame:CGRectMake(W(92), kDown(titleLabel)+H(20), W(130), H(105))];
    successImg.image=[UIImage imageNamed:@"ex_success"];
    successImg.contentMode=2;
    [self.view addSubview:successImg];
    
    
    NSArray * titleArr=@[@"查看订单",@"返回商家"];
    for (int i=0; i<titleArr.count; i++) {
        UIButton * button=[UIButton buttonWithType:0];
        button.layer.borderColor=MAINCOLOR.CGColor;
        button.layer.borderWidth=1;
        button.layer.cornerRadius=3;
        button.layer.masksToBounds=YES;
        button.tag=i+10;
        [button addTarget:self action:@selector(checkingTypesOrder:) forControlEvents:1<<6];
        button.frame=CGRectMake(W(35)+i*(140), kDown(successImg)+H(60), W(100), H(27));
        [button setTitle:titleArr[i] forState:0];
        [button setTitleColor:MAINCHARACTERCOLOR forState:0];
        button.titleLabel.font=[UIFont systemFontOfSize:14];
        [self.view addSubview:button];
    }
    
}


-(void)checkingTypesOrder:(UIButton *)sender
{
    switch (sender.tag) {
        case 10:
        {
            DMLog(@"查看订单");
            OrderDetailViewController * orderVC=[[OrderDetailViewController alloc]init];
            orderVC.orderID=_orderID;
            [self.navigationController pushViewController:orderVC animated:YES];
        }
            break;
        case 11:
        {
            DMLog(@"返回商家");
            [[NSNotificationCenter defaultCenter]postNotificationName:@"cleanMsg" object:nil];
             [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
            break;
        default:
            break;
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
