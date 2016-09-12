//
//  CashierViewController.m
//  eShangBao
//
//  Created by doumee on 16/7/1.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "CashierViewController.h"
#import "QRCScanner.h"
@interface CashierViewController ()
{
    UIImageView * _barCodeImageView;
    NSString    * _businessIncode;
    TBActivityView *activityView;
}

@property (nonatomic,strong) UIImageView *qrImageView;

@property (nonatomic,strong) UILabel     * shopNameLabel;//商店名

@property (nonatomic,strong) UILabel     * dateLabel;

@property (nonatomic,strong) UIButton    * backBtn;

@property (nonatomic,strong) UILabel     * inviteCodeLabel;
@end

@implementation CashierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBACOLOR(218, 160, 68, 1);
    self.fd_prefersNavigationBarHidden=YES;
    
    [self loadUI];
    // Do any additional setup after loading the view.
}

-(void)loadUI
{
    _businessIncode=[NSString stringWithFormat:@"business|%@|%@|%@|%@",_inviteCode,_shopId,_shopName,_returnGoldRate];
    
    UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(30, 20+64, WIDTH-30*2, 390)];
    coverView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:coverView];
    
    _backBtn=[UIButton buttonWithType:0];
    _backBtn.frame=CGRectMake(15, 30, W(20), H(20));
    [_backBtn addTarget:self action:@selector(backToLast) forControlEvents:1<<6];
    [_backBtn setImage:[UIImage imageNamed:@"返回_03"] forState:0];
    [self.view addSubview:_backBtn];
    
    UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, WIDTH-30*2, 20)];
    titleLabel.text=@"消费宝收款二维码";
    titleLabel.textColor=MAINCHARACTERCOLOR;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:14];
    [coverView addSubview:titleLabel];
    
    UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, WIDTH-30*2, 1)];
    lineLabel.backgroundColor=BGMAINCOLOR;
    [coverView addSubview:lineLabel];
    
//    _inviteCodeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(lineLabel)+10, WIDTH-30*2, 20)];
//    if (_inviteCode.length==0) {
//         _inviteCodeLabel.text=@"邀请码: 空";
//    }
//    else
//    {
//        _inviteCodeLabel.text=[NSString stringWithFormat:@"邀请码: %@",_inviteCode];
//    }
//    
//    _inviteCodeLabel.textColor=MAINCHARACTERCOLOR;
//    _inviteCodeLabel.textAlignment=NSTextAlignmentCenter;
//    _inviteCodeLabel.font=[UIFont systemFontOfSize:14];
//    [coverView addSubview:_inviteCodeLabel];
    
    _barCodeImageView=[[UIImageView alloc]initWithFrame:CGRectMake((WIDTH-30*2)/2-105, kDown(lineLabel)+10, 210, 80)];
    //    _barCodeImageView.backgroundColor=[UIColor redColor];
    //    _barCodeImageView.center=CGPointMake((WIDTH-W(12)*2)/2.0, 5+30);
    [coverView addSubview:_barCodeImageView];
    [self generateCode];
    
    _qrImageView=[[UIImageView alloc]initWithFrame:CGRectMake((WIDTH-30*2)/2-70, kDown(_barCodeImageView)+10, 140, 140)];
    //带有图标的二维码
    _qrImageView.image = [QRCScanner scQRCodeForString:_businessIncode size:self.qrImageView.bounds.size.width fillColor:[UIColor blackColor] subImage:[UIImage imageNamed:@"fir_nam"]];
    [coverView addSubview:_qrImageView];
    
    _shopNameLabel=[[UILabel alloc]init];
    if (_shopName.length==0) {
        _shopNameLabel.text=@"";
    }
    else
    {
        _shopNameLabel.text=[NSString stringWithFormat:@"%@收款码",_shopName];

    }
    
    _shopNameLabel.numberOfLines=2;
    _shopNameLabel.textAlignment=NSTextAlignmentCenter;
    _shopNameLabel.font=[UIFont systemFontOfSize:14];
    _shopNameLabel.textColor=MAINCHARACTERCOLOR;
    float labelSize=[NSString calculatemySizeWithFont:14 Text:_shopNameLabel.text width:WIDTH-30*2-12*2];
    _shopNameLabel.frame=CGRectMake(12, kDown(_qrImageView)+10, WIDTH-30*2-12*2, labelSize);
    [coverView addSubview:_shopNameLabel];
    
    _dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(_shopNameLabel)+10, WIDTH-30*2, 20)];
    _dateLabel.textAlignment=NSTextAlignmentCenter;
    _dateLabel.textColor=GRAYCOLOR;
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY/MM/dd hh:mm"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    _dateLabel.text=locationString;
    _dateLabel.font=[UIFont systemFontOfSize:12];
    [coverView addSubview:_dateLabel];

}

- (void)generateCode {
    
    // @"CICode128BarcodeGenerator"  条形码
    // @"CIAztecCodeGenerator"       二维码
    NSString *filtername = @"CICode128BarcodeGenerator";
    
    
    CIFilter *filter = [CIFilter filterWithName:filtername];
    [filter setDefaults];
    
    NSData *data = [_inviteCode dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    UIImage *image = [UIImage imageWithCGImage:cgImage
                                         scale:1.
                                   orientation:UIImageOrientationUp];
    
    // Resize without interpolating
    CGFloat scaleRate = _barCodeImageView.frame.size.width / image.size.width;
    UIImage *resized = [self resizeImage:image
                             withQuality:kCGInterpolationNone
                                    rate:scaleRate];
    
    _barCodeImageView.image = resized;
    
    CGImageRelease(cgImage);
}

- (UIImage *)resizeImage:(UIImage *)image
             withQuality:(CGInterpolationQuality)quality
                    rate:(CGFloat)rate {
    UIImage *resized = nil;
    CGFloat width    = image.size.width * rate;
    CGFloat height   = image.size.height * rate;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resized;
}


-(void)backToLast
{
    [self.navigationController popViewControllerAnimated:YES];
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
