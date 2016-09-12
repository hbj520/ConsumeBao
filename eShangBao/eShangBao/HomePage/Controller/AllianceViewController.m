//
//  AllianceViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/14.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "AllianceViewController.h"
#import "MoveintoViewController.h"
@interface AllianceViewController ()

@end

@implementation AllianceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=self.titleStr;
    //去除返回按钮的文字
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-20, -60)
//                                                         forBarMetrics:UIBarMetricsDefault];
//    //    //设置返回图标的颜色
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor=[UIColor whiteColor];
    [self loadUI];
    [self backButton];
    // Do any additional setup after loading the view from its nib.
}

-(void)loadUI
{
    UIImageView * img=[[UIImageView alloc]initWithFrame:CGRectMake(W(25), 44+H(35), W(270), H(370))];
    img.image=[UIImage imageNamed:@"万商联盟"];
    img.contentMode=2;
    img.layer.masksToBounds=YES;
//    img.backgroundColor=[UIColor cyanColor];
    [self.view addSubview:img];
    
    UIButton * joinBtn=[UIButton buttonWithType:0];
    joinBtn.layer.cornerRadius=3;
    joinBtn.layer.masksToBounds=YES;
    joinBtn.frame=CGRectMake(W(20), kDown(img)+H(15), WIDTH-W(20)*2, 40);
    joinBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    [joinBtn addTarget:self action:@selector(jump) forControlEvents:1<<6];
    [joinBtn setTitle:@"立即加入" forState:0];
    [joinBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:joinBtn];
    
//    UIButton * ruleBtn=[UIButton buttonWithType:0];
//    ruleBtn.frame=CGRectMake(W(100), kDown(joinBtn)+H(10), WIDTH-W(100)*2, H(20));
//    ruleBtn.titleLabel.font=[UIFont systemFontOfSize:14];
//    [ruleBtn setTitleColor:GRAYCOLOR forState:0];
//    [ruleBtn setTitle:@"活动规则 >" forState:0];
////    ruleBtn.backgroundColor=[UIColor cyanColor];
//    [self.view addSubview:ruleBtn];
}
-(void)jump
{
    MoveintoViewController*moveintoVC=[[MoveintoViewController alloc]init];
    moveintoVC.whichPage=_whichPage;
    moveintoVC.vctype=_vctype;
    [self.navigationController pushViewController:moveintoVC animated:YES];
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
