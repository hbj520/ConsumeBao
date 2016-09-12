//
//  DepositViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/21.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "DepositViewController.h"

@interface DepositViewController ()<UITextFieldDelegate>
{
    UITextField * _bankTF;
    UITextField * _nameTF;
    UITextField * _IDTF;
    UITextField * _moneyTF;
}

@end

@implementation DepositViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title=@"提现";
    self.view.backgroundColor=BGMAINCOLOR;
    
    // 加载UI
    [self loadUI];
    // Do any additional setup after loading the view.
}

-(void)loadUI
{
    UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(0, H(5)+64, WIDTH, H(40))];
    coverView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:coverView];
    
    UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(15), H(10), W(150), H(20))];
    titleLabel.text=@"可用的通宝币数量:";
    titleLabel.font=[UIFont systemFontOfSize:16*KRatioH];
    titleLabel.textColor=RGBACOLOR(80, 80, 80, 1);
    [coverView addSubview:titleLabel];
    
    UILabel * accountLabel=[[UILabel alloc]init];
    accountLabel.textColor=RGBACOLOR(80, 80, 80, 1);
    accountLabel.text=@"900";
    accountLabel.font=[UIFont boldSystemFontOfSize:20];
    CGSize size =  [self sizeWithString:accountLabel.text font:accountLabel.font];
    accountLabel.frame = CGRectMake(kRight(titleLabel)+W(10), H(8), size.width, size.height);
    [coverView addSubview:accountLabel];
    
    UILabel * unitLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(accountLabel)+W(3), H(12), W(50), H(20))];
    unitLabel.textColor=RGBACOLOR(80, 80, 80, 1);
    unitLabel.text=@"( 个 )";
    unitLabel.font=[UIFont systemFontOfSize:12*KRatioH];
    [coverView addSubview:unitLabel];
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(W(15), kDown(coverView)+H(10), W(65), H(20))];
    label.textColor=RGBACOLOR(128, 128, 128, 1);
    label.font=[UIFont systemFontOfSize:16*KRatioH];
    label.text=@"收款账户";
    [self.view addSubview:label];
    
    UIButton * alterBtn=[UIButton buttonWithType:0];
    alterBtn.frame=CGRectMake(W(270), kDown(coverView)+H(10), W(40), H(20));
    [alterBtn setTitle:@"修改" forState:0];
    [alterBtn setTitleColor:RGBACOLOR(80, 80, 80, 1) forState:0];
    alterBtn.titleLabel.font=[UIFont systemFontOfSize:16*KRatioH];
    alterBtn.backgroundColor=[UIColor whiteColor];
    [alterBtn addTarget:self action:@selector(alterMsg) forControlEvents:1<<6];
    [self.view addSubview:alterBtn];
    
    UIView * backView=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(label)+H(10), WIDTH, H(40)*3)];
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    
    UILabel * bankLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(10), W(100), H(20))];
    bankLabel.text=@"开户银行:";
    bankLabel.textColor=RGBACOLOR(80, 80, 80, 1);
    bankLabel.font=[UIFont systemFontOfSize:16*KRatioH];
    [backView addSubview:bankLabel];
    
    _bankTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(bankLabel), 0, WIDTH-W(12)-W(100), H(40))];
    _bankTF.text=@"中国银行";
    _bankTF.delegate=self;
    _bankTF.enabled=NO;
    _bankTF.textColor=RGBACOLOR(80, 80, 80, 1);
    _bankTF.font=[UIFont systemFontOfSize:16*KRatioH];
    [backView addSubview:_bankTF];
    
    UILabel * nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(_bankTF)+H(10), W(100), H(20))];
    nameLabel.text=@"持卡人姓名:";
    nameLabel.textColor=RGBACOLOR(80, 80, 80, 1);
    nameLabel.font=[UIFont systemFontOfSize:16*KRatioH];
    [backView addSubview:nameLabel];
    
    _nameTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(nameLabel), kDown(_bankTF), WIDTH-W(12)-W(100), H(40))];
    _nameTF.text=@"王朝";
    _nameTF.delegate=self;
    _nameTF.enabled=NO;
    _nameTF.textColor=RGBACOLOR(80, 80, 80, 1);
    _nameTF.font=[UIFont systemFontOfSize:16*KRatioH];
    [backView addSubview:_nameTF];
    
    UILabel * IDLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(_nameTF)+H(10), W(100), H(20))];
    IDLabel.text=@"身份证号:";
    IDLabel.textColor=RGBACOLOR(80, 80, 80, 1);
    IDLabel.font=[UIFont systemFontOfSize:16*KRatioH];
    [backView addSubview:IDLabel];
    
    _IDTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(IDLabel), kDown(_nameTF), WIDTH-W(12)-W(100), H(40))];
    _IDTF.text=@"345112223344455566666";
    _IDTF.delegate=self;
    _IDTF.enabled=NO;
    _IDTF.textColor=RGBACOLOR(80, 80, 80, 1);
    _IDTF.font=[UIFont systemFontOfSize:16*KRatioH];
    [backView addSubview:_IDTF];
    
    for (int i=0; i<2; i++) {
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(39)+i*H(40), WIDTH, H(1))];
        lineLabel.backgroundColor=BGMAINCOLOR;
        [backView addSubview:lineLabel];
    }
    
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(backView)+H(10), WIDTH, H(40))];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel * moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(10), W(100), H(20))];
    moneyLabel.text=@"提现金额:";
    moneyLabel.textColor=RGBACOLOR(80, 80, 80, 1);
    moneyLabel.font=[UIFont systemFontOfSize:16*KRatioH];
    [view addSubview:moneyLabel];
    
    _moneyTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(moneyLabel), 0, WIDTH-W(12)-W(100), H(40))];
    _moneyTF.text=@"300";
    _moneyTF.delegate=self;
    _moneyTF.textColor=RGBACOLOR(80, 80, 80, 1);
    _moneyTF.font=[UIFont systemFontOfSize:16*KRatioH];
    [view addSubview:_moneyTF];
    
    UIButton * withdrawBtn=[UIButton buttonWithType:0];
    withdrawBtn.frame=CGRectMake(W(20), kDown(view)+H(80), WIDTH-W(20)*2, 40);
    withdrawBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    [withdrawBtn addTarget:self action:@selector(jump) forControlEvents:1<<6];
    [withdrawBtn setTitle:@"保存" forState:0];
    [withdrawBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:withdrawBtn];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
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

#pragma mark - 按钮绑定的方法
-(void)jump
{
    
}

-(void)alterMsg
{
    _bankTF.enabled=YES;
    _nameTF.enabled=YES;
    _IDTF.enabled=YES;
    
    
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
