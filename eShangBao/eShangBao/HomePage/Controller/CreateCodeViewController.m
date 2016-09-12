
//
//  CreateCodeViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/25.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "CreateCodeViewController.h"
#import "QRCScanner.h"
@interface CreateCodeViewController ()
{
    UIImageView * _barCodeImageView;
    NSString    * _messageIncode;
}

@end

@implementation CreateCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title=@"付款码";
    self.view.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    [self backButton];
    
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

    // 加载UI
    [self loadUI];
    // Do any additional setup after loading the view.
}

-(void)loadUI
{
    _messageIncode=[NSString stringWithFormat:@"message|%@",INVITE];
    UIView * backViews=[[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT)];
    backViews.backgroundColor=RGBACOLOR(251, 98, 7, 1);
    [self.view addSubview:backViews];
    
    UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(W(12), 20, WIDTH-W(12)*2, 400)];
    coverView.backgroundColor=[UIColor whiteColor];
    coverView.layer.cornerRadius=3;
    coverView.layer.masksToBounds=YES;
    [backViews addSubview:coverView];
    
    UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(15), WIDTH-W(12)*2, 20)];
    titleLabel.text=@"付款码";
    titleLabel.font=[UIFont systemFontOfSize:17];
    titleLabel.textColor=RGBACOLOR(63, 62, 62, 1);
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [coverView addSubview:titleLabel];
    
//    _numberLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(titleLabel)+H(10), WIDTH-W(12)*2, 20)];
//    _numberLabel.textAlignment=NSTextAlignmentCenter;
//    _numberLabel.text=[NSString stringWithFormat:@"%@",INVITE];
//    _numberLabel.textColor=RGBACOLOR(63, 62, 62, 1);
//    _numberLabel.font=[UIFont systemFontOfSize:14];
//    [coverView addSubview:_numberLabel];
    
    _barCodeImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, kDown(titleLabel)+30, WIDTH-W(12)*2-15*2, 100)];
    //    _barCodeImageView.backgroundColor=[UIColor redColor];
//    _barCodeImageView.center=CGPointMake((WIDTH-W(12)*2)/2.0, 5+30);
    [coverView addSubview:_barCodeImageView];
    [self generateCode];
    
    UIView * backView=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(_barCodeImageView)+10, WIDTH-W(12)*2, 285)];
//    backView.backgroundColor=[UIColor redColor];
    backView.backgroundColor=BGMAINCOLOR;
    [coverView addSubview:backView];
    
//    _barCodeImageView.image=[self generateBarCode:@"1234948958096" width:_barCodeImageView.frame.size.width height:_barCodeImageView.frame.size.height];
    
    _qrImageView=[[UIImageView alloc]init];
    _qrImageView.frame=CGRectMake((WIDTH-W(12)*2)/2-92, 20, 180, 180);
//    _qrImageView.center=CGPointMake(, 0);
    //带有图标的二维码
    _qrImageView.image = [QRCScanner scQRCodeForString:_messageIncode size:self.qrImageView.bounds.size.width fillColor:[UIColor blackColor] subImage:[UIImage imageNamed:@"fir_nam"]];
    [backView addSubview:_qrImageView];
}

-(UIImage*)generateBarCode:(NSString *)barCodeStr width:(CGFloat)width height:(CGFloat)height
{
    //生成条形码
    CIImage * barcodeImage;
    NSData * data = [barCodeStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:false];
    CIFilter * filter=[CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    barcodeImage = [filter outputImage];
    
    //消除模糊
    CGFloat scaleX = width / barcodeImage.extent.size.width;//
    CGFloat scaleY = height / barcodeImage.extent.size.height;
    CIImage * transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCGImage:(__bridge CGImageRef _Nonnull)(transformedImage)];
}

- (void)generateCode {
    
    // @"CICode128BarcodeGenerator"  条形码
    // @"CIAztecCodeGenerator"       二维码
    NSString *filtername = @"CICode128BarcodeGenerator";
    
    
    CIFilter *filter = [CIFilter filterWithName:filtername];
    [filter setDefaults];
    
    NSData *data = [INVITE dataUsingEncoding:NSUTF8StringEncoding];
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
