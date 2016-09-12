//
//  FillImageMsgViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/15.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "FillImageMsgViewController.h"
#import "NumberTableViewCell.h"
#import "PayViewController.h"
#import "FirstImgViewController.h"
#import "StoreImgViewController.h"
#import "LicenceViewController.h"
#import "AllowViewController.h"
#import "AdvertisingViewController.h"
#import "WebViewController.h"
@interface FillImageMsgViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate>
{
    UITableView * _tableView;
    NSArray * _titleArr;
    NSArray * _identityTitleArr;
    UIButton * _sureBtn;
    
    NSMutableArray * _firstImgArr;//门店首图图片数组
    NSMutableArray * _storeImgArr;//店铺照片数组
    NSMutableArray * _licenceImgArr;//营业执照图片
    NSString * _licenceImgUrl;//营业执照图片
    NSString * _elseImgUrl;
    NSString * _firstImgUrl;
    NSString * _storeImgUrl;
    NSString * _number;//编号
    NSString * _rebate;
    BOOL _isChoose;
}

@end

@implementation FillImageMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title=@"填写商家信息";
    _isChoose=NO;
    self.view.backgroundColor=RGBACOLOR(249, 249, 249, 1);
    _firstImgArr=[NSMutableArray arrayWithCapacity:0];
    _storeImgArr=[NSMutableArray arrayWithCapacity:0];
    _licenceImgArr=[NSMutableArray arrayWithCapacity:0];
    
    NSDictionary * param=@{@"shopId":USERID};
    [RequstEngine requestHttp:@"1012" paramDic:param blockObject:^(NSDictionary *dic) {
        DMLog(@"1012----%@",dic);
        if ([dic[@"errorCode"] intValue]==00000) {
            _number=dic[@"shop"][@"businessNum"];
        }
        [_tableView reloadData];
        
    }];
    
    [self loadUI];
    _titleArr=@[@"门店首图",@"店铺照片"];
    _identityTitleArr=@[@"营业执照",@"营业许可证"];
    if (_latitude.length==0) {
        _latitude=@"";
    }
    if (_longitude.length==0) {
        _longitude=@"";
    }

    DMLog(@"---%@,%@,%@,%@,%@,%@,%@,%@",_inviteCode,_shopName,_branchName,_branchPhone,_shopAddr,_categoryId,_cityId,_provinceId);
    // Do any additional setup after loading the view from its nib.
}

-(void)loadUI
{
    if ([_whichPage intValue]==10) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, H(380)+H(40)) style:0];
    }
    else
    {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, H(380)) style:0];
    }
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=0;
    _tableView.scrollEnabled=NO;
    [self.view addSubview:_tableView];
    
    _sureBtn=[UIButton buttonWithType:0];
    _sureBtn.frame=CGRectMake(W(150), kDown(_tableView)+18, 20, 20);
    //        _sureBtn.layer.borderWidth=1;
    //        _sureBtn.layer.cornerRadius=2;
    //        _sureBtn.layer.masksToBounds=YES;
    [_sureBtn setBackgroundImage:[UIImage imageNamed:@"uncheck"] forState:0];
    [_sureBtn addTarget:self action:@selector(changeColor) forControlEvents:1<<6];
    //        _sureBtn.layer.borderColor=RGBACOLOR(128, 128, 128, 1).CGColor;
    [self.view addSubview:_sureBtn];
    
    UILabel * sureLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_sureBtn)+W(5), kDown(_tableView)+18, W(30), 20)];
    sureLabel.text=@"同意";
    sureLabel.textColor=RGBACOLOR(128, 128, 128, 1);
    sureLabel.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:sureLabel];
    
    UIButton * xieyiBtn=[[UIButton alloc]initWithFrame:CGRectMake(kRight(sureLabel), kDown(_tableView)+18, W(115), 20)];
    //    xieyiBtn.textColor=RGBACOLOR(251, 73, 8, 1);
    [xieyiBtn setTitle:@"《万商联盟协议》" forState:0];
    [xieyiBtn addTarget:self action:@selector(gotoXieyi) forControlEvents:1<<6];
    xieyiBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [xieyiBtn setTitleColor:RGBACOLOR(251, 73, 8, 1) forState:0];
    //    xieyiBtn.text=@"《万商联盟协议》";
    [self.view addSubview:xieyiBtn];
    
    
    UIButton * nextBtn=[UIButton buttonWithType:0];
    nextBtn.layer.cornerRadius=3;
    nextBtn.layer.masksToBounds=YES;
    nextBtn.frame=CGRectMake(W(20), kDown(_sureBtn)+H(50), WIDTH-W(20)*2, 40);
    nextBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    [nextBtn setTitleColor:[UIColor whiteColor] forState:0];
    if ([_whichPage intValue]==10) {
        [nextBtn addTarget:self action:@selector(commitMsg) forControlEvents:1<<6];
        [nextBtn setTitle:@"提交" forState:0];
    }
    else
    {
        [nextBtn addTarget:self action:@selector(jump) forControlEvents:1<<6];
        [nextBtn setTitle:@"下一步" forState:0];
    }
    [self.view addSubview:nextBtn];
    
    
}

-(void)gotoXieyi
{
    NSDictionary * param=@{@"requestType":@"1"};
    [RequstEngine requestHttp:@"1044" paramDic:param blockObject:^(NSDictionary *dic) {
        DMLog(@"1044----%@",dic);
        DMLog(@"error----%@",dic[@"errorMsg"]);
        if ([dic[@"errorCode"] intValue]==0) {
            WebViewController *advertringVC=[[WebViewController alloc]init];
            advertringVC.hidesBottomBarWhenPushed=YES;
//            advertringVC.adModel=model;
//            advertringVC.add=0;
            advertringVC.content=dic[@"data"][@"content"];
            [self.navigationController pushViewController:advertringVC animated:YES];
        }
    }];
}
#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
    else
    {
        
        if ([_whichPage intValue]==10) {
            return 4;
        }
        else
        {
            return 3;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_whichPage intValue]==10) {
        if (indexPath.section==1&&indexPath.row==0) {
            NumberTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (!cell) {
                cell=[[NumberTableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell1"];
            }
            cell.selectionStyle=0;
            cell.numberTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入执照编号/名称" attributes:@{NSForegroundColorAttributeName:GRAYCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:28/2]}];
            cell.numberLabel.text=@"名称/编号";
            cell.numberLabel.textColor=MAINCHARACTERCOLOR;
            cell.numberLabel.font=[UIFont systemFontOfSize:14];
            [cell.numberTF addTarget:self action:@selector(changeMsg:) forControlEvents:UIControlEventEditingChanged];
            cell.numberTF.tag=100;
            cell.numberTF.delegate=self;
            _number=cell.numberTF.text;
            
            UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(49), WIDTH, H(1))];
            lineLabel.backgroundColor=BGMAINCOLOR;
            [cell.contentView addSubview:lineLabel];
            //        cell.accessoryType=1;
            //        cell.textLabel.text=@"yanguqoang";
            //        cell.detailTextLabel.text=@"yanguoqiang";
            return cell;
        }
        else if (indexPath.section==1&&indexPath.row==1)
        {
            NumberTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"rebateCell"];
            if (!cell) {
                cell=[[NumberTableViewCell alloc]initWithStyle:1 reuseIdentifier:@"rebateCell"];
            }
            cell.selectionStyle=0;
            cell.numberTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入0~100之间的数" attributes:@{NSForegroundColorAttributeName:GRAYCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:28/2]}];
            cell.numberLabel.text=@"返币比例";
            cell.numberLabel.textColor=MAINCHARACTERCOLOR;
            cell.numberLabel.font=[UIFont systemFontOfSize:14];
            cell.numberTF.delegate=self;
            [cell.numberTF addTarget:self action:@selector(changeMsg:) forControlEvents:UIControlEventEditingChanged];
            cell.numberTF.tag=101;
            cell.numberTF.keyboardType=UIKeyboardTypeNumberPad;
//            _number=cell.numberTF.text;
            
            UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(49), WIDTH, H(1))];
            lineLabel.backgroundColor=BGMAINCOLOR;
            [cell.contentView addSubview:lineLabel];
            //        cell.accessoryType=1;
            //        cell.textLabel.text=@"yanguqoang";
            //        cell.detailTextLabel.text=@"yanguoqiang";
            return cell;

        }
        else
        {
            
            UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell"];
            }
            cell.selectionStyle=0;
            cell.accessoryType=1;
            cell.textLabel.font=[UIFont systemFontOfSize:14];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:14];
            cell.textLabel.textColor=MAINCHARACTERCOLOR;
            cell.detailTextLabel.textColor=GRAYCOLOR;
            
            UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(49), WIDTH, H(1))];
            lineLabel.backgroundColor=BGMAINCOLOR;
            [cell.contentView addSubview:lineLabel];
            
            //        cell.textLabel.text=@"ygq";
            //        cell.detailTextLabel.text=@"ygq";
            if (indexPath.section==0) {
                cell.textLabel.text=_titleArr[indexPath.row];
            }
//            if (indexPath.section==1||(indexPath.row==2&&indexPath.row==3)) {
//                cell.textLabel.text=_identityTitleArr[indexPath.row-1];
//            }
            if (indexPath.section==0&&indexPath.row==0) {
                if (_doorImg.length>0) {
                    cell.detailTextLabel.text=@"上传成功";
                }
                else
                {
                    cell.detailTextLabel.text=@"优质菜品或者是门店照片";
                }
                
            }
            if (indexPath.section==0&&indexPath.row==1) {
                if (_storeImgUrl.length>0) {
                    cell.detailTextLabel.text=@"上传成功";
                }
                else
                {
                    cell.detailTextLabel.text=@"请选择";
                }
                
            }
            
            if (indexPath.section==1&&indexPath.row==2) {
                cell.textLabel.text=@"营业执照";
                if (_businessImg.length==0) {
                    cell.detailTextLabel.text=@"请上传";
                }
                else
                {
                    cell.detailTextLabel.text=@"上传成功";
                }
                
            }
            if (indexPath.section==1&&indexPath.row==3) {
                cell.textLabel.text=@"营业许可证";
                if (_licenseImg.length==0) {
                    cell.detailTextLabel.text=@"请上传";
                }
                else
                {
                    cell.detailTextLabel.text=@"上传成功";
                }
            }
            return cell;
            
        }

    }
    else
    {
        if (indexPath.section==1&&indexPath.row==0) {
            NumberTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (!cell) {
                cell=[[NumberTableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell1"];
            }
            cell.selectionStyle=0;
            cell.numberTF.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"请输入执照编号/名称" attributes:@{NSForegroundColorAttributeName:GRAYCOLOR,NSFontAttributeName:[UIFont systemFontOfSize:28/2]}];
            cell.numberLabel.text=@"名称/编号";
            cell.numberLabel.textColor=MAINCHARACTERCOLOR;
            cell.numberLabel.font=[UIFont systemFontOfSize:14];
            cell.numberTF.delegate=self;
            _number=cell.numberTF.text;
            [cell.numberTF addTarget:self action:@selector(changeMsg:) forControlEvents:UIControlEventEditingChanged];
            cell.numberTF.tag=101;
            
            UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(49), WIDTH, H(1))];
            lineLabel.backgroundColor=BGMAINCOLOR;
            [cell.contentView addSubview:lineLabel];
            //        cell.accessoryType=1;
            //        cell.textLabel.text=@"yanguqoang";
            //        cell.detailTextLabel.text=@"yanguoqiang";
            return cell;
        }
        else
        {
            
            UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell"];
            }
            cell.selectionStyle=0;
            cell.accessoryType=1;
            cell.textLabel.font=[UIFont systemFontOfSize:14];
            cell.detailTextLabel.font=[UIFont systemFontOfSize:14];
            cell.textLabel.textColor=MAINCHARACTERCOLOR;
            cell.detailTextLabel.textColor=GRAYCOLOR;
            
            UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(49), WIDTH, H(1))];
            lineLabel.backgroundColor=BGMAINCOLOR;
            [cell.contentView addSubview:lineLabel];
            
            //        cell.textLabel.text=@"ygq";
            //        cell.detailTextLabel.text=@"ygq";
            if (indexPath.section==0) {
                cell.textLabel.text=_titleArr[indexPath.row];
            }
            if (indexPath.section==1||(indexPath.row==1&&indexPath.row==2)) {
                cell.textLabel.text=_identityTitleArr[indexPath.row-1];
            }
            if (indexPath.section==0&&indexPath.row==0) {
                if (_doorImg.length>0) {
                    cell.detailTextLabel.text=@"上传成功";
                }
                else
                {
                    cell.detailTextLabel.text=@"优质菜品或者是门店照片";
                }
                
            }
            if (indexPath.section==0&&indexPath.row==1) {
                if (_storeImgUrl.length>0) {
                    cell.detailTextLabel.text=@"上传成功";
                }
                else
                {
                    cell.detailTextLabel.text=@"请选择";
                }
                
            }
            
            if (indexPath.section==1&&indexPath.row==1) {
                if (_businessImg.length==0) {
                    cell.detailTextLabel.text=@"请上传";
                }
                else
                {
                    cell.detailTextLabel.text=@"上传成功";
                }
                
            }
            if (indexPath.section==1&&indexPath.row==2) {
                if (_licenseImg.length==0) {
                    cell.detailTextLabel.text=@"请上传";
                }
                else
                {
                    cell.detailTextLabel.text=@"上传成功";
                }
            }
            return cell;
            
        }

    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return H(10);
    }
    else
    {
        return H(40);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return H(50);
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        
        UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, H(40))];
        view.backgroundColor=RGBACOLOR(249, 249, 249, 1);
        
        UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(13), 0, WIDTH-W(12), H(40))];
        titleLabel.text=@"建议上传图片尺寸在2000*1500以上";
        titleLabel.font=[UIFont systemFontOfSize:14];
//        titleLabel.backgroundColor=[UIColor cyanColor];
        titleLabel.textColor=GRAYCOLOR;
        [view addSubview:titleLabel];
        return view;
    }
    else
    {
        return nil;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if ([_whichPage intValue]==10) {
        if (indexPath.section==0&&indexPath.row==0) {
            FirstImgViewController * firstVC=[[FirstImgViewController alloc]init];
            firstVC.doorImg=_doorImg;
            [firstVC setBlock:^(NSDictionary *dic) {
                _doorImg=dic[@"imgArr"];
                [_tableView reloadData];
            }];
            [self.navigationController pushViewController:firstVC animated:YES];
        }
        else if (indexPath.section==0&&indexPath.row==1)
        {
            StoreImgViewController * storeVC=[[StoreImgViewController alloc]init];
            //        storeV
            [storeVC setBlock:^(NSDictionary *dic) {
                _storeImgUrl=dic[@"imgArr"];
                [_tableView reloadData];
            }];
            [self.navigationController pushViewController:storeVC animated:YES];
        }
        if (indexPath.section==1&&indexPath.row==2) {
            LicenceViewController *licenceVC=[[LicenceViewController alloc]init];
            licenceVC.businessImg=_businessImg;
            [licenceVC setBlock:^(NSDictionary *dic) {
                _businessImg=dic[@"imgUrl"];
                [_tableView reloadData];
            }];
            [self.navigationController pushViewController:licenceVC animated:YES];
        }
        if (indexPath.section==1&&indexPath.row==3) {
            AllowViewController *licenceVC=[[AllowViewController alloc]init];
            licenceVC.licenseImg=_licenseImg;
            [licenceVC setBlock:^(NSDictionary *dic) {
                _licenseImg=dic[@"imgUrl"];
                [_tableView reloadData];
            }];
            [self.navigationController pushViewController:licenceVC animated:YES];
            
        }

    }
    else
    {
        if (indexPath.section==0&&indexPath.row==0) {
            FirstImgViewController * firstVC=[[FirstImgViewController alloc]init];
            firstVC.doorImg=_doorImg;
            [firstVC setBlock:^(NSDictionary *dic) {
                _doorImg=dic[@"imgArr"];
                [_tableView reloadData];
            }];
            [self.navigationController pushViewController:firstVC animated:YES];
        }
        else if (indexPath.section==0&&indexPath.row==1)
        {
            StoreImgViewController * storeVC=[[StoreImgViewController alloc]init];
            //        storeV
            [storeVC setBlock:^(NSDictionary *dic) {
                _storeImgUrl=dic[@"imgArr"];
                [_tableView reloadData];
            }];
            [self.navigationController pushViewController:storeVC animated:YES];
        }
        if (indexPath.section==1&&indexPath.row==1) {
            LicenceViewController *licenceVC=[[LicenceViewController alloc]init];
            licenceVC.businessImg=_businessImg;
            [licenceVC setBlock:^(NSDictionary *dic) {
                _businessImg=dic[@"imgUrl"];
                [_tableView reloadData];
            }];
            [self.navigationController pushViewController:licenceVC animated:YES];
        }
        if (indexPath.section==1&&indexPath.row==2) {
            AllowViewController *licenceVC=[[AllowViewController alloc]init];
            licenceVC.licenseImg=_licenseImg;
            [licenceVC setBlock:^(NSDictionary *dic) {
                _licenseImg=dic[@"imgUrl"];
                [_tableView reloadData];
            }];
            [self.navigationController pushViewController:licenceVC animated:YES];
            
        }

    }
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
            
        case 1:
        {
           // _vctype  0:成为联盟商家  1:推荐联盟商家
            if ([_vctype intValue]==0) {
                NSDictionary * param=@{@"name":_name,@"idcardno":_idcardno,@"shopName":_shopName,@"branchName":_branchName,@"branchPhone":_branchPhone,@"shopAddr":_shopAddr,@"doorImg":_doorImg,@"businessNum":_number,@"businessImg":_licenseImg,@"licenseImg":_businessImg,@"startBusinessTime":@"",@"endBusinessTime":@"",@"categoryId":_categoryId,@"shopReturnRate":_rebate,@"shopRefreeCode":_inviteCode,@"latitude":_latitude,@"longitude":_longitude,@"city":_cityId,@"province":_provinceId};
                [RequstEngine requestHttp:@"1079" paramDic:param blockObject:^(NSDictionary *dic) {
                    DMLog(@"1079---%@",dic);
                    DMLog(@"error---%@",dic[@"errorMsg"]);
                    if ([dic[@"errorCode"] intValue]==0) {
                        [UIAlertView alertWithTitle:@"温馨提示" message:@"申请提交成功，请等待审核" buttonTitle:nil];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                    else
                    {
                        [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                    }
                }];

            }
            else
            {

                NSDictionary * param=@{@"name":_name,@"idcardno":_idcardno,@"phone":_phone,@"shopName":_shopName,@"branchName":_branchName,@"inviteCode":_inviteCode,@"branchPhone":_branchPhone,@"shopAddr":_shopAddr,@"doorImg":_doorImg,@"businessNum":_number,@"businessImg":_licenseImg,@"licenseImg":_businessImg,@"startBusinessTime":@"",@"endBusinessTime":@"",@"categoryId":_categoryId,@"shopReturnRate":_rebate,@"shopRefreeCode":_inviteCode,@"latitude":_latitude,@"longitude":_longitude,@"city":_cityId,@"province":_provinceId,@"loginName":_loginName};
                [RequstEngine requestHttp:@"1080" paramDic:param blockObject:^(NSDictionary *dic) {
                    DMLog(@"1080---%@",dic);
                    DMLog(@"error---%@",dic[@"errorMsg"]);
                    if ([dic[@"errorCode"] intValue]==0) {
                        [UIAlertView alertWithTitle:@"温馨提示" message:@"申请提交成功，请等待审核" buttonTitle:nil];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                    else
                    {
                        [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                    }
                }];

            }
            
//            PayViewController*payVC=[[PayViewController alloc]init];
//            payVC.whichPage=0;
//            payVC.inviteCode=_inviteCode;
//            payVC.shopName=_shopName;
//            payVC.branchName=_branchName;
//            payVC.branchPhone=_branchPhone;
//            payVC.shopAddr=_shopAddr;
//            payVC.categoryId=_categoryId;
//            payVC.firstImgUrl=_firstImgUrl;
//            payVC.storeImgUrl=_storeImgUrl;
//            payVC.licenceImgUrl=_licenceImgUrl;
//            payVC.allowImgUrl=_elseImgUrl;
//            payVC.number=_number;
//            payVC.name=_name;
//            payVC.idcardno=_idcardno;
//            payVC.latitude=_latitude;
//            payVC.longitude=_longitude;
//            [self.navigationController pushViewController:payVC animated:YES];
        }
            
            break;
        default:
            break;
    }
}
#pragma mark - 按钮绑定的方法
-(void)changeColor
{
    
    static int i=0;
    i++;
    if (i%2==1) {
        _isChoose=YES;
        [_sureBtn setBackgroundImage:[UIImage imageNamed:@"checked"] forState:0];
    }
    else
    {
        _isChoose=NO;
        [_sureBtn setBackgroundImage:[UIImage imageNamed:@"uncheck"] forState:0];
    }
    
}

-(void)jump
{
    if (_isChoose==NO) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请同意万商联盟后再进入下一步" buttonTitle:nil];
    }
    
    else
    {
        PayViewController*payVC=[[PayViewController alloc]init];
        payVC.whichPage=0;
        payVC.inviteCode=_inviteCode;
        payVC.shopName=_shopName;
        payVC.branchName=_branchName;
        payVC.branchPhone=_branchPhone;
        payVC.shopAddr=_shopAddr;
        payVC.categoryId=_categoryId;
        payVC.firstImgUrl=_firstImgUrl;
        payVC.storeImgUrl=_storeImgUrl;
        payVC.licenceImgUrl=_licenceImgUrl;
        payVC.allowImgUrl=_elseImgUrl;
        payVC.number=_number;
        payVC.name=_name;
        payVC.idcardno=_idcardno;
        payVC.latitude=_latitude;
        payVC.longitude=_longitude;
        [self.navigationController pushViewController:payVC animated:YES];
    }
   
}

-(void)commitMsg
{
    [self.view endEditing:YES];
    if (_isChoose==NO) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请同意万商联盟后再进入下一步" buttonTitle:nil];
    }
    else if (_rebate.length==0) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入返币比例" buttonTitle:nil];
    }
    
    else
    {
        UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否确认提交信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.delegate=self;
        [alertView show];
        

    }

}

-(void)changeMsg:(UITextField * )textField
{
    if (textField.tag==100) {
        _number=textField.text;
    }
    if (textField.tag==101) {
//        _rebate=textField.text;
        if ([textField.text intValue]>100) {
            textField.text=@"";
            [UIAlertView alertWithTitle:@"温馨提示" message:@"反币比例值为0～100" buttonTitle:nil];
            return;
            
        }
        //        _returnGoldRate=textField.text;
        _rebate=[NSString stringWithFormat:@"%.2f",[textField.text floatValue]/100];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
