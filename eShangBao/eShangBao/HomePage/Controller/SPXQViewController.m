//
//  SPXQViewController.m
//  eShangBao
//
//  Created by doumee on 16/7/1.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "SPXQViewController.h"
#import "PayOrderViewController.h"
#import "PaymentOrderViewController.h"
@interface SPXQViewController ()

@property(nonatomic,strong)UIImageView * headImg;

@property(nonatomic,strong)UILabel     * nameLabel;

@property(nonatomic,strong)UILabel     * moneyLabel;

@property(nonatomic,strong)UIButton    * backBtn;

@property(nonatomic,strong)UILabel     * titleLabel;

@property(nonatomic,strong)UIView      * coverView;

@property(nonatomic,strong)UIButton    * purchaseBtn;

@property(nonatomic,strong)UIWebView   * infoWebView;

@property(nonatomic,strong)UILabel     *goodsName;

@end

@implementation SPXQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden=YES;
    self.view.backgroundColor=[UIColor whiteColor];
    [self loadUI];
    // Do any additional setup after loading the view.
    
    [self goodsInfoRequset];
    
    
}

-(void)goodsInfoRequset
{
    NSDictionary *param=@{@"goodsId":_groundingModel.goodsId};
    [RequstEngine requestHttp:@"1075" paramDic:param blockObject:^(NSDictionary *dic) {
        
        
        DMLog(@"%@",dic);
        [_infoWebView loadHTMLString:dic[@"data"][@"details"] baseURL:nil];
        
    }];
}

-(void)loadUI
{
    _headImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    //_headImg.backgroundColor=[UIColor redColor];
    _headImg.contentMode=UIViewContentModeScaleAspectFill;
    _headImg.layer.masksToBounds=YES;
    [_headImg setImageWithURLString:_groundingModel.imgUrl placeholderImage:DEFAULTADVERTISING];
    [self.view addSubview:_headImg];
    
    
    NSString *nameStr=[NSString stringWithFormat:@"商品名称：%@",_groundingModel.goodsName];
    
    float nameStrH=[NSString calculatemySizeWithFont:16. Text:nameStr width:KScreenWidth-16];
    _goodsName=[[UILabel alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(_headImg.frame), KScreenWidth-16, nameStrH+16)];
    _goodsName.text=nameStr;
    //_goodsName.backgroundColor=BGMAINCOLOR;
    _goodsName.numberOfLines=0;
    _goodsName.textColor=MAINCHARACTERCOLOR;
    _goodsName.font=[UIFont systemFontOfSize:16.];
    [self.view addSubview:_goodsName];
    
    _coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
//    _coverView.backgroundColor=[UIColor redColor];
    [self.view addSubview:_coverView];
    
    
    
    _backBtn=[UIButton buttonWithType:0];
    _backBtn.frame=CGRectMake(15, 30, W(20), H(20));
    [_backBtn addTarget:self action:@selector(backToLast) forControlEvents:1<<6];
    [_backBtn setImage:[UIImage imageNamed:@"返回_03"] forState:0];
    [_coverView addSubview:_backBtn];
    
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_backBtn)+10, 30, WIDTH-15-10-80, 20)];
    _titleLabel.textColor=[UIColor whiteColor];
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.font=[UIFont systemFontOfSize:16];
    _titleLabel.alpha=0;
    [_coverView addSubview:_titleLabel];
    


    UIView * backView=[[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-50, WIDTH, 50)];
    backView.backgroundColor=[UIColor whiteColor];
    
    
    
    _moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, WIDTH-15-130, 20)];
    _moneyLabel.text=[NSString stringWithFormat:@"金额：¥%@",_groundingModel.price];
    _moneyLabel.textColor=MAINCHARACTERCOLOR;
    _moneyLabel.font=[UIFont systemFontOfSize:14];
    [backView addSubview:_moneyLabel];
    
    _purchaseBtn=[UIButton buttonWithType:0];
    _purchaseBtn.frame=CGRectMake(WIDTH-120, 0, 120, 50);
    _purchaseBtn.backgroundColor=MAINCOLOR;
    [_purchaseBtn setTitle:@"立即购买" forState:0];
    [_purchaseBtn setTitleColor:[UIColor whiteColor] forState:0];
    _purchaseBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [_purchaseBtn addTarget:self action:@selector(purchaseGoods) forControlEvents:1<<6];
    [backView addSubview:_purchaseBtn];
    
    

    
    _infoWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_goodsName.frame), KScreenWidth, KScreenHeight-264-nameStrH)];
    _infoWebView.backgroundColor=[UIColor whiteColor];
    
    UILabel *topLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 1)];
    topLabel.backgroundColor=BGMAINCOLOR;
    [self.view addSubview:_infoWebView];
    [backView addSubview:topLabel];
    [self.view addSubview:backView];
    
  

}

-(void)backToLast
{
    DMLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)purchaseGoods
{
    DMLog(@"立即购买");
    PaymentOrderViewController *payOrderVC=[[PaymentOrderViewController alloc]init];
    payOrderVC.groundingModel=_groundingModel;
    [self.navigationController pushViewController:payOrderVC animated:YES];
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
