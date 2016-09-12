//
//  MoveintoViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/14.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "MoveintoViewController.h"
#import "FillMsgViewController.h"
@interface MoveintoViewController ()

@end

@implementation MoveintoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"商家入驻";
    [self backButton];
    self.view.backgroundColor=[UIColor whiteColor];
    UIImageView * img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 44, WIDTH, H(380))];
    img.image=[UIImage imageNamed:@"sjrz.jpg"];
    img.contentMode=3;
    //    img.backgroundColor=[UIColor cyanColor];
    [self.view addSubview:img];
    
    UIButton * joinBtn=[UIButton buttonWithType:0];
    joinBtn.layer.cornerRadius=3;
    joinBtn.layer.masksToBounds=YES;
    joinBtn.frame=CGRectMake(W(20), kDown(img)+H(40), WIDTH-W(20)*2, 40);
    joinBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    [joinBtn addTarget:self action:@selector(jump) forControlEvents:1<<6];
    [joinBtn setTitle:@"去入驻" forState:0];
    [joinBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:joinBtn];
//    
//    UIButton * ruleBtn=[UIButton buttonWithType:0];
//    ruleBtn.frame=CGRectMake(W(100), kDown(joinBtn)+H(10), WIDTH-W(100)*2, H(20));
//    ruleBtn.titleLabel.font=[UIFont systemFontOfSize:14*KRatioH];
//    [ruleBtn setTitleColor:RGBACOLOR(200, 200, 200, 1) forState:0];
//    [ruleBtn setTitle:@"活动规则 >" forState:0];
//    //    ruleBtn.backgroundColor=[UIColor cyanColor];
//    [self.view addSubview:ruleBtn];

    // Do any additional setup after loading the view from its nib.
}

-(void)jump
{
    FillMsgViewController*fillMsgVC=[[FillMsgViewController alloc]init];
    fillMsgVC.whichPage=_whichPage;
    fillMsgVC.vctype=_vctype;
    [self.navigationController pushViewController:fillMsgVC animated:YES];
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
