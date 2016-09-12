//
//  AddGoodsViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/21.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "AddGoodsViewController.h"
#import "CTAssetsPickerController.h"
#import "ClassifyViewController.h"
#import "CollectModel.h"
#import "LoginViewController.h"
@interface AddGoodsViewController ()<UIActionSheetDelegate,UIPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CTAssetsPickerControllerDelegate,UITextFieldDelegate,uploadImageDelegate,UIAlertViewDelegate>
{
    NSData *_data1;// 身份证正面照
    NSData *_data2;// 手持身份证正面照
    NSString *_fileName1;// 身份证正面照的文件名
    NSString *_fileName2;// 手持身份证正面照的文件名
    NSMutableArray * _importItems;//导入的图片数组
    UIButton * deleteBtn;//删除按钮
    UILabel * nameLabel;
    BOOL _ischoose;
    UIView * _coverView;
    
    UIView * _backView;
    UIButton * _addGoodsBtn;
    UITextField * nameTF;
    
    int _choose;//判断点的是商品图片还是描述图片
    
    NSString * _nameImgUrl;//商品名称图片
    NSMutableArray * _descripeImgArr;//商品描述图片数组
    NSString * _cateID;//商品分类编码
    
    UIView * _view;
    GoodsInfoModel    *infoModel;
    NSString * _goodsId;//商品编码
    NSString * _bili;
    
    TBActivityView *activityView;
}

@end

@implementation AddGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
   
//    _nameImgArr=[NSMutableArray arrayWithCapacity:0];
    _descripeImgArr=[NSMutableArray arrayWithCapacity:0];
    _assets=[NSMutableArray arrayWithCapacity:0];
    _addImgArr=[NSMutableArray arrayWithCapacity:0];
    infoModel=[[GoodsInfoModel alloc]init];
    _nameImgUrl=@"";
    _bili=@"0";
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    
    [activityView startAnimate];

    self.view.backgroundColor=BGMAINCOLOR;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    // 加载UI
   
    if (_type==1) {
        [self loadUI];
        self.title=@"编辑商品";
        [self requsetGoodsInfo];
        
    }else{
        [self loadUI];
        self.title=@"添加商品";
    }
    _saveBtn=[UIButton buttonWithType:0];
    _saveBtn.frame=CGRectMake(0, 0, W(40), H(40));
    [_saveBtn setImage:[UIImage imageNamed:@"saveAddress"] forState:0];
    [_saveBtn addTarget:self action:@selector(saveMsg) forControlEvents:1<<6];
    UIBarButtonItem * rightBtn=[[UIBarButtonItem alloc]initWithCustomView:_saveBtn];
    self.navigationItem.rightBarButtonItem=rightBtn;

    // Do any additional setup after loading the view from its nib.
}

-(void)requsetGoodsInfo
{
    
    NSDictionary *param=@{@"goodsId":_goodsId};
    [RequstEngine requestHttp:@"1039" paramDic:param blockObject:^(NSDictionary *dic) {
        
        
        DMLog(@"1039----%@",dic);
        DMLog(@"error---%@",dic[@"errorMsg"]);
        if ([dic[@"errorCode"] intValue]==0) {
            [activityView stopAnimate];
            
            [infoModel setValuesForKeysWithDictionary:dic[@"data"]];
        }
        for (NSString *imageUrl in infoModel.imgList) {
            NSArray *array = [imageUrl componentsSeparatedByString:@"/product/"]; //从字符A中分隔成2个元素的数组
//            NSString *newImageUrl=[imageUrl substringFromIndex:imageUrl.length-49];
            DMLog(@"array----%@",array);
            [_descripeImgArr addObject:array[1]];
        }
        _cateID=infoModel.categoryId;
        _goodsId=infoModel.goodsId;
        if (infoModel.imgUrl.length>0) {
            NSArray *array = [infoModel.imgUrl componentsSeparatedByString:@"/product/"];
            _nameImgUrl=array[1];
//            _nameImgUrl=[infoModel.imgUrl substringFromIndex:infoModel.imgUrl.length-51];

        }
        else
        {
            _nameImgUrl=@"";
        }
        DMLog(@"count----%@",_nameImgUrl);
        [self layoutOfTheData];
        
    }];
}

-(void)layoutOfTheData
{
    DMLog(@"imgUrl-----%@",infoModel.imgUrl);
    nameTF.text=infoModel.goodsName;
    _describeTV.text=infoModel.details;
   // [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:newDic[@"imgUrl"]]
    if (infoModel.imgUrl.length==0) {
        [_addButton setImage:[UIImage imageNamed:@"camera"] forState:0];
    }
    else
    {
        [_addButton setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://115.29.246.75:8080/consumption/product/%@",_nameImgUrl]]]] forState:0];
    }
    [_zhichiBtn setBackgroundImage:[UIImage imageNamed:@"3-(2)选择_03"] forState:0];
    _biliTF.enabled=YES;
    _saveTF.text=[NSString stringWithFormat:@"%@",infoModel.stock];
    _priceTF.text=[NSString stringWithFormat:@"%@",infoModel.price];
    _biliTF.text=[NSString stringWithFormat:@"%@",infoModel.returnBate];
    _bili=_biliTF.text;
    _classify.text=infoModel.categoryName;
    for (int i=0; i<_descripeImgArr.count; i++) {
        _view=[[UIView alloc]initWithFrame:CGRectMake(W(10)+i*W(60), kDown(_describeTV), W(50), H(50))];
        _view.tag=i+1;
        [_backView addSubview:_view];
        
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, W(50), H(50))];
        img.contentMode=2;
        img.layer.masksToBounds=YES;
//        img.backgroundColor=[UIColor cyanColor];
        [img setImageWithURLString:[NSString stringWithFormat:@"http://115.29.246.75:8080/consumption/product/%@",_descripeImgArr[i]] placeholderImage:DEFAULTIMAGE];
//        img.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://114.215.188.193:8080/consumption/product/%@",_descripeImgArr[i]]]]];;
        [_view addSubview:img];
        
//        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTo:)];
        UITapGestureRecognizer *longPressGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTo:)];
        longPressGR.numberOfTapsRequired=1;
//        longPressGR.minimumPressDuration = 1.0;
        [_view addGestureRecognizer:longPressGR];
        
    }
    _addImgBtn.frame=CGRectMake(_descripeImgArr.count*(W(60))+W(10), kDown(_describeTV), W(50), H(50));
}

#pragma mark - loadUI
-(void)loadUI
{
    _coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 0+64, WIDTH, H(120))];
    _coverView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_coverView];
    
    nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(10), W(80), H(30))];
    nameLabel.text=@"商品名称:";
//    nameLabel.backgroundColor=[UIColor cy]
    nameLabel.font=[UIFont systemFontOfSize:14];
    nameLabel.textColor=RGBACOLOR(80, 80, 80, 1);
    [_coverView addSubview:nameLabel];
    
    nameTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(nameLabel), H(5), WIDTH-W(80)-W(12), H(40))];
    nameTF.placeholder=@"请输入商品的名称";
    nameTF.returnKeyType=UIReturnKeyDone;
    nameTF.delegate=self;
    nameTF.font=[UIFont systemFontOfSize:14];
    [_coverView addSubview:nameTF];
    
    _addButton=[UIButton buttonWithType:0];
    _addButton.frame=CGRectMake(W(12), kDown(nameLabel)+H(5), W(50), H(50));
    [_addButton setImage:[UIImage imageNamed:@"camera"] forState:0];
    [_addButton addTarget:self action:@selector(addImg) forControlEvents:1<<6];
    [_coverView addSubview:_addButton];
    
    _backView=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(_coverView)+H(5), WIDTH, H(160))];
    _backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_backView];
    
    _scripeLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(10), W(65), H(20))];
    _scripeLabel.text=@"商品描述:";
    _scripeLabel.textColor=RGBACOLOR(80, 80, 80, 1);
    _scripeLabel.font=[UIFont systemFontOfSize:14];
    [_backView addSubview:_scripeLabel];
    
    _describeTV=[[UITextView alloc]initWithFrame:CGRectMake(W(12), kDown(_scripeLabel), WIDTH-W(12)*2, H(60))];
    _describeTV.font=[UIFont systemFontOfSize:14];
    [_backView addSubview:_describeTV];
    
    _addImgBtn=[UIButton buttonWithType:0];
    _addImgBtn.frame=CGRectMake(W(12), kDown(_describeTV), W(50), H(50));
    [_addImgBtn setImage:[UIImage imageNamed:@"camera"] forState:0];
    [_addImgBtn addTarget:self action:@selector(addDescribeImg) forControlEvents:1<<6];
    [_backView addSubview:_addImgBtn];
    
    UILabel * titilLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(_addImgBtn), W(240), H(20))];
    titilLabel.text=@"(商品的描述，至少一张，最多4张)";
    titilLabel.textColor=RGBACOLOR(128, 128, 128, 1);
    titilLabel.font=[UIFont systemFontOfSize:14];
    [_backView addSubview:titilLabel];
    
    UIView * lastView=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(_backView)+H(5), WIDTH, H(40)*4)];
    lastView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:lastView];
    
    UILabel * saveLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(10), W(50), H(20))];
    saveLabel.text=@"库存:";
    saveLabel.font=[UIFont systemFontOfSize:14];
    saveLabel.textColor=RGBACOLOR(80, 80, 80, 1);
    [lastView addSubview:saveLabel];
    
    _saveTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(saveLabel), 0, WIDTH-W(50)-W(12), H(40))];
    _saveTF.font=[UIFont systemFontOfSize:14];
    _saveTF.placeholder=@"请输入产品的库存";
    _saveTF.keyboardType=UIKeyboardTypeNumberPad;
    _saveTF.delegate=self;
//    _saveTF.keyboardType=UIKeyboardTypeNumberPad;
    _saveTF.returnKeyType=UIReturnKeyDone;
    [lastView addSubview:_saveTF];
    for (int i=0; i<4; i++) {
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(39)+i*H(40), WIDTH, H(1))];
        lineLabel.backgroundColor=BGMAINCOLOR;
        [lastView addSubview:lineLabel];
    }
    
    
    UILabel * priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(_saveTF)+H(10), W(50), H(20))];
    priceLabel.text=@"价格:";
    priceLabel.textColor=RGBACOLOR(80, 80, 80, 1);
    priceLabel.font=[UIFont systemFontOfSize:14];
    [lastView addSubview:priceLabel];
    
    _priceTF=[[UITextField alloc]initWithFrame:CGRectMake(kRight(priceLabel), kDown(_saveTF), WIDTH-W(50)-W(12), H(40))];
    _priceTF.placeholder=@"请输入产品的价格(单位:元)";
    _priceTF.delegate=self;
    _priceTF.returnKeyType=UIReturnKeyDone;
    _priceTF.keyboardType=UIKeyboardTypeDecimalPad;
    _priceTF.font=[UIFont systemFontOfSize:14];
    [lastView addSubview:_priceTF];
    
    UILabel * label1=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(_priceTF)+H(10), W(65), H(20))];
    label1.text=@"支持返币";
    label1.textColor=RGBACOLOR(80, 80, 80, 1);
    label1.font=[UIFont systemFontOfSize:14];
    [lastView addSubview:label1];
    
    _zhichiBtn=[UIButton buttonWithType:0];
    _zhichiBtn.frame=CGRectMake(kRight(label1)+W(200), kDown(_priceTF)+H(10), W(20), H(20));
    [_zhichiBtn setBackgroundImage:[UIImage imageNamed:@"3-(2)选择_06"] forState:0];
    [_zhichiBtn addTarget:self action:@selector(zhichiChange) forControlEvents:1<<6];
    [lastView addSubview:_zhichiBtn];
    
    UILabel * label2=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(label1)+H(10)*2, W(65), H(20))];
    label2.text=@"返币比例";
    label2.textColor=RGBACOLOR(80, 80, 80, 1);
    label2.font=[UIFont systemFontOfSize:14];
    [lastView addSubview:label2];
    
    UIView * biliView=[[UIView alloc]initWithFrame:CGRectMake(kRight(label2)+W(90), kDown(label1)+H(10), W(60)+W(70)+W(10), H(40))];
    biliView.layer.borderColor=BGMAINCOLOR.CGColor;
    biliView.layer.borderWidth=1;
//    biliView.backgroundColor=[UIColor redColor];
    [lastView addSubview:biliView];
    
    _biliTF=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, W(60)+W(70), H(40))];
    _biliTF.placeholder=@"请输入0-1之间的数";
    _biliTF.font=[UIFont systemFontOfSize:14];
    _biliTF.delegate=self;
    _biliTF.enabled=NO;
    [_biliTF addTarget:self action:@selector(chooseBili:) forControlEvents:UIControlEventEditingChanged];
    _biliTF.textAlignment=NSTextAlignmentRight;
    _biliTF.returnKeyType=UIReturnKeyDone;
//    _biliTF.layer.borderColor=BGMAINCOLOR.CGColor;
//    _biliTF.layer.borderWidth=1;
    _biliTF.keyboardType=UIKeyboardTypeDecimalPad;
    [biliView addSubview:_biliTF];
    
//    UILabel * label3=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_biliTF)+W(5), kDown(label1)+H(10)+H(5), W(20), H(30))];
//    label3.text=@"%";
//    label3.textColor=RGBACOLOR(80, 80, 80, 1);
//    label3.font=[UIFont systemFontOfSize:16*KRatioH];
//    [lastView addSubview:label3];
    
    UIView * fenleiView=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(lastView), WIDTH, H(40))];
    fenleiView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:fenleiView];
    
    UILabel * titleLabel1=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(10), W(50), H(20))];
    titleLabel1.textColor=RGBACOLOR(80, 80, 80, 1);
    titleLabel1.text=@"分类至";
    titleLabel1.font=[UIFont systemFontOfSize:14];
    [fenleiView addSubview:titleLabel1];
    
    _classify=[[UILabel alloc]initWithFrame:CGRectMake(W(190), H(10), W(100), H(20))];
    _classify.text=@"未分类";
    _classify.textAlignment=NSTextAlignmentRight;
    _classify.font=[UIFont systemFontOfSize:14];
    _classify.textColor=RGBACOLOR(80, 80, 80, 1);
    [fenleiView addSubview:_classify];
    
    UIImageView * jumpImg=[[UIImageView alloc]initWithFrame:CGRectMake(kRight(_classify)+W(5), H(12), W(10), H(16))];
    jumpImg.image=[UIImage imageNamed:@"icon1_15"];
    jumpImg.contentMode=2;
    [fenleiView addSubview:jumpImg];
    
    UIButton * classifyBtn=[UIButton buttonWithType:0];
    classifyBtn.frame=CGRectMake(W(210), 0, W(100), H(40));
//    classifyBtn.backgroundColor=[UIColor cyanColor];
    [classifyBtn addTarget:self action:@selector(jump) forControlEvents:1<<6];
    [fenleiView addSubview:classifyBtn];
    
    
}

#pragma mark---UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //        NSLog(@"0拍照");
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
        
    }else if(buttonIndex == 1)
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }else
    {
        //        NSLog(@"2取消");
    }
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage * image=[info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(selectPic:) withObject:image afterDelay:0.1];
}

- (void)selectPic:(UIImage*)image
{
    DMLog(@"image%@",image);
    if ( _type==1) {
        if (_choose==1) {
            [_addButton setImage:image forState:0];
            FTPUploadImage *uploadImage= [[FTPUploadImage alloc]init];
            uploadImage.delegate=self;
            [uploadImage FTPUploadImage:@"product" ImageData:image];
        }
        else
        {
            
            FTPUploadImage *uploadImage= [[FTPUploadImage alloc]init];
            uploadImage.delegate=self;
            uploadImage.type=1;
            [activityView startAnimate];
            [uploadImage FTPUploadImage:@"product" ImageData:image];
            
        }

    }
    else
    {
        if (_choose==1) {
            [_addButton setImage:image forState:0];
            FTPUploadImage *uploadImage= [[FTPUploadImage alloc]init];
            uploadImage.delegate=self;
            [uploadImage FTPUploadImage:@"product" ImageData:image];
        }
        else
        {
            FTPUploadImage *uploadImage= [[FTPUploadImage alloc]init];
            uploadImage.delegate=self;
            [uploadImage FTPUploadImage:@"product" ImageData:image];
            for (UIView * view in [_backView subviews]) {
                if ([view isKindOfClass:[_addImgBtn class]]||[view isKindOfClass:[_scripeLabel class]]||[view isKindOfClass:[_describeTV class]]) {
                    continue;
                }
                else
                {
                    [view removeFromSuperview];
                }
            }
            
            [_descripeImgArr addObject:image];
            //        DMLog(@"****---%ld",_addImgArr.count);
            
            for (int i=0; i<_descripeImgArr.count; i++) {
                
                
                _view=[[UIView alloc]initWithFrame:CGRectMake(W(10)+i*W(60), kDown(_describeTV), W(50), H(50))];
                //        view.backgroundColor=[UIColor cyanColor];
                _view.tag=i+1;
                [_backView addSubview:_view];
                
                UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, W(50), H(50))];
                img.contentMode=2;
                img.layer.masksToBounds=YES;
                img.image = _descripeImgArr[i];
                [_view addSubview:img];
                
                UITapGestureRecognizer *longPressGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTo:)];
                longPressGR.numberOfTapsRequired=1;
//                longPressGR.minimumPressDuration = 1.0;
                [_view addGestureRecognizer:longPressGR];
                
            }
        
            _addImgBtn.frame=CGRectMake(_descripeImgArr.count*(W(60))+W(10), kDown(_describeTV), W(50), H(50));
        }

    }
//    _headImage=image;
//    [_tableView reloadData];
}

#pragma mark - Assets Picker Delegate

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    
    [self.addImgArr addObjectsFromArray:assets];
    
    for (int i=0; i<_addImgArr.count; i++) {
        ALAsset *asset = [self.addImgArr objectAtIndex:i];
        
        
        _view=[[UIView alloc]initWithFrame:CGRectMake(W(10)+i*W(60), kDown(_describeTV), W(50), H(50))];
        _view.tag=i+1;
        [_backView addSubview:_view];
        
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, W(50), H(50))];
        img.contentMode=2;
        img.image = [UIImage imageWithCGImage:asset.thumbnail];
        [_view addSubview:img];
        
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTo:)];
        longPressGR.minimumPressDuration = 1.0;
        [_view addGestureRecognizer:longPressGR];
        
        FTPUploadImage *uploadImage= [[FTPUploadImage alloc]init];
        uploadImage.delegate=self;
        [uploadImage FTPUploadImage:@"product" ImageData:[UIImage imageWithCGImage:asset.thumbnail]];

    }
    _addImgBtn.frame=CGRectMake(_addImgArr.count*(W(60))+W(10), kDown(_describeTV), W(50), H(50));
}



#pragma mark - uploadImage
-(void)uploadImageComplete:(NSString *)imageUrl
{
    [activityView stopAnimate];
    if (imageUrl==nil) {
        DMLog(@"上传失败");
        [UIAlertView alertWithTitle:@"温馨提示" message:@"图片上传失败，请重新上传" buttonTitle:nil];
    }
    else
    {
        
        DMLog(@"上传成功-------%@",imageUrl);
        if (_type==1) {
            
            if (_choose==1) {
                _nameImgUrl=imageUrl;
            }
            else
            {
                if (imageUrl.length==0) {
                    
                }
                else
                {
                    double delayInSeconds = 1.0;
//                    __block AddGoodsViewController* bself = self;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                        [bself delayMethod];
                        for (UIView * view in [_backView subviews]) {
                            if ([view isKindOfClass:[_addImgBtn class]]||[view isKindOfClass:[_scripeLabel class]]||[view isKindOfClass:[_describeTV class]]) {
                                continue;
                            }
                            else
                            {
                                [view removeFromSuperview];
                            }
                        }
                        
                        [_descripeImgArr addObject:imageUrl];
                        DMLog(@"****---%@",_descripeImgArr);
                        
                        for (int i=0; i<_descripeImgArr.count; i++) {
                            
                            
                            _view=[[UIView alloc]initWithFrame:CGRectMake(W(10)+i*W(60), kDown(_describeTV), W(50), H(50))];
                            //        view.backgroundColor=[UIColor cyanColor];
                            _view.tag=i+1;
                            [_backView addSubview:_view];
                            
                            UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, W(50), H(50))];
                            img.contentMode=2;
                            img.layer.masksToBounds=YES;
                            [img setImageWithURLString:[NSString stringWithFormat:@"http://115.29.246.75:8080/consumption/product/%@",_descripeImgArr[i]] placeholderImage:DEFAULTIMAGE];
                            //                    img.image = _descripeImgArr[i];
                            [_view addSubview:img];
                            
                            UITapGestureRecognizer *longPressGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTo:)];
//                            longPressGR.minimumPressDuration = 1.0;
                            [_view addGestureRecognizer:longPressGR];
                            
                        }
                        //    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
                        //    longPressGR.minimumPressDuration = 1.0;
                        //    [_coverView addGestureRecognizer:longPressGR];
                        _addImgBtn.frame=CGRectMake(_descripeImgArr.count*(W(60))+W(10), kDown(_describeTV), W(50), H(50));

                    });
                                       //                [_addImgArr addObject:imageUrl];
                }

            }
               
        }
        else
        {
            if (_choose==1) {
                _nameImgUrl=imageUrl;
            }
            else
            {
                [_addImgArr addObject:imageUrl];
            }

        }
               DMLog(@"img--%@,%@",_nameImgUrl,_descripeImgArr);
    }
}

- (NSArray *)indexPathOfNewlyAddedAssets:(NSArray *)assets
{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    for (NSInteger i = self.assets.count; i < self.assets.count + assets.count ; i++)
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    
    return indexPaths;
}



#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==_saveTF) {
        [UIView animateWithDuration:0.28 animations:^{
            self.view.frame = CGRectMake(0, -180, WIDTH, HEIGHT);
        }];
    }
    if (textField==_priceTF) {
        [UIView animateWithDuration:0.28 animations:^{
            self.view.frame = CGRectMake(0, -180, WIDTH, HEIGHT);
        }];
    }
    if (textField==_biliTF) {
        [UIView animateWithDuration:0.30 animations:^{
            self.view.frame = CGRectMake(0, -216, WIDTH, HEIGHT);
        }];
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==_biliTF) {
        _bili=textField.text;
    }
//    if (textField==_saveTF) {
        [UIView animateWithDuration:0.30 animations:^{
            self.view.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        }];
//    }
////    if (textField==_priceTF) {
//        [UIView animateWithDuration:0.26 animations:^{
//            self.view.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
//        }];
//    }
    
}
#pragma mark - 按钮绑定的方法
-(void)addImg
{
    [self.view endEditing:YES];
    _choose=1;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [actionSheet showInView:self.view];
    
    
}

-(void)addDescribeImg
{
    if (_descripeImgArr.count==4) {
        [self.view endEditing:YES];
        _choose=2;
        [UIAlertView alertWithTitle:@"温馨提示" message:@"您已加到最多图片啦！" buttonTitle:nil];
    }
    else
    {
        [self.view endEditing:YES];
        _choose=2;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [actionSheet showInView:self.view];

    }
}
#pragma mark - 手势绑定的方法
- (void)longPressToDo:(UITapGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        DMLog(@"长按手势触发了");
        //        UIButton * btn=(UIButton *)recognizer.view;
        
        UIView * view=(UIView *)recognizer.view;
        
        deleteBtn=[UIButton buttonWithType:0];
        deleteBtn.frame=CGRectMake(W(30), 0, W(10), H(10));
        deleteBtn.backgroundColor=[UIColor cyanColor];
        deleteBtn.tag=view.tag;
        [deleteBtn addTarget:self action:@selector(deletePicture:) forControlEvents:1<<6];
        [view addSubview:deleteBtn];
        [self start:view];
    }
    
}

- (void)longPressTo:(UITapGestureRecognizer*)recognizer
{
//    if (recognizer.state == UIGestureRecognizerStateBegan) {
        DMLog(@"长按手势触发了");
        //        UIButton * btn=(UIButton *)recognizer.view;
        
        UIView * view=(UIView *)recognizer.view;
        
//        _deleteImgBtn=[UIButton buttonWithType:0];
//        _deleteImgBtn.frame=CGRectMake(W(40), 0, W(10), H(10));
//        _deleteImgBtn.backgroundColor=[UIColor cyanColor];
//        _deleteImgBtn.tag=view.tag;
//        [_deleteImgBtn addTarget:self action:@selector(deleteImg:) forControlEvents:1<<6];
//        [view addSubview:_deleteImgBtn];
//        [self start:view];
//    }
    
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否确认删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag=view.tag;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
//            []
        {
            UIView * views=alertView.superview;
            DMLog(@"删除按钮触发了");
            //    DMLog(@"%ld",sender.tag);
            [self stop:views];
            
            int i=0;
            UIView * subViews=(UIView *)[_backView viewWithTag:alertView.tag];
            [subViews removeFromSuperview];
            if (_type==1) {
                [_descripeImgArr removeObjectAtIndex:alertView.tag-1];
                //    _view=[[UIView alloc]initWithFrame:CGRectMake(W(10)+_assets.count*W(60), H(10), W(50), H(50))];
                
                for (UIView * view in [_backView subviews]) {
                    if ([view isKindOfClass:[_addImgBtn class]]) {
                        continue;
                    }
                    else if ([view isKindOfClass:[_scripeLabel class]])
                    {
                        continue;
                    }
                    else if ([view isKindOfClass:[_describeTV class]])
                    {
                        continue;
                    }
                    view.frame=CGRectMake(W(10)+i*W(60), kDown(_describeTV), W(50), H(50));
                    view.tag=i+1;
                    i++;
                }
                _addImgBtn.frame=CGRectMake(_descripeImgArr.count*(W(60))+W(10), kDown(_describeTV), W(50), H(50));
                
            }
            else
            {
           
                [_descripeImgArr removeObjectAtIndex:alertView.tag-1];
                [_addImgArr removeObjectAtIndex:alertView.tag-1];
                //    _view=[[UIView alloc]initWithFrame:CGRectMake(W(10)+_assets.count*W(60), H(10), W(50), H(50))];
                
                for (UIView * view in [_backView subviews]) {
                    if ([view isKindOfClass:[_addImgBtn class]]) {
                        continue;
                    }
                    else if ([view isKindOfClass:[_scripeLabel class]])
                    {
                        continue;
                    }
                    else if ([view isKindOfClass:[_describeTV class]])
                    {
                        continue;
                    }
                    view.frame=CGRectMake(W(10)+i*W(60), kDown(_describeTV), W(50), H(50));
                    view.tag=i+1;
                    i++;
                }
                
                _addImgBtn.frame=CGRectMake(_descripeImgArr.count*(W(60))+W(10), kDown(_describeTV), W(50), H(50));
                DMLog(@"-----%@",_addImgArr);
            }

        }
            break;
        default:
            break;
    }
}
#pragma mark - 删除按钮绑定的方法
-(void)deletePicture:(UIButton *)sender
{
    UIView * view=sender.superview;
    DMLog(@"删除按钮触发了");
//    DMLog(@"%ld",sender.tag);
    [self stop:view];
    
    int i=0;
    UIView * subViews=(UIView *)[_coverView viewWithTag:sender.tag];
    [subViews removeFromSuperview];
    [_assets removeObjectAtIndex:sender.tag-1];
    [_descripeImgArr removeObjectAtIndex:sender.tag-1];
    //    _view=[[UIView alloc]initWithFrame:CGRectMake(W(10)+_assets.count*W(60), H(10), W(50), H(50))];
    
    for (UIView * view in [_coverView subviews]) {
        if ([view isKindOfClass:[_addButton class]]) {
            continue;
        }
        else if ([view isKindOfClass:[nameLabel class]])
        {
            continue;
        }
        else if ([view isKindOfClass:[nameTF class]])
        {
            continue;
        }
        view.frame=CGRectMake(W(10)+i*W(60), kDown(nameLabel), W(50), H(50));
        view.tag=i+1;
        i++;
    }
    _addButton.frame=CGRectMake(_assets.count*(W(60))+W(10), kDown(nameLabel), W(40), H(50));
}

-(void)deleteImg:(UIButton *)sender
{
    UIView * views=sender.superview;
    DMLog(@"删除按钮触发了");
//    DMLog(@"%ld",sender.tag);
    [self stop:views];
    
    int i=0;
    UIView * subViews=(UIView *)[_backView viewWithTag:sender.tag];
    [subViews removeFromSuperview];
    if (_type==1) {
        [_descripeImgArr removeObjectAtIndex:sender.tag-1];
        //    _view=[[UIView alloc]initWithFrame:CGRectMake(W(10)+_assets.count*W(60), H(10), W(50), H(50))];
        
        for (UIView * view in [_backView subviews]) {
            if ([view isKindOfClass:[_addImgBtn class]]) {
                continue;
            }
            else if ([view isKindOfClass:[_scripeLabel class]])
            {
                continue;
            }
            else if ([view isKindOfClass:[_describeTV class]])
            {
                continue;
            }
            view.frame=CGRectMake(W(10)+i*W(60), kDown(_describeTV), W(50), H(50));
            view.tag=i+1;
            i++;
        }
        _addImgBtn.frame=CGRectMake(_descripeImgArr.count*(W(60))+W(10), kDown(_describeTV), W(50), H(50));

    }
    else
    {
        [_descripeImgArr removeObjectAtIndex:sender.tag-1];
        [_addImgArr removeObjectAtIndex:sender.tag-1];
        //    _view=[[UIView alloc]initWithFrame:CGRectMake(W(10)+_assets.count*W(60), H(10), W(50), H(50))];
        
        for (UIView * view in [_backView subviews]) {
            if ([view isKindOfClass:[_addImgBtn class]]) {
                continue;
            }
            else if ([view isKindOfClass:[_scripeLabel class]])
            {
                continue;
            }
            else if ([view isKindOfClass:[_describeTV class]])
            {
                continue;
            }
            view.frame=CGRectMake(W(10)+i*W(60), kDown(_describeTV), W(50), H(50));
            view.tag=i+1;
            i++;
        }

        _addImgBtn.frame=CGRectMake(_descripeImgArr.count*(W(60))+W(10), kDown(_describeTV), W(50), H(50));
        DMLog(@"-----%@",_addImgArr);
    }
      
}
#pragma mark - 长按开始抖动的方法
-(void)start:(UIView *)view
{
    double angel1 = -5.0/180.0 *M_PI;
    double angel2 =  5.0/180.0 *M_PI;
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.values=@[@(angel1),@(angel2),@(angel1)];
    anim.duration=0.25;
    anim.repeatCount=MAXFLOAT;
    anim.removedOnCompletion=NO;
    anim.fillMode=kCAFillModeBackwards;
    [view.layer addAnimation:anim forKey:@"shake"];
}

-(void)stop:(UIView*)view
{
    [view.layer removeAnimationForKey:@"shake"];
}

#pragma mark - 分类按钮
-(void)jump
{
    ClassifyViewController * classifyVC=[[ClassifyViewController alloc]init];
    [classifyVC setBlock:^(NSDictionary *dic) {
        _classify.text=dic[@"classify"];
        _cateID=dic[@"cateId"];
    }];
    classifyVC.classify=1;
    [self.navigationController pushViewController:classifyVC animated:YES];
}

-(void)saveMsg
{
    if (nameTF.text.length==0) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入商品名称" buttonTitle:nil];
    }else if (_describeTV.text.length==0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"商品描述不能为空" buttonTitle:nil];
    }
    else if (_saveTF.text.length==0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"库存量不能为空" buttonTitle:nil];
    }
    else if (_cateID.length==0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请选择分类" buttonTitle:nil];
    }
    else if (_priceTF.text.length==0) {
        
        [UIAlertView alertWithTitle:@"温馨提示" message:@"商品价格不能为空" buttonTitle:nil];
    }
    else if ([_biliTF.text floatValue]>=1.0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"返币比例不能大于1" buttonTitle:nil];
    }
    else
    {
//        NSString *CM = @"^[0-9]+(.[0-9]{1,2})?$";
//        NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//        BOOL isNum = [regextestcm evaluateWithObject:_biliTF.text];
//        if (isNum) {
            if (_type==1) {
                
                if (![NSString isLogin]) {
                    [self loginUser];
                }
                else
                {
                    
                    NSDictionary * param = @{@"goodsId":_goodsId,@"name":nameTF.text,@"imgUrl":_nameImgUrl,@"imgList":_descripeImgArr,@"details":_describeTV.text,@"attrList":@"",@"categoryId":_cateID,@"price":_priceTF.text,@"barCode":@"",@"stock":_saveTF.text,@"returnBate":_bili};
                    [RequstEngine requestHttp:@"1037" paramDic:param blockObject:^(NSDictionary *dic) {
                        DMLog(@"1037---%@",dic);
                        DMLog(@"error---%@",dic[@"errorMsg"]);
                        if ([dic[@"errorCode"] intValue]==00000) {
                            [UIAlertView alertWithTitle:@"温馨提示" message:@"编辑商品信息成功" buttonTitle:nil];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        else
                        {
                            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                        }
                    }];
                }
            }
            else
            {
                if (![NSString isLogin]) {
                    [self loginUser];
                }
                else
                {
                    
                    DMLog(@"_bili......%@",_bili);
                    NSDictionary * param = @{@"name":nameTF.text,@"imgUrl":_nameImgUrl,@"imgList":_addImgArr,@"details":_describeTV.text,@"attrList":@"",@"categoryId":_cateID,@"price":_priceTF.text,@"barCode":@"",@"stock":_saveTF.text,@"returnBate":_bili};
                    [RequstEngine requestHttp:@"1036" paramDic:param  blockObject:^(NSDictionary *dic) {
                        DMLog(@"1036---%@",dic);
                        DMLog(@"error---%@",dic[@"errorMsg"]);
                        
                        if ([dic[@"errorCode"] intValue]==00000) {
                            //            [UIAlertView alertWithTitle:nil message:@"添加成功" buttonTitle:nil];
                            
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        else
                        {
                            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                        }
                        
                    }];
                    
                }
                
                
            }

//        }
//        else
//        {
//            [UIAlertView alertWithTitle:@"温馨提示" message:@"返币比例需在0-1之间" buttonTitle:nil];
//        }
    }
}

-(void)loginUser
{
    LoginViewController * loginVC=[[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}
-(void)editorGoodsRequste
{
    
   }

-(void)zhichiChange
{
    static int i=0;
    i++;
    if (i%2==1) {
        _biliTF.enabled=YES;
        [_zhichiBtn setBackgroundImage:[UIImage imageNamed:@"3-(2)选择_03"] forState:0];
    }
    else
    {
        _biliTF.enabled=NO;
        _biliTF.text=nil;
        _bili=@"0";
        [_zhichiBtn setBackgroundImage:[UIImage imageNamed:@"3-(2)选择_06"] forState:0];
    }
    
}

-(void)chooseBili:(UITextField*)textField
{
    _bili=textField.text;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
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
