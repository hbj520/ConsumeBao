//
//  MyIncomeViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/20.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "MyIncomeViewController.h"
#import "WithdrawMoneyViewController.h"
#import "WithdrawViewController.h"
#import "BillViewController.h"
@interface MyIncomeViewController ()
{
    NSArray * _imgArr;// 图片数组
    NSArray * _titleArr;
    NSMutableArray * _moneyArr;
    
    NSString * _remainAccount;//账户余额
    NSString * _monthOrderNum;//月销售量
    NSString * _totalGoldRecept;//通宝币总收入
    NSString * _totalAccount;//总计现金收入
    NSString * _availableRemainAccount;

    TBActivityView *activityView;
//    NSMutableArray * _
}

@end

@implementation MyIncomeViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self mechatList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title=@"我的收入";
    self.view.backgroundColor=BGMAINCOLOR;
    _imgArr=@[@"收入2_03",@"收入2_05"];
    _titleArr=@[@"提现中",@"已提现"];
    _moneyArr=[NSMutableArray arrayWithCapacity:0];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }

    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    
    [activityView startAnimate];
    // 加载UI
//    [self loadUI];
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - loadUI
-(void)loadUI
{
    UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, H(210))];
    coverView.backgroundColor=RGBACOLOR(251, 98, 7, 1);
    [self.view addSubview:coverView];
    
    UILabel * accountLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(20), H(10), W(85), H(20))];
    accountLabel.text=@"可提现余额";
    accountLabel.textColor=[UIColor whiteColor];
    accountLabel.font=[UIFont systemFontOfSize:16];
    [coverView addSubview:accountLabel];
    
    _accountMoneyLabel=[[UILabel alloc]init];
    _accountMoneyLabel.textColor=[UIColor whiteColor];
    _accountMoneyLabel.text=[NSString stringWithFormat:@"￥%.2f",[_availableRemainAccount floatValue]];
    _accountMoneyLabel.font=[UIFont boldSystemFontOfSize:24];
    CGSize size =  [self sizeWithString:_accountMoneyLabel.text font:_accountMoneyLabel.font];
    _accountMoneyLabel.frame = CGRectMake(W(25), kDown(accountLabel)+H(10), size.width, size.height);
    [coverView addSubview:_accountMoneyLabel];
    
    UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(104), WIDTH, H(1))];
    lineLabel.backgroundColor=RGBACOLOR(245, 191, 164, 1);
    [coverView addSubview:lineLabel];
    
    UILabel * incomeLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(20), kDown(lineLabel)+H(10), W(65), H(20))];
    incomeLabel.text=@"累计收入";
    incomeLabel.font=[UIFont systemFontOfSize:16];
    incomeLabel.textColor=[UIColor whiteColor];
    [coverView addSubview:incomeLabel];
    
    _incomeMoneyLabel=[[UILabel alloc]init];
    _incomeMoneyLabel.textColor=[UIColor whiteColor];
    _incomeMoneyLabel.text=[NSString stringWithFormat:@"￥%.2f",[_totalAccount floatValue]];
    _incomeMoneyLabel.font=[UIFont boldSystemFontOfSize:24];
    CGSize size1 =  [self sizeWithString:_incomeMoneyLabel.text font:_incomeMoneyLabel.font];
    _incomeMoneyLabel.frame = CGRectMake(W(25), kDown(incomeLabel)+H(10), size1.width, size1.height);
    [coverView addSubview:_incomeMoneyLabel];
    
//    for (int i=0; i<2; i++) {
//        UIButton * jumpBtn=[]
//    }
    
    UIView * backView=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(coverView)+10, WIDTH, H(80))];
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, H(160)/2-H(1), WIDTH, H(1))];
    line.backgroundColor=RGBACOLOR(236, 236, 236, 1);
    [backView addSubview:line];
    
    UILabel * line1=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2, 0, W(1), H(160))];
    line1.backgroundColor=RGBACOLOR(236, 236, 236, 1);
    [backView addSubview:line1];
    
    for (int i=0; i<2; i++) {
        UIImageView * img=[[UIImageView alloc]initWithFrame:CGRectMake(W(40)+(i%2)*WIDTH/2, (i/2)*H(80)+H(20), W(20), H(20))];
//        img.backgroundColor=[UIColor cyanColor];
        img.contentMode=2;
        img.image=[UIImage imageNamed:_imgArr[i]];
        [backView addSubview:img];
        
        UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(70)+(i%2)*WIDTH/2, (i/2)*H(80)+H(15), W(50), H(20))];
        titleLabel.text=_titleArr[i];
        titleLabel.font=[UIFont systemFontOfSize:16];
        titleLabel.textColor=RGBACOLOR(80, 80, 80, 1);
        [backView addSubview:titleLabel];
        
        UILabel * moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(70)+(i%2)*WIDTH/2-W(2), (i/2)*H(80)+H(40), W(90), H(20))];
        moneyLabel.textColor=RGBACOLOR(80, 80, 80, 1);
        moneyLabel.text=[NSString stringWithFormat:@"￥%@",_moneyArr[i]];
        moneyLabel.font=[UIFont systemFontOfSize:16];
        [backView addSubview:moneyLabel];
        
    }
    
    UIButton * payBtn=[UIButton buttonWithType:0];
    payBtn.frame=CGRectMake(W(20), kDown(backView)+H(60), WIDTH-W(20)*2, 40);
    payBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    payBtn.layer.cornerRadius=3;
    payBtn.layer.masksToBounds=YES;
    [payBtn addTarget:self action:@selector(jump) forControlEvents:1<<6];
    [payBtn setTitle:@"我要提现" forState:0];
    [payBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:payBtn];
    
    _sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.frame=CGRectMake( W(20), H(3), W(30), H(20));
    _sureBtn.enabled=NO;
    [_sureBtn setTitle:@"账单" forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    _sureBtn.titleLabel.textAlignment=NSTextAlignmentRight;
    _sureBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    [_sureBtn addTarget:self action:@selector(checkingMsg) forControlEvents:1<<6];
    UIBarButtonItem*rightItem1=[[UIBarButtonItem alloc]initWithCustomView:_sureBtn];
    self.navigationItem.rightBarButtonItem=rightItem1;
    


}

-(void)mechatList
{
    [_moneyArr removeAllObjects];
    NSDictionary * param=@{@"shopId":USERID};
    [RequstEngine requestHttp:@"1012" paramDic:param blockObject:^(NSDictionary *dic) {
        DMLog(@"1012---%@",dic);
        DMLog(@"error----%@",dic[@"errorMsg"]);
        if ([dic[@"errorCode"] intValue]==0) {
            [activityView stopAnimate];
            _totalAccount=dic[@"shop"][@"totalAccount"];
            _remainAccount=dic[@"shop"][@"remainAccount"];
            _monthOrderNum=dic[@"shop"][@"monthOrderNum"];
            _availableRemainAccount=dic[@"shop"][@"availableRemainAccount"];
//            _totalAccount=dic[@"shop"][@"totalGoldRecept"];
            [_moneyArr addObject:dic[@"shop"][@"withdrawingAccount"]];
            [_moneyArr addObject:dic[@"shop"][@"withdrawedAccount"]];
        }
        else
        {
            [activityView stopAnimate];
            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
            
        }
       
        [self loadUI];
    }];

}
#pragma mark - 按钮绑定的方法
-(void)jump
{
    WithdrawMoneyViewController * withdrawVC=[[WithdrawMoneyViewController alloc]init];
    withdrawVC.type=0;
    withdrawVC.remain=_availableRemainAccount;
    withdrawVC.returnBate=_returnBate;
    [self.navigationController pushViewController:withdrawVC animated:YES];
}

-(void)checkingMsg
{
    BillViewController * billVC=[[BillViewController alloc]init];
    [self.navigationController pushViewController:billVC animated:YES];
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
