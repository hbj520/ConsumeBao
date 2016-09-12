//
//  AboutUSViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "AboutUSViewController.h"

@interface AboutUSViewController ()
{
    NSString * _aboutUS;
}

@end

@implementation AboutUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title=@"关于我们";
    self.view.backgroundColor=BGMAINCOLOR;
    
    
    
    NSDictionary * param=@{@"requestType":@"2"};
    [RequstEngine requestHttp:@"1044" paramDic:param blockObject:^(NSDictionary *dic) {
        DMLog(@"1044==%@",dic);
        DMLog(@"1044--%@",dic[@"data"][@"content"]);
        _aboutUS=dic[@"data"][@"content"];
        [self loadUI];
    }];
    // Do any additional setup after loading the view.
}

-(void)loadUI
{
//    UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(25)+64, WIDTH, H(20))];
//    titleLabel.text=@"消费宝";
//    titleLabel.font=[UIFont boldSystemFontOfSize:20*KRatioH];
//    titleLabel.textColor=RGBACOLOR(255, 97, 0, 1);
//    titleLabel.textAlignment=NSTextAlignmentCenter;
//    [self.view addSubview:titleLabel];
    
    UIImageView * img=[[UIImageView alloc]init];
    img.bounds=CGRectMake(0, 0, W(80), H(60));
    img.center=CGPointMake(WIDTH/2, H(25)+64+H(30));
    img.image=[UIImage imageNamed:@"关于我们_03"];
    img.contentMode=2;
    [self.view addSubview:img];
    
    UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(W(12), kDown(img)+H(25), WIDTH-W(12)*2, H(220))];
    coverView.backgroundColor=[UIColor whiteColor];
    coverView.layer.cornerRadius=3;
    coverView.layer.masksToBounds=YES;
    [self.view addSubview:coverView];
    
    UILabel * describeLabel=[[UILabel alloc]init];
    describeLabel.numberOfLines=0;
//    describeLabel.backgroundColor=[UIColor cyanColor];
    if ([_aboutUS isEqualToString:@"关于我们"]) {
        describeLabel.text=@"“消费通宝”是一个致力于满足消费者利益诉求，解决传统商家发展瓶颈的开放式移动电子商务平台，中国O2O商业模式应用领跑者。创新性的集成了异业联盟、互联网+实体、合伙众筹等先进理念和技术的基础上开发出来的具有划时代意义的新一代商业运营综合体。";
    }
    else
    {
        describeLabel.text=_aboutUS;
    }
    
//    describeLabel.text=_aboutUS;
    describeLabel.frame = CGRectMake(W(5), 0, WIDTH-W(12)*2-W(5)*2, H(120));
    describeLabel.font=[UIFont systemFontOfSize:14];
    describeLabel.textColor=MAINCHARACTERCOLOR;
    [coverView addSubview:describeLabel];
    
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(coverView)+H(60), WIDTH, H(20))];
    label.textColor=GRAYCOLOR;
    label.font=[UIFont systemFontOfSize:16];
    label.text=@"Copyright © 2009-2016";
    label.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UILabel * label1=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(label)+H(10), WIDTH, H(20))];
    label1.textAlignment=NSTextAlignmentCenter;
    label1.textColor=GRAYCOLOR;
    label1.text=@"安徽天俊大数据服务有限公司";
    label1.font=[UIFont systemFontOfSize:16];
    [self.view addSubview:label1];
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
