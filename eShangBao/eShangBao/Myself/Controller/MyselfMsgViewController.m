//
//  MyselfMsgViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/19.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "MyselfMsgViewController.h"
#import "HeadImgTableViewCell.h"
#import "CTAssetsPickerController.h"
#import "NicknameViewController.h"
#import "NumberTableViewCell.h"
#import "DeliveryAddressViewController.h"
#import "MemberTableViewCell.h"
#import "VIPlevelViewController.h"
#import "CheckID.h"
#import "BoundViewController.h"
#import "ChangeNumberViewController.h"
@interface MyselfMsgViewController ()<UITableViewDataSource,UITableViewDelegate,CTAssetsPickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,uploadImageDelegate>
{
    UITableView * _tableView;
    NSMutableArray * _importItems;//导入的图片数组
    NSString * _nickName;
    NSString * _idNumber;//身份证号
    NSString * _address;//地址
    NSString * _levelName;//等级名称
    NSString * _phone;//手机号
    NSString * _imgUrl;//头像图片
    NSString * _level;
    NSString * _currentLevelFee;//当前等级的加盟价格
    NSString * _isCanUpgrade;
    NSString * _partnerAgencyPayStatus;//付款状态
    NSString * _userType;
    int _choose;//是否选择了图片
    
//    NSData * _imageData;//从系统相册中选取的图片
    
//    NSString * _nickName;//昵称
}

@end

@implementation MyselfMsgViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    _choose=0;
    
//    _address=@"";
    [self getMerchist];
//    _isCanUpgrade=YES;
   //    _levelName=[[NSUserDefaults standardUserDefaults]objectForKey:@"levelName"];
//    _headImage=[UIImage imageNamed:@"头像"];
    self.title=@"我的信息";
    self.view.backgroundColor=BGMAINCOLOR;
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:0];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=0;
    _tableView.scrollEnabled=NO;
    [self.view addSubview:_tableView];
    
    _saveBtn=[UIButton buttonWithType:0];
    _saveBtn.frame=CGRectMake(0, 0, W(40), 40);
    [_saveBtn setImage:[UIImage imageNamed:@"saveAddress"] forState:0];
    [_saveBtn addTarget:self action:@selector(saveMsg) forControlEvents:1<<6];
    UIBarButtonItem * rightBtn=[[UIBarButtonItem alloc]initWithCustomView:_saveBtn];
    self.navigationItem.rightBarButtonItem=rightBtn;
    
    
    // Do any additional setup after loading the view.
}

-(void)getMerchist
{
    NSDictionary * param=@{@"memberId":USERID};
    [RequstEngine requestHttp:@"1003" paramDic:param blockObject:^(NSDictionary *dic) {
        DMLog(@"1003--%@",dic);
        if ([dic[@"errorCode"] intValue]==0) {
            //        _levelName=dic[@"member"][@"parterLevel"];
            _nickName=dic[@"member"][@"name"];
            _address=dic[@"member"][@"addr"];
            _phone=dic[@"member"][@"phone"];
            _idNumber=dic[@"member"][@"idcardno"];
            _imgUrl=dic[@"member"][@"imgUrl"];
            _headImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_imgUrl]]];
            _levelName=dic[@"member"][@"levelName"];
            _level=dic[@"member"][@"parterLevel"];
            _currentLevelFee=dic[@"member"][@"currentLevelFee"];
            _isCanUpgrade=dic[@"member"][@"isCanUpgrade"];
            _partnerAgencyPayStatus=dic[@"member"][@"partnerAgencyPayStatus"];
            _userType=dic[@"member"][@"type"];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"member"][@"type"] forKey:@"userType"];
            [_tableView reloadData];

        }
        else
        {
            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
        }
                DMLog(@"error--%@",dic[@"errorMsg"]);
    }];

    
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 3;
    }
    else if (section==1)
    {
        return 2;
    }
    else
    {
        if ([_partnerAgencyPayStatus intValue]==0) {
            return 1;
        }
        else
        {
            return 3;
        }
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            HeadImgTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[HeadImgTableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell"];
            }
            if (_imgUrl.length==0) {
                cell.headImg.image=[UIImage imageNamed:@"头像"];
            }
            else
            {
//                _headImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_imgUrl]]];
                cell.headImg.image=_headImage;
            }
//            [cell.headImg setImageWithURLString:_imgUrl placeholderImage:@"头像"];
            cell.titleLabel.textColor=RGBACOLOR(63, 62, 62, 1);
            cell.selectionStyle=0;
            return cell;

        }
        else if (indexPath.row==1)
        {
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell1"];
            }
            cell.textLabel.text=@"姓名";
            cell.textLabel.font=[UIFont systemFontOfSize:14];
            cell.textLabel.textColor=RGBACOLOR(63, 62, 62, 1);
            cell.detailTextLabel.text=_nickName;
            cell.selectionStyle=0;
            cell.accessoryType=1;
            cell.detailTextLabel.font=[UIFont systemFontOfSize:14];
            UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
            lineLabel.backgroundColor=BGMAINCOLOR;
            [cell.contentView addSubview:lineLabel];
            return cell;
        }
        else
        {
            NumberTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
            if (!cell) {
                cell = [[NumberTableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell2"];
            }
            cell.numberLabel.text=@"地址";
            cell.numberLabel.font=[UIFont systemFontOfSize:14];
            cell.textLabel.textColor=RGBACOLOR(63, 62, 62, 1);
//            cell.numberTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入地区" attributes:@{NSForegroundColorAttributeName:GRAYCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:28/2*KRatioH]}];
            cell.numberTF.textAlignment=NSTextAlignmentRight;
            cell.numberTF.delegate=self;
            cell.numberTF.placeholder=@"请输入地址";
            if (_address.length==0) {
                cell.numberTF.text=nil;
            }
            else
            {
                cell.numberTF.text=_address;
            }
            
            [cell.numberTF addTarget:self action:@selector(chooseAddr:) forControlEvents:1<<17];
//            [_tableView reloadData];
            cell.selectionStyle=0;
            UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
            lineLabel.backgroundColor=BGMAINCOLOR;
            [cell.contentView addSubview:lineLabel];

            return cell;
        }
    }
    else if (indexPath.section==1)
    {
        if (indexPath.row==0) {
            MemberTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell5"];
            if (!cell) {
                cell = [[MemberTableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell5"];
            }
            cell.selectionStyle=0;
//            cell.levelLabel.text=_levelName;
            
            if (_phone.length==0) {
                cell.levelLabel.text=@"";
            }
            else
            {
                cell.levelLabel.text=_phone;
            }

            //            if ([_levelName isEqualToString:@"pl01"]) {
            //                cell.levelLabel.text=@"银商合伙人";
            //            }
            //            else if ([_levelName isEqualToString:@"pl02"]) {
            //                 cell.levelLabel.text=@"金商合伙人";
            //            }
            //            else if ([_levelName isEqualToString:@"pl03"])
            //            {
            //                cell.levelLabel.text=@"钻商合伙人";
            //            }
            
            
            cell.levelLabel.font=[UIFont systemFontOfSize:14];
            [cell.improveBtn setTitle:@"更换" forState:0];
            cell.titleLabel.text=@"手机号";
            [cell.improveBtn addTarget:self action:@selector(changeTelephoneNumber) forControlEvents:1<<6];
            //            cell.detailTextLabel.text=@"yanguoqiang";
            UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
            lineLabel.backgroundColor=BGMAINCOLOR;
            [cell.contentView addSubview:lineLabel];
            
            return cell;
        }
        else
        {
            NumberTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell3"];
            if (!cell) {
                cell = [[NumberTableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell3"];
            }
//            if (indexPath.row==0) {
//                cell.numberLabel.text=@"手机号";
//                cell.numberLabel.font=[UIFont systemFontOfSize:14];
//                cell.numberTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入执照编号/名称" attributes:@{NSForegroundColorAttributeName:GRAYCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:28/2]}];
//                cell.numberLabel.textColor=RGBACOLOR(63, 62, 62, 1);
//                if (_phone.length==0) {
//                    cell.numberTF.text=nil;
//                }
//                else
//                {
//                    cell.numberTF.text=_phone;
//                }
//                cell.numberTF.textAlignment=NSTextAlignmentRight;
//                [cell.numberTF addTarget:self action:@selector(choosePhone:) forControlEvents:1<<17];
//                cell.numberTF.delegate=self;
//                cell.numberTF.tag=10;
//                cell.numberTF.enabled=NO;
//                cell.numberTF.placeholder=@"请输入手机号";
//            }
//            else
//            {
                cell.numberLabel.text=@"身份证号";
                cell.numberLabel.font=[UIFont systemFontOfSize:14];
                cell.numberLabel.textColor=RGBACOLOR(63, 62, 62, 1);
                if (_idNumber.length==0) {
                    cell.numberTF.text=nil;
                }
                else
                {
                    cell.numberTF.text=_idNumber;
                }
                cell.numberTF.textAlignment=NSTextAlignmentRight;
                [cell.numberTF addTarget:self action:@selector(chooseID:) forControlEvents:1<<17];
                cell.numberTF.delegate=self;
                cell.numberTF.tag=11;
                //            cell.numberTF.enabled=NO;
                cell.numberTF.placeholder=@"请输入身份证号";
                _idNumber=cell.numberTF.text;
                //            [_tableView reloadData];
//            }
            //        cell.textLabel.text=@"ygq";
            //        cell.detailTextLabel.text=@"yanguoqiang";
            cell.selectionStyle=0;
            UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
            lineLabel.backgroundColor=BGMAINCOLOR;
            [cell.contentView addSubview:lineLabel];
            
            return cell;

        }
    }
    else
    {
        if ([_partnerAgencyPayStatus intValue]==0) {
            
                UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell4"];
                if (!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell4"];
                }
                cell.textLabel.text=@"收货地址";
                cell.textLabel.font=[UIFont systemFontOfSize:14];
                cell.textLabel.textColor=RGBACOLOR(63, 62, 62, 1);
                cell.selectionStyle=0;
                cell.accessoryType=1;
                UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
                lineLabel.backgroundColor=BGMAINCOLOR;
                [cell.contentView addSubview:lineLabel];
                
                //            cell.detailTextLabel.text=@"yanguoqiang";
                return cell;
           
            

        }
        else
        {
            if (indexPath.row==0) {
                UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell4"];
                if (!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell4"];
                }
                cell.textLabel.text=@"收货地址";
                cell.textLabel.font=[UIFont systemFontOfSize:14];
                cell.textLabel.textColor=RGBACOLOR(63, 62, 62, 1);
                cell.selectionStyle=0;
                cell.accessoryType=1;
                UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
                lineLabel.backgroundColor=BGMAINCOLOR;
                [cell.contentView addSubview:lineLabel];
                
                //            cell.detailTextLabel.text=@"yanguoqiang";
                return cell;
            }
            else if (indexPath.row==1)
            {
                MemberTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell5"];
                if (!cell) {
                    cell = [[MemberTableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell5"];
                }
                cell.selectionStyle=0;
                cell.levelLabel.text=_levelName;
                //            if ([_levelName isEqualToString:@"pl01"]) {
                //                cell.levelLabel.text=@"银商合伙人";
                //            }
                //            else if ([_levelName isEqualToString:@"pl02"]) {
                //                 cell.levelLabel.text=@"金商合伙人";
                //            }
                //            else if ([_levelName isEqualToString:@"pl03"])
                //            {
                //                cell.levelLabel.text=@"钻商合伙人";
                //            }
                
                
                cell.levelLabel.font=[UIFont systemFontOfSize:14];
                [cell.improveBtn setTitle:@"升级" forState:0];
                cell.titleLabel.text=@"会员级别";
                [cell.improveBtn addTarget:self action:@selector(improveLevel) forControlEvents:1<<6];
                //            cell.detailTextLabel.text=@"yanguoqiang";
                UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
                lineLabel.backgroundColor=BGMAINCOLOR;
                [cell.contentView addSubview:lineLabel];
                
                return cell;
                
            }
            else
            {
                UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell5"];
                if (!cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell5"];
                }
                cell.textLabel.text=@"会员卡";
                cell.textLabel.font=[UIFont systemFontOfSize:14];
                cell.textLabel.textColor=RGBACOLOR(63, 62, 62, 1);
                cell.selectionStyle=0;
                //            cell.detailTextLabel.text=@"yanguoqiang";
                cell.accessoryType=1;
                UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
                lineLabel.backgroundColor=BGMAINCOLOR;
                [cell.contentView addSubview:lineLabel];
                
                return cell;
            }

        }
        
       
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return H(10);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0&&indexPath.row==0) {
        return H(55);
    }
    else
    {
        return H(44);
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==0) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [actionSheet showInView:self.view];
        if (!self.assets)
            self.assets = [[NSMutableArray alloc] init];
        
    }
    if (indexPath.section==0&&indexPath.row==1) {
        UITableViewCell * cell=[tableView cellForRowAtIndexPath:indexPath];
        NicknameViewController * nicknameVC=[[NicknameViewController alloc]init];
        [nicknameVC setBlock:^(NSDictionary *dict) {
            _nickName=dict[@"nickName"];
            [_tableView reloadData];
        }];
        nicknameVC.nickName=cell.detailTextLabel.text;
        [self.navigationController pushViewController:nicknameVC animated:YES];
    }
    if (indexPath.section==2&&indexPath.row==0) {
        DeliveryAddressViewController * deliveryVC=[[DeliveryAddressViewController alloc]init];
        [self.navigationController pushViewController:deliveryVC animated:YES];
    }
    if (indexPath.section==2&&indexPath.row==2) {
        DMLog(@"会员卡");
        _coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _coverView.backgroundColor=[UIColor grayColor];
        _coverView.alpha=0.5;
        [self.view addSubview:_coverView];
        
        UITapGestureRecognizer *tapPressGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo)];
//        tapPressGR.minimumPressDuration = 1.0;
        [_coverView addGestureRecognizer:tapPressGR];
        
        _vipImg=[[UIImageView alloc]initWithFrame:CGRectMake(W(30), H(105)+64, WIDTH-W(30)*2, H(170))];
        _vipImg.image=[UIImage imageNamed:@"vip_card"];
        _vipImg.contentMode=2;
        [self.view addSubview:_vipImg];
        
        _levelLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(100), H(170)+64, W(120), H(20))];
        _levelLabel.text=_levelName;
        _levelLabel.textColor=RGBACOLOR(247, 95, 12, 1);
        _levelLabel.font=[UIFont systemFontOfSize:20];
        [self.view addSubview:_levelLabel];
        
        _inviteCodeLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(195), H(123)+64, W(100), H(20))];
        _inviteCodeLabel.text=[NSString stringWithFormat:@"N0.%@",INVITE];
        _inviteCodeLabel.textColor=[UIColor whiteColor];
        _inviteCodeLabel.font=[UIFont boldSystemFontOfSize:16*KRatioH];
        [self.view addSubview:_inviteCodeLabel];
    }
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
    _choose=1;
    _headImage=image;
    [_tableView reloadData];
    
    FTPUploadImage *uploadImage= [[FTPUploadImage alloc]init];
    uploadImage.delegate=self;
    [uploadImage FTPUploadImage:@"member" ImageData:image];
//    DMLog(@"headImg---%@",_imgUrl);
//    imageView = [[UIImageView alloc] initWithImage:image];
//    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//    [self.view addSubview:imageView];
    
//    [self performSelectorInBackground:@selector(detect:) withObject:nil];
}
//detect为自己定义的方法，编辑选取照片后要实现的效果
//取消选择：


-(void)uploadImageComplete:(NSString *)imageUrl
{
    if (imageUrl==nil) {
        
        DMLog(@"上传失败");
    }else
    {
        
        DMLog(@"imgUrl---%@",imageUrl);
        _imgUrl=imageUrl;
        [_tableView reloadData];
    }
}


-(void)imagePickerControllerDIdCancel:(UIImagePickerController*)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}


#pragma mark - Assets Picker Delegate

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    
    [self.assets addObjectsFromArray:assets];
    
    
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==11) {
        [UIView animateWithDuration:0.26 animations:^{
            self.view.frame=CGRectMake(0, -60, WIDTH, HEIGHT);
        }];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==10) {
        if (textField.text.length>0) {
            
            NSString *CM = @"^[0-9]{1,11}$";
            NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
            BOOL isNum = [regextestcm evaluateWithObject:textField.text];
            DMLog(@"888%d",isNum);
            if (isNum)
            {
                if (textField.text.length<11) {
                    [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入11位手机号" buttonTitle:nil];
                }
                else
                {
                    NSString *regex = @"^1(3[0-9]|5[0-35-9]|8[0-9])\\d{8}$";
                    
                    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                    
                    BOOL isMatch = [pred evaluateWithObject:textField.text];
                    
                    if (!isMatch) {
                        
                        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入正确的手机号" buttonTitle:nil];
                        //            return NO;
                        
                    }
                    else
                    {
                        _phone=textField.text;
                    }
                    
                }
                
            }else
            {
                //            [self.view endEditing:YES];
                [UIAlertView alertWithTitle:@"温馨提示" message:@"手机号仅限数字" buttonTitle:nil];
                
            }
            
        }
    }
    else if (textField.tag==11) {
        
        [UIView animateWithDuration:0.26 animations:^{
            self.view.frame=CGRectMake(0, 0, WIDTH, HEIGHT);
        }];
        
        if (textField.text.length>0) {
//            NSString *CM = @"^[0-9xX]{1,18}$";
//            NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
            BOOL isNum = [CheckID verifyIDCardNumber:textField.text];
            DMLog(@"888%d",isNum);
            if (isNum)
            {
                if (textField.text.length<18) {
                    [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入18位身份证号" buttonTitle:nil];
                }
                
            }else
            {
                //            [self.view endEditing:YES];
                [UIAlertView alertWithTitle:@"温馨提示" message:@"身份证号格式不正确或不存在该身份证" buttonTitle:nil];
                
            }
            
        }

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
    
}

//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
////    [_tableView reloadData];
//}
#pragma mark - 按钮绑定的方法
-(void)saveMsg
{
//    [_tableView reloadData];
    
    BOOL isNum = [CheckID verifyIDCardNumber:_idNumber];
    DMLog(@"888%d",isNum);
    if (isNum)
    {
        
        DMLog(@"保存信息");
        if (_imgUrl.length==0) {
            if (_choose==0) {
                
                NSDictionary * param=@{@"memberId":USERID,@"name":_nickName,@"sex":@"2",@"birthday":@"",@"qq":@"",@"email":@"",@"cityId":@"",@"addr":_address,@"idCardNo":_idNumber};
                
                [RequstEngine requestHttp:@"1004" paramDic:param blockObject:^(NSDictionary *dic) {
                    
                    DMLog(@"1004--%@",dic);
                    
                    DMLog(@"error---%@",dic[@"errorMsg"]);
                    
                    if ([dic[@"errorCode"] intValue]==00000) {
                        [self.view endEditing:YES];
                        //                    [UIAlertView alertWithTitle:@"温馨提示" message:@"更改信息成功" buttonTitle:nil ];
                        [self performSelector:@selector(alertViewAppear) withObject:nil afterDelay:0];
                        
                    }
                    else
                        
                    {
                        [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                        
                    }
                    
                }];
            }
            else
            {
                NSDictionary * param=@{@"memberId":USERID,@"name":_nickName,@"imgUrl":_imgUrl,@"sex":@"2",@"birthday":@"",@"qq":@"",@"email":@"",@"cityId":@"",@"addr":_address,@"idCardNo":_idNumber};
                
                [RequstEngine requestHttp:@"1004" paramDic:param blockObject:^(NSDictionary *dic) {
                    
                    DMLog(@"1004--%@",dic);
                    DMLog(@"error---%@",dic[@"errorMsg"]);
                    if ([dic[@"errorCode"] intValue]==00000) {
                        [self.view endEditing:YES];
                        //                    [UIAlertView alertWithTitle:@"温馨提示" message:@"更改信息成功" buttonTitle:nil];
                        [self performSelector:@selector(alertViewAppear) withObject:nil afterDelay:0];
                        //                    [UIAlertView alertWithTitle:@"温馨提示" message:@"更改信息成功" buttonTitle:nil UIController:self];
                        //                    [self.navigationController popViewControllerAnimated:YES];
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
            if (_idNumber.length==0) {
                if (_choose==0) {
                    
                    NSDictionary * param=@{@"memberId":USERID,@"name":_nickName,@"sex":@"2",@"birthday":@"",@"qq":@"",@"email":@"",@"cityId":@"",@"addr":_address,@"idCardNo":_idNumber};
                    
                    [RequstEngine requestHttp:@"1004" paramDic:param blockObject:^(NSDictionary *dic) {
                        
                        DMLog(@"1004--%@",dic);
                        
                        DMLog(@"error---%@",dic[@"errorMsg"]);
                        
                        if ([dic[@"errorCode"] intValue]==00000) {
                            [self.view endEditing:YES];
                            //                    [UIAlertView alertWithTitle:@"温馨提示" message:@"更改信息成功" buttonTitle:nil ];
                            [self performSelector:@selector(alertViewAppear) withObject:nil afterDelay:0];
                            
                        }
                        else
                            
                        {
                            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                            
                        }
                        
                    }];
                }
                else
                {
                    NSDictionary * param=@{@"memberId":USERID,@"name":_nickName,@"imgUrl":_imgUrl,@"sex":@"2",@"birthday":@"",@"qq":@"",@"email":@"",@"cityId":@"",@"addr":_address,@"idCardNo":_idNumber};
                    
                    [RequstEngine requestHttp:@"1004" paramDic:param blockObject:^(NSDictionary *dic) {
                        
                        DMLog(@"1004--%@",dic);
                        DMLog(@"error---%@",dic[@"errorMsg"]);
                        if ([dic[@"errorCode"] intValue]==00000) {
                            [self.view endEditing:YES];
                            //                    [UIAlertView alertWithTitle:@"温馨提示" message:@"更改信息成功" buttonTitle:nil];
                            [self performSelector:@selector(alertViewAppear) withObject:nil afterDelay:0];
                            //                    [UIAlertView alertWithTitle:@"温馨提示" message:@"更改信息成功" buttonTitle:nil UIController:self];
                            //                    [self.navigationController popViewControllerAnimated:YES];
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
                //            BOOL isNum=[CheckID verifyIDCardNumber:_idNumber];
                //            if (isNum) {
                if (_choose==0) {
                    
                    NSDictionary * param=@{@"memberId":USERID,@"name":_nickName,@"sex":@"2",@"birthday":@"",@"qq":@"",@"email":@"",@"cityId":@"",@"addr":_address,@"idCardNo":_idNumber};
                    
                    [RequstEngine requestHttp:@"1004" paramDic:param blockObject:^(NSDictionary *dic) {
                        
                        DMLog(@"1004--%@",dic);
                        
                        DMLog(@"error---%@",dic[@"errorMsg"]);
                        
                        if ([dic[@"errorCode"] intValue]==00000) {
                            [self.view endEditing:YES];
                            //                        [UIAlertView alertWithTitle:@"温馨提示" message:@"更改信息成功" buttonTitle:nil];
                            [self performSelector:@selector(alertViewAppear) withObject:nil afterDelay:0];
                            //                        [UIAlertView alertWithTitle:@"温馨提示" message:@"更改信息成功" buttonTitle:nil UIController:self];
                            //                        [self.navigationController popViewControllerAnimated:YES];
                        }
                        else
                            
                        {
                            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                            
                        }
                        
                    }];
                }
                else
                {
                    NSDictionary * param=@{@"memberId":USERID,@"name":_nickName,@"imgUrl":_imgUrl,@"sex":@"2",@"birthday":@"",@"qq":@"",@"email":@"",@"cityId":@"",@"addr":_address,@"idCardNo":_idNumber};
                    
                    [RequstEngine requestHttp:@"1004" paramDic:param blockObject:^(NSDictionary *dic) {
                        
                        DMLog(@"1004--%@",dic);
                        DMLog(@"error---%@",dic[@"errorMsg"]);
                        if ([dic[@"errorCode"] intValue]==00000) {
                            [self.view endEditing:YES];
                            //                        [UIAlertView alertWithTitle:@"温馨提示" message:@"更改信息成功" buttonTitle:nil];
                            [self performSelector:@selector(alertViewAppear) withObject:nil afterDelay:0];
                            //                        [UIAlertView alertWithTitle:@"温馨提示" message:@"更改信息成功" buttonTitle:nil UIController:self];
                            //                        [self.navigationController popViewControllerAnimated:YES];
                        }
                        else
                        {
                            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                            
                        }
                        
                    }];
                }
                
                //            }
                //            else
                //            {
                //                [UIAlertView alertWithTitle:@"温馨提示" message:@"身份证号格式不正确或不存在该身份证" buttonTitle:nil];
                //            }
            }
            
        }
        
        //    DMLog(@"---%@,%@,%@,%@,%@",_nickName,_idNumber,_address,_headImage,[_imgUrl substringFromIndex:47]);
        
        
        
        
        
        
        //    if (_nickName.length==0) {
        //        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入昵称" buttonTitle:nil];
        //    }
        //    else
        //    {
        //        if (_idNumber.length==0) {
        //
        //            if (_phone==0) {
        //                if (_choose==0) {
        //                    NSDictionary * param=@{@"memberId":USERID,@"name":_nickName,@"imgUrl":[_imgUrl substringFromIndex:47],@"sex":@"2",@"birthday":@"",@"qq":@"",@"email":@"",@"cityId":@"",@"addr":_address,@"idCardNo":_idNumber};
        //                    [RequstEngine requestHttp:@"1004" paramDic:param blockObject:^(NSDictionary *dic) {
        //                        DMLog(@"1004--%@",dic);
        //                        DMLog(@"error---%@",dic[@"errorMsg"]);
        //                        if ([dic[@"errorCode"] intValue]==00000) {
        //                            [UIAlertView alertWithTitle:@"温馨提示" message:@"更改信息成功" buttonTitle:nil];
        //                            [self.navigationController popViewControllerAnimated:YES];
        //                        }
        //                        else
        //                        {
        //                            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
        //
        //                        }
        //
        //                    }];
        //
        //                }
        //                else
        //                {
        //                    NSDictionary * param=@{@"memberId":USERID,@"name":_nickName,@"imgUrl":_imgUrl,@"sex":@"2",@"birthday":@"",@"qq":@"",@"email":@"",@"cityId":@"",@"addr":_address,@"idCardNo":_idNumber};
        //                    [RequstEngine requestHttp:@"1004" paramDic:param blockObject:^(NSDictionary *dic) {
        //                        DMLog(@"1004--%@",dic);
        //                        DMLog(@"error---%@",dic[@"errorMsg"]);
        //                        if ([dic[@"errorCode"] intValue]==00000) {
        //                            [UIAlertView alertWithTitle:@"温馨提示" message:@"更改信息成功" buttonTitle:nil];
        //                            [self.navigationController popViewControllerAnimated:YES];
        //                        }
        //                        else
        //                        {
        //                            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
        //
        //                        }
        //
        //                    }];
        //
        //                }
        //
        //            }
        //            else
        //            {
        //                DMLog(@"-----------------");
        //                NSString *regex = @"^1(3[0-9]|5[0-35-9]|8[0-9])\\d{8}$";
        //
        //                NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        //
        //                BOOL isMatch = [pred evaluateWithObject:_phone];
        //
        //                if (!isMatch) {
        //
        //                    [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入正确的手机号" buttonTitle:nil];
        //                    //            return NO;
        //
        //                }
        //                else
        //                {
        //                    if (_choose==0) {
        //                        NSDictionary * param=@{@"memberId":USERID,@"name":_nickName,@"imgUrl":[_imgUrl substringFromIndex:47],@"sex":@"2",@"birthday":@"",@"qq":@"",@"email":@"",@"cityId":@"",@"addr":_address,@"idCardNo":_idNumber};
        //                        [RequstEngine requestHttp:@"1004" paramDic:param blockObject:^(NSDictionary *dic) {
        //                            DMLog(@"1004--%@",dic);
        //                            DMLog(@"error---%@",dic[@"errorMsg"]);
        //                            if ([dic[@"errorCode"] intValue]==00000) {
        //                                [UIAlertView alertWithTitle:@"温馨提示" message:@"更改信息成功" buttonTitle:nil];
        //                                [self.navigationController popViewControllerAnimated:YES];
        //                            }
        //                            else
        //                            {
        //                                [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
        //
        //                            }
        //
        //                        }];
        //
        //                    }
        //                    else
        //                    {
        //                        NSDictionary * param=@{@"memberId":USERID,@"name":_nickName,@"imgUrl":_imgUrl,@"sex":@"2",@"birthday":@"",@"qq":@"",@"email":@"",@"cityId":@"",@"addr":_address,@"idCardNo":_idNumber};
        //                        [RequstEngine requestHttp:@"1004" paramDic:param blockObject:^(NSDictionary *dic) {
        //                            DMLog(@"1004--%@",dic);
        //                            DMLog(@"error---%@",dic[@"errorMsg"]);
        //                            if ([dic[@"errorCode"] intValue]==00000) {
        //                                [UIAlertView alertWithTitle:@"温馨提示" message:@"更改信息成功" buttonTitle:nil];
        //                                [self.navigationController popViewControllerAnimated:YES];
        //                            }
        //                            else
        //                            {
        //                                [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
        //
        //                            }
        //
        //                        }];
        //
        //                    }
        //
        //                }
        //            }
        //
        //
        //        }
        //        if (_idNumber.length>0) {
        //            NSString *CM = @"^[0-9a-zA-Z]{1,18}$";
        //            NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
        //            BOOL isNum = [regextestcm evaluateWithObject:_idNumber];
        //            DMLog(@"888%d",isNum);
        //            if (isNum)
        //            {
        //
        //                if (_idNumber.length<18) {
        //                    [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入18位身份证号" buttonTitle:nil];
        //                }
        //                else
        //                {
        //                    NSString *CM = @"^[0-9]{1,11}$";
        //                    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
        //                    BOOL isNum = [regextestcm evaluateWithObject:_phone];
        //                    DMLog(@"888%d",isNum);
        //                    if (isNum)
        //                    {
        //                        if (_phone.length<11) {
        //                            [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入11位手机号" buttonTitle:nil];
        //                        }
        //                        else
        //                        {
        //                            NSString *regex = @"^1(3[0-9]|5[0-35-9]|8[0-9])\\d{8}$";
        //
        //                            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        //
        //                            BOOL isMatch = [pred evaluateWithObject:_phone];
        //
        //                            if (!isMatch) {
        //
        //                                [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入正确的手机号" buttonTitle:nil];
        //                                //            return NO;
        //
        //                            }
        //                            else
        //                            {
        //                                if (_choose==0) {
        //                                    NSDictionary * param=@{@"memberId":USERID,@"name":_nickName,@"imgUrl":[_imgUrl substringFromIndex:47],@"sex":@"2",@"birthday":@"",@"qq":@"",@"email":@"",@"cityId":@"",@"addr":_address,@"idCardNo":_idNumber};
        //                                    [RequstEngine requestHttp:@"1004" paramDic:param blockObject:^(NSDictionary *dic) {
        //                                        DMLog(@"1004--%@",dic);
        //                                        DMLog(@"error---%@",dic[@"errorMsg"]);
        //                                        if ([dic[@"errorCode"] intValue]==00000) {
        //                                            [UIAlertView alertWithTitle:@"温馨提示" message:@"更改信息成功" buttonTitle:nil];
        //                                            [self.navigationController popViewControllerAnimated:YES];
        //                                        }
        //                                        else
        //                                        {
        //                                            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
        //
        //                                        }
        //
        //                                    }];
        //
        //                                }
        //                                else
        //                                {
        //                                    NSDictionary * param=@{@"memberId":USERID,@"name":_nickName,@"imgUrl":_imgUrl,@"sex":@"2",@"birthday":@"",@"qq":@"",@"email":@"",@"cityId":@"",@"addr":_address,@"idCardNo":_idNumber};
        //                                    [RequstEngine requestHttp:@"1004" paramDic:param blockObject:^(NSDictionary *dic) {
        //                                        DMLog(@"1004--%@",dic);
        //                                        DMLog(@"error---%@",dic[@"errorMsg"]);
        //                                        if ([dic[@"errorCode"] intValue]==00000) {
        //                                            [UIAlertView alertWithTitle:@"温馨提示" message:@"更改信息成功" buttonTitle:nil];
        //                                            [self.navigationController popViewControllerAnimated:YES];
        //                                        }
        //                                        else
        //                                        {
        //                                            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
        //                                            
        //                                        }
        //                                        
        //                                    }];
        //                                    
        //                                }
        //
        //                            }
        //                            
        //                        }
        //                        
        //                    }else
        //                    {
        //                        //            [self.view endEditing:YES];
        //                        [UIAlertView alertWithTitle:@"温馨提示" message:@"手机号仅限数字" buttonTitle:nil];
        //                        
        //                    }
        //
        //                    
        //                }
        //                
        //            }else
        //            {
        //                //            [self.view endEditing:YES];
        //                [UIAlertView alertWithTitle:@"温馨提示" message:@"身份证号仅限数字和字母" buttonTitle:nil];
        //                
        //            }
        //            
        //        }
        //   
        //    }
        //

        
    }else
    {
        //            [self.view endEditing:YES];
        [UIAlertView alertWithTitle:@"温馨提示" message:@"身份证号格式不正确或不存在该身份证" buttonTitle:nil];
        
    }

    
}

#pragma mark - 升级
-(void)improveLevel
{
    if ([_isCanUpgrade boolValue]==0) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"您已经是最高等级，无需升级了" buttonTitle:nil];
    }
    else
    {
        if ([_partnerAgencyPayStatus intValue]==0)
        {
            [UIAlertView alertWithTitle:@"温馨提示" message:@"您还不是合伙人，请先申请加盟商家或合伙人" buttonTitle:nil];
        }
        else
        {
            VIPlevelViewController * VIPlevelVC=[[VIPlevelViewController alloc]init];
            //        VIPlevelVC.claddifyStr=@"黄金合伙人";
            VIPlevelVC.myLevelName=_levelName;
            VIPlevelVC.level=_level;
            VIPlevelVC.currentLevelFee=_currentLevelFee;
            [self.navigationController pushViewController:VIPlevelVC animated:YES];
        }

    }
    
}


#pragma mark - 更换手机号
-(void)changeTelephoneNumber
{
     BoundViewController* changeVC=[[BoundViewController alloc]init];
//    changeVC.phone=_phone;
    [changeVC setBlock:^(NSString * phoneStr) {
        _phone=phoneStr;
        [_tableView reloadData];
    }];
    [self.navigationController pushViewController:changeVC animated:YES];
}


#pragma mark - 输入框绑定的方法
-(void)chooseAddr:(UITextField*)textField
{
    _address=textField.text;
    
}

-(void)choosePhone:(UITextField*)textField
{
    _phone=textField.text;
}

-(void)chooseID:(UITextField*)textField
{
    _idNumber=textField.text;
}

-(void)longPressToDo
{
    DMLog(@"去除会员卡");
    [_coverView removeFromSuperview];
    [_vipImg removeFromSuperview];
    [_levelLabel removeFromSuperview];
    [_inviteCodeLabel removeFromSuperview];
}

-(void)alertViewAppear
{
//    [UIAlertView alertWithTitle:@"温馨提示" message:@"更改信息成功" UIController:self];
    [UIAlertView alertWithTitle:@"温馨提示" message:@"更改信息成功" UIViewController:self];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - viewWillDisappear
//-(void)viewWillDisappear:(BOOL)animated
//{
////    [self.view endEditing:YES];
//}
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
