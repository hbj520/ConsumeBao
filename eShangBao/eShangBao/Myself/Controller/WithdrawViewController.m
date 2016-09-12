
//
//  WithdrawViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/19.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "WithdrawViewController.h"

@interface WithdrawViewController ()<UITextFieldDelegate>

@end

@implementation WithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title=@"提现";
    self.view.backgroundColor=BGMAINCOLOR;
    
    // 加载UI
    [self loadUI];
    // Do any additional setup after loading the view.
}

#pragma  mark - loadUI
-(void)loadUI
{
    UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(0, H(10)+64, WIDTH, H(40))];
    coverView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:coverView];
    
    UILabel * withdrawLabel=[[UILabel alloc]init];
//    UILabel * moneyLabel=[[UILabel alloc]init];
    withdrawLabel.text=@"可兑换金额:";
    withdrawLabel.textColor=RGBACOLOR(49, 49, 49, 1);
    withdrawLabel.font=[UIFont boldSystemFontOfSize:16];
    CGSize size =  [self sizeWithString:withdrawLabel.text font:withdrawLabel.font];
    withdrawLabel.frame = CGRectMake(W(20), H(12), size.width, size.height);
    //        categorLabel.center = self.contentView.center;
    [coverView addSubview:withdrawLabel];
    
    UILabel * moneyLabel=[[UILabel alloc]init];
    //    UILabel * moneyLabel=[[UILabel alloc]init];
    moneyLabel.text=@"￥90.00";
    moneyLabel.textColor=RGBACOLOR(49, 49, 49, 1);
    moneyLabel.font=[UIFont boldSystemFontOfSize:20];
    CGSize size1 =  [self sizeWithString:moneyLabel.text font:moneyLabel.font];
    moneyLabel.frame = CGRectMake(kRight(withdrawLabel)+W(5), H(8), size1.width, size1.height);
    //        categorLabel.center = self.contentView.center;
    [coverView addSubview:moneyLabel];
    
    UIView * backView=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(coverView)+H(10), WIDTH, H(50)*3)];
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    
    UILabel * nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(10), W(80), H(30))];
    nameLabel.text=@"姓名:";
    nameLabel.textColor=RGBACOLOR(19, 19, 19, 1);
    nameLabel.font=[UIFont systemFontOfSize:16];
    [backView addSubview:nameLabel];
    
    UITextField * nameTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(nameLabel), 0, WIDTH-W(80)-W(12), H(50))];
    nameTF.delegate=self;
    nameTF.font=[UIFont systemFontOfSize:16];
    [backView addSubview:nameTF];
    
    UILabel * openBankLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(nameTF)+H(10), W(80), H(30))];
    openBankLabel.textColor=RGBACOLOR(19, 19, 19, 1);
    openBankLabel.text=@"开户行:";
    openBankLabel.font=[UIFont systemFontOfSize:16];
    [backView addSubview:openBankLabel];
    
    UITextField * openBankTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(openBankLabel), kDown(nameTF), WIDTH-W(80)-W(12), H(50))];
    openBankTF.delegate=self;
    openBankTF.font=[UIFont systemFontOfSize:16];
    [backView addSubview:openBankTF];
    
    UILabel * accountLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(openBankTF)+H(10), W(80), H(30))];
    accountLabel.text=@"银行账户:";
    accountLabel.textColor=RGBACOLOR(19, 19, 19, 1);
    accountLabel.font=[UIFont systemFontOfSize:16];
    [backView addSubview:accountLabel];
    
    UITextField * accountTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(accountLabel), kDown(openBankTF), WIDTH-W(80)-W(12), H(50))];
    accountTF.delegate=self;
    accountTF.font=[UIFont systemFontOfSize:16];
    [backView addSubview:accountTF];
    
    for (int i=0; i<2; i++) {
        UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(49)+i*H(50), WIDTH, H(1))];
        lineLabel.backgroundColor=BGMAINCOLOR;
        [backView addSubview:lineLabel];
    }
    
    UILabel * xieyiLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(backView)+H(5), WIDTH, H(20))];
    xieyiLabel.text=@"申请提现代表您同意《易商城提现协议》";
    xieyiLabel.font=[UIFont systemFontOfSize:14];
    xieyiLabel.textColor=RGBACOLOR(128, 128, 128, 1);
    [self.view addSubview:xieyiLabel];
    
    UIButton * boundBtn=[UIButton buttonWithType:0];
    boundBtn.frame=CGRectMake(W(20), kDown(xieyiLabel)+H(80), WIDTH-W(20)*2, 40);
    boundBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    [boundBtn addTarget:self action:@selector(accomplish) forControlEvents:1<<6];
    [boundBtn setTitle:@"申请完成" forState:0];
    [boundBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:boundBtn];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - 按钮绑定的方法
-(void)accomplish
{
    
}
#pragma mark - 自适应字体大小
// 定义成方法方便多个label调用 增加代码的复用性
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(320, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
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
