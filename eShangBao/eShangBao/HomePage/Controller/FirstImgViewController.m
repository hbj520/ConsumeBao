
//
//  FirstImgViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/15.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "FirstImgViewController.h"
#import "MHImagePickerMutilSelector.h"
#import "CTAssetsPickerController.h"
@interface FirstImgViewController ()<UIActionSheetDelegate,UIPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MHImagePickerMutilSelectorDelegate,CTAssetsPickerControllerDelegate,uploadImageDelegate>
{
    NSData *_data1;// 身份证正面照
    NSData *_data2;// 手持身份证正面照
    NSString *_fileName1;// 身份证正面照的文件名
    NSString *_fileName2;// 手持身份证正面照的文件名
    NSMutableArray * _importItems;//导入的图片数组
    UIView * _coverView;
    UIButton * deleteBtn;//删除按钮
    
    BOOL _ischoose;
    UIView * _view;
    
    UIImageView * firstImg;
    UILabel * titilLabel;
    UILabel * detailLabel;
    NSMutableArray * _imgArr;//图片数组
    NSString * _doorImgUrl;
    TBActivityView * activityView;
    
}

@end

@implementation FirstImgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    _ischoose=NO;
    self.title=@"上传门店首图";
    self.assets = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor=BGMAINCOLOR;
    _imgArr=[NSMutableArray arrayWithCapacity:0];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    
    firstImg=[[UIImageView alloc]initWithFrame:CGRectMake(W(12), 64+H(10), WIDTH-W(12)*2, H(140))];
    firstImg.image=[UIImage imageNamed:@"2.jpg"];
    firstImg.contentMode=0;
    [self.view addSubview:firstImg];
    
    _coverView=[[UIView alloc]initWithFrame:CGRectMake(W(12), kDown(firstImg)+H(10), WIDTH-W(12)*2, H(70))];
    _coverView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_coverView];
    
    _addButton=[UIButton buttonWithType:0];
    _addButton.frame=CGRectMake(W(12), H(10), W(40), H(40));
    [_addButton setImage:[UIImage imageNamed:@"camera"] forState:0];
    _doorImgUrl=_doorImg;
    if (_doorImg.length==0) {
        [_addButton setImage:[UIImage imageNamed:@"camera"] forState:0];
    }
    else
    {
        [_addButton setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://115.29.246.75:8080/consumption/member/%@",_doorImg]]]] forState:0];
    }

    [_addButton addTarget:self action:@selector(addImg) forControlEvents:1<<6];
    [_coverView addSubview:_addButton];
    
//    titilLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(_coverView)+H(10), W(150), H(20))];
//    titilLabel.text=@"上传至少2张以上";
//    titilLabel.textColor=GRAYCOLOR;
//    titilLabel.font=[UIFont systemFontOfSize:16*KRatioH];
//    [self.view addSubview:titilLabel];
    
    detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(_coverView), W(300), H(60))];
    detailLabel.textColor=GRAYCOLOR;
    detailLabel.numberOfLines=2;
    detailLabel.text=@"为了顾客能够更多了解店铺，建议上传图片尺寸在2000*1500以上的优质菜品和图片";
//    detailLabel.backgroundColor=[UIColor cyanColor];
    detailLabel.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:detailLabel];
    
    
    _uploadBtn=[UIButton buttonWithType:0];
    _uploadBtn.layer.cornerRadius=3;
    _uploadBtn.layer.masksToBounds=YES;
    _uploadBtn.frame=CGRectMake(W(20), kDown(_coverView)+H(180), WIDTH-W(20)*2, H(40));
    _uploadBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
//    [_uploadBtn addTarget:self action:@selector(accomplish) forControlEvents:1<<6];
    [_uploadBtn setTitle:@"上传图片" forState:0];
    [_uploadBtn addTarget:self action:@selector(uploadImg) forControlEvents:1<<6];
    [_uploadBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:_uploadBtn];
    // Do any additional setup after loading the view from its nib.
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
        //        NSLog(@"1相册");
//        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//        imagePicker.delegate = self;
//        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//        imagePicker.allowsEditing = YES;
//        [self presentViewController:imagePicker animated:YES completion:nil];
//            MHImagePickerMutilSelector* imagePickerMutilSelector=[MHImagePickerMutilSelector standardSelector];//自动释放
//            imagePickerMutilSelector.delegate=self;//设置代理
//        
//            UIImagePickerController* picker=[[UIImagePickerController alloc] init];
//            picker.delegate=imagePickerMutilSelector;//将UIImagePicker的代理指向到imagePickerMutilSelector
//            [picker setAllowsEditing:NO];
//            picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
//            picker.modalTransitionStyle= UIModalTransitionStyleCoverVertical;
//            picker.navigationController.delegate=imagePickerMutilSelector;//将UIImagePicker的导航代理指向到imagePickerMutilSelector
//        
//            imagePickerMutilSelector.imagePicker=picker;//使imagePickerMutilSelector得知其控制的UIImagePicker实例，为释放时需要。
//            
//            [self presentModalViewController:picker animated:YES];
//        if (!self.assets)
//            self.assets = [[NSMutableArray alloc] init];
//        
//        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
//        picker.maximumNumberOfSelection = 10;
//        picker.assetsFilter = [ALAssetsFilter allAssets];
//        picker.delegate = self;
//        
//        [self presentViewController:picker animated:YES completion:NULL];
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


#pragma mark - Assets Picker Delegate

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    
    [self.assets addObjectsFromArray:assets];
    _coverView.frame=CGRectMake(W(12), kDown(firstImg)+H(10), WIDTH-W(12)*2, H(70)+H(60)*(assets.count/5));
    titilLabel.frame=CGRectMake(W(12), kDown(_coverView)+H(10), W(150), H(20));
    detailLabel.frame=CGRectMake(W(12), kDown(titilLabel), W(300), H(60));
    for (int i=0; i<_assets.count; i++) {
         ALAsset *asset = [self.assets objectAtIndex:i];
        
        
        _view=[[UIView alloc]initWithFrame:CGRectMake(W(10)+(i%5)*W(60), (i/5)*H(60)+H(10), W(40), H(50))];
//        view.backgroundColor=[UIColor cyanColor];
        _view.tag=i+1;
        [_coverView addSubview:_view];
        
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, W(40), H(50))];
        img.contentMode=3;
        img.image = [UIImage imageWithCGImage:asset.thumbnail];
        [_view addSubview:img];
        
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGR.minimumPressDuration = 1.0;
        [_view addGestureRecognizer:longPressGR];
        
        FTPUploadImage *uploadImage= [[FTPUploadImage alloc]init];
        uploadImage.delegate=self;
        [uploadImage FTPUploadImage:@"member" ImageData:[UIImage imageWithCGImage:asset.thumbnail]];

    }
    
    _addButton.frame=CGRectMake(_assets.count*(W(60))+W(10), H(10), W(40), H(50));

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

//    for (UIView * view in [_coverView subviews]) {
//        if ([view isKindOfClass:[_addButton class]]) {
//            continue;
//        }
//        else
//        {
//            [view removeFromSuperview];
//        }
//    }
//    FTPUploadImage *uploadImage= [[FTPUploadImage alloc]init];
//    uploadImage.delegate=self;
//    [uploadImage FTPUploadImage:@"member" ImageData:image];
//    DMLog(@"image%@",image);
//    _coverView.frame=CGRectMake(W(12), kDown(firstImg)+H(10), WIDTH-W(12)*2, H(70)+H(60)*(_assets.count/5));
//    titilLabel.frame=CGRectMake(W(12), kDown(_coverView)+H(10), W(150), H(20));
//    detailLabel.frame=CGRectMake(W(12), kDown(titilLabel), W(300), H(60));
//    [self.assets addObject:image];
//    DMLog(@"----%d",self.assets.count);
//    for (int i=0; i<_assets.count; i++) {
////        ALAsset *asset = [self.assets objectAtIndex:i];
//        
//        
//        _view=[[UIView alloc]initWithFrame:CGRectMake(W(10)+(i%5)*W(60), (i/5)*H(60)+H(10), W(40), H(50))];
//        //        view.backgroundColor=[UIColor cyanColor];
//        _view.tag=i+1;
//        [_coverView addSubview:_view];
//        
//        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, W(40), H(50))];
//        img.contentMode=3;
//        img.image = _assets[i];
//        [_view addSubview:img];
//        
//        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
//        longPressGR.minimumPressDuration = 1.0;
//        [_view addGestureRecognizer:longPressGR];
//        
//    }
//
//     _addButton.frame=CGRectMake(_assets.count*(W(60))+W(10), H(10), W(40), H(50));

}

#pragma mark - uploadImage
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
        _doorImgUrl=imageUrl;
    }
}
- (NSArray *)indexPathOfNewlyAddedAssets:(NSArray *)assets
{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    for (NSInteger i = self.assets.count; i < self.assets.count + assets.count ; i++)
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    
    return indexPaths;
}

-(void)imagePickerMutilSelectorDidGetImages:(NSArray *)imageArray
{
    _importItems=[[NSMutableArray alloc] initWithArray:imageArray copyItems:YES];
    DMLog(@"%@",_importItems);
    for (int i=0; i<_importItems.count; i++) {
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(W(50)+i*W(50), H(10), W(50), H(50))];
        img.image=[UIImage imageWithContentsOfFile:_importItems[i]];
        [_coverView addSubview:img];
    }
}


#pragma mark - 按钮绑定的方法
-(void)addImg
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [actionSheet showInView:self.view];
    

}
#pragma mark - 手势绑定的方法
- (void)longPressToDo:(UILongPressGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        DMLog(@"长按手势触发了");
//        UIButton * btn=(UIButton *)recognizer.view;
        
        UIView * view=(UIView *)recognizer.view;
//        DMLog(@"view.tag=%ld",view.tag);
        deleteBtn=[UIButton buttonWithType:0];
        deleteBtn.frame=CGRectMake(W(30), 0, W(10), H(10));
        deleteBtn.backgroundColor=[UIColor cyanColor];
        deleteBtn.tag=view.tag;
        [deleteBtn addTarget:self action:@selector(deletePicture:) forControlEvents:1<<6];
        [view addSubview:deleteBtn];
        [self start:view];
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
    [_imgArr removeObjectAtIndex:sender.tag-1];
    DMLog(@"imgarr-----%@",_imgArr);
//    _view=[[UIView alloc]initWithFrame:CGRectMake(W(10)+_assets.count*W(60), H(10), W(50), H(50))];
    
    for (UIView * view in [_coverView subviews]) {
        if ([view isKindOfClass:[_addButton class]]) {
            continue;
        }
        view.frame=CGRectMake(W(10)+i*W(60), H(10), W(40), H(50));
        view.tag=i+1;
        i++;
    }
//    DMLog(@"---%ld",_assets.count);
    _addButton.frame=CGRectMake(_assets.count*(W(60))+W(10), H(10), W(40), H(50));
   
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

#pragma mark - 上传图片按钮绑定的方法
-(void)uploadImg
{
    DMLog(@"上传图片");
    NSDictionary * dict=@{@"imgArr":_doorImgUrl};
    _block(dict);
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
