//
//  ScanerPayViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/25.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "ScanerPayViewController.h"

@interface ScanerPayViewController ()

@property(nonatomic,retain)UIImageView * headImg;

@property(nonatomic,retain)UILabel * nicknameLabel;

@property(nonatomic,retain)UILabel * phoneLabel;
@end

@implementation ScanerPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"付款";
    self.view.backgroundColor=BGMAINCOLOR;
    [self backButton];
    // 加载UI
    [self loadUI];
    // Do any additional setup after loading the view.
}


-(void)loadUI
{
    _headImg=[[UIImageView alloc]init];
    _headImg.bounds=CGRectMake(0, 0, W(60), H(60));
    _headImg.center=CGPointMake(WIDTH/2, H(20)+H(30)+64);
    _headImg.image=[UIImage imageNamed:@"header"];
    _headImg.layer.cornerRadius=_headImg.frame.size.width/2;
    _headImg.layer.masksToBounds=YES;
    _headImg.contentMode=2;
    [self.view addSubview:_headImg];
    
    _nicknameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(_headImg)+H(5), WIDTH, H(20))];
    _nicknameLabel.text=@"梦之倒影";
    _nicknameLabel.textAlignment=NSTextAlignmentCenter;
    _nicknameLabel.textColor=RGBACOLOR(63, 62, 62, 1);
    _nicknameLabel.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_nicknameLabel];
    
    _phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(_nicknameLabel), WIDTH, H(20))];
    _phoneLabel.textAlignment=NSTextAlignmentCenter;
    _phoneLabel.text=@"16854736323";
    _phoneLabel.font=[UIFont systemFontOfSize:12];
    _phoneLabel.textColor=RGBACOLOR(112, 111, 110, 1);
    [self.view addSubview:_phoneLabel];

    UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(_phoneLabel)+H(20), WIDTH, H(80))];
    coverView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:coverView];
    
    UILabel * moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(10), W(30), H(20))];
    moneyLabel.text=@"金额";
    moneyLabel.textColor=RGBACOLOR(63, 62, 62, 1);
    moneyLabel.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:moneyLabel];
    
    UITextField * moneyTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(moneyLabel)+W(15), 0, WIDTH-W(15)-W(30)-W(12), H(40))];
    moneyTF.placeholder=@"请输入付款金额";
    moneyTF.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:moneyTF];
    
    UILabel * remarkLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(moneyTF)+H(10), W(30), H(20))];
    remarkLabel.textColor=RGBACOLOR(63, 62, 62, 1);
    remarkLabel.font=[UIFont systemFontOfSize:14];
    remarkLabel.text=@"备注";
    [coverView addSubview:remarkLabel];
    
    UITextField * remarkTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(remarkLabel)+W(15), kDown(moneyTF), WIDTH-W(15)-W(30)-W(12), H(40))];
    remarkTF.placeholder=@"30字以内";
    remarkTF.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:remarkTF];
    
    for (int i=0; i<3; i++) {
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, i*H(40), WIDTH, H(1))];
        lineLabel.backgroundColor=BGMAINCOLOR;
        [coverView addSubview:lineLabel];
    }
    
    _ensureBtn=[UIButton buttonWithType:0];
    _ensureBtn.frame=CGRectMake(W(20), kDown(coverView)+H(65), WIDTH-W(20)*2, 40);
    _ensureBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    //    [_uploadBtn addTarget:self action:@selector(accomplish) forControlEvents:1<<6];
    [_ensureBtn setTitle:@"确认付款" forState:0];
    [_ensureBtn addTarget:self action:@selector(ensurePay) forControlEvents:1<<6];
    [_ensureBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:_ensureBtn];

}

#pragma mark - 确认付款绑定的方法
-(void)ensurePay
{
    
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
