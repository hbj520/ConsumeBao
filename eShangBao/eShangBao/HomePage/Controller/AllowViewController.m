//
//  AllowViewController.m
//  eShangBao
//
//  Created by doumee on 16/2/22.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "AllowViewController.h"

@interface AllowViewController ()<UIActionSheetDelegate,UIPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,uploadImageDelegate>
{
    NSMutableArray * _importItems;
    UIView * _coverView;
    UIButton * deleteBtn;//删除按钮
    BOOL _ischoose;
    
    NSString * _imgUrl;//图片地址
    TBActivityView * activityView;
}


@end

@implementation AllowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title=@"上传营业许可证";
    self.view.backgroundColor=BGMAINCOLOR;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    
    UIImageView * firstImg=[[UIImageView alloc]initWithFrame:CGRectMake(W(12), 64+H(10), WIDTH-W(12)*2, H(180))];
    firstImg.image=[UIImage imageNamed:@"许可证示意图.jpg"];
    firstImg.contentMode=0;
    [self.view addSubview:firstImg];
    
    _coverView=[[UIView alloc]initWithFrame:CGRectMake(W(12), kDown(firstImg)+H(10), WIDTH-W(12)*2, H(70))];
    _coverView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_coverView];
    
    _addButton=[UIButton buttonWithType:0];
    _addButton.frame=CGRectMake(W(12), H(10), W(50), H(50));
    _imgUrl=_licenseImg;
    if (_licenseImg.length==0) {
        [_addButton setImage:[UIImage imageNamed:@"camera"] forState:0];
    }
    else
    {
        [_addButton setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://115.29.246.75:8080/consumption/member/%@",_imgUrl]]]] forState:0];
    }
    
    [_addButton addTarget:self action:@selector(addImg) forControlEvents:1<<6];
    [_coverView addSubview:_addButton];
    
    //    UILabel * titilLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(_coverView)+H(10), W(150), H(20))];
    //    titilLabel.text=@"上传至少2张以上";
    //    titilLabel.textColor=GRAYCOLOR;
    //    titilLabel.font=[UIFont systemFontOfSize:16*KRatioH];
    //    [self.view addSubview:titilLabel];
    
    UILabel * detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(_coverView)+H(10), W(300), H(100))];
    detailLabel.textAlignment=NSTextAlignmentCenter;
    detailLabel.textColor=GRAYCOLOR;
    detailLabel.numberOfLines=4;
    detailLabel.text=@"请上传清晰完整的彩色原件扫描或者是数码照片，如是复印件请加盖公章，经营者姓名和用户姓名保持一致，确保信息完整清晰并真实有效";
    //    detailLabel.backgroundColor=[UIColor cyanColor];
    detailLabel.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:detailLabel];
    
    _uploadBtn=[UIButton buttonWithType:0];
    _uploadBtn.layer.cornerRadius=3;
    _uploadBtn.layer.masksToBounds=YES;
    _uploadBtn.frame=CGRectMake(W(20), kDown(_coverView)+H(160), WIDTH-W(20)*2, 40);
    _uploadBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    //    [_uploadBtn addTarget:self action:@selector(accomplish) forControlEvents:1<<6];
    [_uploadBtn setTitle:@"完成" forState:0];
    [_uploadBtn addTarget:self action:@selector(uploadImg) forControlEvents:1<<6];
    [_uploadBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:_uploadBtn];

    // Do any additional setup after loading the view.
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
        DMLog(@"1相册");
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
    [_addButton setImage:image forState:0];
    FTPUploadImage *uploadImage= [[FTPUploadImage alloc]init];
    uploadImage.delegate=self;
    [uploadImage FTPUploadImage:@"member" ImageData:image];
    
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    
    [activityView startAnimate];
    //    DMLog(@"headImg---%@",_imgUrl);
    //    imageView = [[UIImageView alloc] initWithImage:image];
    //    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    //    [self.view addSubview:imageView];
    
    //    [self performSelectorInBackground:@selector(detect:) withObject:nil];
}

-(void)uploadImageComplete:(NSString *)imageUrl
{
    if (imageUrl==nil) {
        
        DMLog(@"上传失败");
        [UIAlertView alertWithTitle:@"温馨提示" message:@"图片上传失败，请重新上传" buttonTitle:nil];
        [activityView stopAnimate];
    }else
    {
        
        DMLog(@"imgUrl---%@",imageUrl);
        [activityView stopAnimate];
        _imgUrl=imageUrl;
    }
}

#pragma mark - 按钮绑定的方法
-(void)addImg
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [actionSheet showInView:self.view];
    
}
//#pragma mark - 手势绑定的方法
//- (void)longPressToDo:(UILongPressGestureRecognizer*)recognizer
//{
//    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        DMLog(@"长按手势触发了");
//        //        UIButton * btn=(UIButton *)recognizer.view;
//
//        UIView * view=(UIView *)recognizer.view;
//
//        deleteBtn=[UIButton buttonWithType:0];
//        deleteBtn.frame=CGRectMake(W(40), 0, W(10), H(10));
//        deleteBtn.backgroundColor=[UIColor cyanColor];
//        deleteBtn.tag=view.tag;
//        [deleteBtn addTarget:self action:@selector(deletePicture:) forControlEvents:1<<6];
//        [view addSubview:deleteBtn];
//        [self start:view];
//    }
//
//}
//
//#pragma mark - 删除按钮绑定的方法
//-(void)deletePicture:(UIButton *)sender
//{
//    UIView * view=sender.superview;
//    DMLog(@"删除按钮触发了");
//    DMLog(@"%ld",sender.tag);
//    [self stop:view];
//
//    int i=0;
//    UIView * subViews=(UIView *)[_coverView viewWithTag:sender.tag];
//    [subViews removeFromSuperview];
//    [_assets removeObjectAtIndex:sender.tag-1];
//    //    _view=[[UIView alloc]initWithFrame:CGRectMake(W(10)+_assets.count*W(60), H(10), W(50), H(50))];
//
//    for (UIView * view in [_coverView subviews]) {
//        if ([view isKindOfClass:[_addButton class]]) {
//            continue;
//        }
//        view.frame=CGRectMake(W(10)+i*W(60), H(10), W(50), H(50));
//        view.tag=i+1;
//        i++;
//    }
//    _addButton.frame=CGRectMake(_assets.count*(W(60))+W(10), H(10), W(50), H(50));
//}

//#pragma mark - 长按开始抖动的方法
//-(void)start:(UIView *)view
//{
//    double angel1 = -5.0/180.0 *M_PI;
//    double angel2 =  5.0/180.0 *M_PI;
//    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
//    anim.keyPath = @"transform.rotation";
//    anim.values=@[@(angel1),@(angel2),@(angel1)];
//    anim.duration=0.25;
//    anim.repeatCount=MAXFLOAT;
//    anim.removedOnCompletion=NO;
//    anim.fillMode=kCAFillModeBackwards;
//    [view.layer addAnimation:anim forKey:@"shake"];
//}

//-(void)stop:(UIView*)view
//{
//    [view.layer removeAnimationForKey:@"shake"];
//}

#pragma mark - 上传图片按钮绑定的方法
-(void)uploadImg
{
    NSDictionary * dic=@{@"imgUrl":_imgUrl};
    _block(dic);
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
