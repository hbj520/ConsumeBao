
//
//  LMSJJudgeViewController.m
//  eShangBao
//
//  Created by doumee on 16/7/4.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "LMSJJudgeViewController.h"
#import "StarView.h"
#import "SJXQViewController.h"

@interface LMSJJudgeViewController ()<UIAlertViewDelegate,UITextViewDelegate>
{
    NSString * _commentStr;
    NSString * _content;
}
@property(nonatomic,strong)UIImageView * headImg;

@property(nonatomic,strong)UILabel     * shopNameLabel;

@property(nonatomic,strong)UILabel     * shopCategoryLabel;

@property(nonatomic,strong)UIImageView * judgeImg;

@property(nonatomic,strong)UILabel     * moneyLabel;

@property(nonatomic,strong)UITextView * remarkTV;



@end

@implementation LMSJJudgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=BGMAINCOLOR;
    self.title=@"评价";
    [self backButton];
    [self loadUI];
    _content=@"";
    // Do any additional setup after loading the view.
}

-(void)loadUI
{
    _headImg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 15+64, 70, 70)];
    _headImg.backgroundColor=[UIColor cyanColor];
    _headImg.layer.cornerRadius=_headImg.frame.size.height/2;
    _headImg.layer.masksToBounds=YES;
    [_headImg setImageWithURLString:_headImgUrl placeholderImage:DEFAULTIMAGE];
    [self.view addSubview:_headImg];
    
    _shopNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_headImg)+13, _headImg.center.y-10, WIDTH-15*2-10-70, 20)];
    _shopNameLabel.text=_shopName;
    _shopNameLabel.textColor=MAINCHARACTERCOLOR;
    _shopNameLabel.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_shopNameLabel];
    
    _judgeImg=[[UIImageView alloc]initWithFrame:CGRectMake(kRight(_headImg)+10, kDown(_shopNameLabel)+20-3, 65, 10)];
    
    
//    int judge=[_infoModel.totalScore intValue];
//    _judgeImg.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d_05副本",judge]];
//    _judgeImg.backgroundColor=[UIColor cyanColor];
//    [self.view addSubview:_judgeImg];
    
    UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(_headImg)+20, WIDTH, 20)];
    titleLabel.textColor=MAINCHARACTERCOLOR;
    titleLabel.text=@"成功支付";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:titleLabel];
    
    _moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-60, kDown(titleLabel)+10, 120, 44)];
    _moneyLabel.layer.borderColor=RGBACOLOR(201, 201, 201, 1).CGColor;
    _moneyLabel.layer.borderWidth=1;
    _moneyLabel.textAlignment=NSTextAlignmentCenter;
    _moneyLabel.text=[NSString stringWithFormat:@"%.2f",[_price floatValue]];
    _moneyLabel.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:_moneyLabel];
    
    
    UILabel * timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(_moneyLabel)+20, WIDTH, 20)];
    timeLabel.textColor=MAINCHARACTERCOLOR;
    timeLabel.textAlignment=NSTextAlignmentCenter;
    timeLabel.font=[UIFont systemFontOfSize:12];
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY/MM/dd hh:mm"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    timeLabel.text=locationString;
    [self.view addSubview:timeLabel];
    
    StarView * commentStar=[[StarView alloc]initWithFrame:CGRectMake(WIDTH/2-90, kDown(timeLabel)+10, 180, H(40)) EmptyImage:@"灰星" StarImage:@"黄星"];
    [commentStar setBlock:^(NSDictionary *dict) {
        _commentStr=dict[@"tag"];
    }];
    [self.view addSubview:commentStar];
    
    _remarkTV=[[UITextView alloc]initWithFrame:CGRectMake(15, kDown(commentStar)+10, WIDTH-15*2, 70)];
    _remarkTV.layer.borderColor=RGBACOLOR(201, 201, 201, 1).CGColor;
    _remarkTV.layer.borderWidth=1;
    _remarkTV.delegate=self;
//    [_remarkTV]
    [self.view addSubview:_remarkTV];
    
    UIButton * accomplishBtn=[UIButton buttonWithType:0];
    accomplishBtn.frame=CGRectMake(15, kDown(_remarkTV)+20, WIDTH-15*2, 40);
    accomplishBtn.layer.cornerRadius=5;
    accomplishBtn.layer.masksToBounds=YES;
    accomplishBtn.backgroundColor=MAINCOLOR;
    [accomplishBtn setTitle:@"完成" forState:0];
    [accomplishBtn addTarget:self action:@selector(accomplishOrder) forControlEvents:1<<6];
    [accomplishBtn setTitleColor:[UIColor whiteColor] forState:0];
    accomplishBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:accomplishBtn];
}



-(void)accomplishOrder
{
    DMLog(@"完成评价");
    [self.view endEditing:YES];
    if (_commentStr.length==0) {
        
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请先评分才能提交" buttonTitle:nil];
        return;
        
    }
    else if (_content.length==0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请填写对商家的评语" buttonTitle:nil];
    }
    else
    {
        NSDictionary *param=@{@"orderId":_orderId,@"content":_content,@"sendScore":@"",@"qualityScore":@"",@"totalScore":_commentStr};
        [RequstEngine requestHttp:@"1022" paramDic:param blockObject:^(NSDictionary *dic) {
            
            
            DMLog(@"1022----%@",dic);
            if ([dic[@"errorCode"] intValue]==0) {
                
                UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"评论成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                
                
            }else{
                
                [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
            }
            
            
        }];

    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.view endEditing:YES];
//    NSArray *viewArr=self.navigationController.viewControllers;
//    SJXQViewController *sjxqVC=[viewArr objectAtIndex:viewArr.count-2];
//    [self.navigationController popToViewController:sjxqVC animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.26 animations:^{
        self.view.frame=CGRectMake(0, -200, WIDTH, HEIGHT);
    }];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.26 animations:^{
        self.view.frame=CGRectMake(0, 0, WIDTH, HEIGHT);
    }];
}

-(void)textViewDidChange:(UITextView *)textView
{
    _content=textView.text;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
