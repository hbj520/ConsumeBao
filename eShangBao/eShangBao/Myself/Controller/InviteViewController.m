//
//  InviteViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/27.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "InviteViewController.h"

@interface InviteViewController ()

@end

@implementation InviteViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    [self backButton];
    self.title=@"邀请码";
    self.view.backgroundColor=BGMAINCOLOR;
    
    // 加载UI
    [self loadUI];
    // Do any additional setup after loading the view.
}

#pragma mark - loadUI
-(void)loadUI
{
    UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(0, H(10)+64, WIDTH, H(150))];
    coverView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:coverView];
    
    UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(60), H(35), W(60), H(20))];
    titleLabel.text=@"邀请码";
    titleLabel.textColor=RGBACOLOR(91, 90, 90, 1);
    titleLabel.font=[UIFont boldSystemFontOfSize:17];
    [coverView addSubview:titleLabel];
    
    UILabel * numberLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(titleLabel)+W(20), H(35), W(200), H(20))];
    if (_inviteCode.length==0) {
        numberLabel.text=@"暂无邀请码";
    }
    else
    {
        numberLabel.text=[NSString stringWithFormat:@"%@",_inviteCode];
    }
    
    numberLabel.textColor=RGBACOLOR(255, 97, 0, 1);
    numberLabel.font=[UIFont boldSystemFontOfSize:17];
    [coverView addSubview:numberLabel];
    
    UILabel * detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(60), kDown(numberLabel)+H(20), WIDTH-W(60), H(20))];
    detailLabel.text=@"请对方关注“消费宝微信公众账号”";
    detailLabel.font=[UIFont systemFontOfSize:12];
    detailLabel.textColor=RGBACOLOR(91, 90, 90, 1);
    [coverView addSubview:detailLabel];
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(W(60), kDown(detailLabel)+H(5), WIDTH-W(60), H(20))];
    label.textColor=RGBACOLOR(91, 90, 90, 1);
    label.text=@"点击合伙人按钮输入邀请码完成绑定";
    label.font=[UIFont systemFontOfSize:12];
    [coverView addSubview:label];
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
