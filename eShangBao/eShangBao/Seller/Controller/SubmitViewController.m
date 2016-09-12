//
//  SubmitViewController.m
//  eShangBao
//
//  Created by Dev on 16/1/21.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "SubmitViewController.h"
#import "SubmitTableViewCell.h"
#import "AddressViewController.h"
#import "PayOrderViewController.h"
#import "DeliveryAddressViewController.h"
#import "PromptViewController.h"
#import "SetPsdViewController.h"

@interface SubmitViewController ()<UITableViewDelegate,UITableViewDataSource,submitPaymentMethodDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    double                  totale;
    NSString                *addressID;//地址ID
    NSString                *newpayMethod;//支付方式
    TBActivityView          *activityView;
    UIButton                *doneInKeyboardButton;
    NSString*               _goldNum;//当前输入的通币
    NSString                *biPwd;//通宝币支付密码
    float                     myGoldNum;//我的通币
    BOOL                    _chooseVouchersPay;
}

@property(nonatomic,strong)NSMutableArray    *goodsList;

@property (weak, nonatomic) IBOutlet UITableView *submitTableView;

@end

@implementation SubmitViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSDictionary * param=@{@"memberId":USERID};
    [RequstEngine requestHttp:@"1003" paramDic:param blockObject:^(NSDictionary *dic) {
        DMLog(@"1003----%@",dic);
        if ([dic[@"errorCode"] intValue]==00000) {
            myGoldNum=[dic[@"member"][@"goldNum"]floatValue];
        }
        [_submitTableView reloadData];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title=@"提交订单";
    
    biPwd=@"";
    [self createMyAddressRequest];
//    [self registerForKeyboardNotifications];
    

    _chooseVouchersPay=YES;
    _submitTableView.backgroundColor=[UIColor clearColor];
    
    newpayMethod=@"0";
    //goldNum=0;
    
    if (_whichPage==0) {
        _goodsList=[NSMutableArray arrayWithCapacity:0];
        for (SellerGoodsListModel *newModel in [_chooseListDic allValues]) {
            
            NSString  *goodsId=[NSString stringWithFormat:@"%@",newModel.goodsId];
            NSString  *chooseNum=[NSString stringWithFormat:@"%@",newModel.chooseNum];
            NSDictionary *chooseDic=@{@"goodsId":goodsId,@"goodsNum":chooseNum};
            [_goodsList addObject:chooseDic];
        }
        totale=[_shopInfo.sendPrice floatValue]+_chooseTotalMoney;

    }
    else
    {
        _goodsList=[NSMutableArray arrayWithCapacity:0];
        for (ShoppingModel *newModel in [_chooseListDic allValues]) {
            
            NSString  *goodsId=[NSString stringWithFormat:@"%@",newModel.goodsId];
            NSString  *chooseNum=[NSString stringWithFormat:@"%@",newModel.num];
            NSDictionary *chooseDic=@{@"goodsId":goodsId,@"goodsNum":chooseNum};
            [_goodsList addObject:chooseDic];
        }
        totale=_chooseTotalMoney+[_deliveryFee intValue];

    }
    
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.showVC=self;
    [self.view addSubview:activityView];
    [self bottomViewData];
    
     //_submitTableView.frame=CGRectMake(0, 0, KScreenWidth, _submitTableView.frame.size.height-200);
    
    
}

-(void)createMyAddressRequest
{
    
    NSDictionary *pagination=@{@"page":@"1",@"rows":@"1",@"firstQueryTime":@""};
    [RequstEngine pagingRequestHttp:@"1017" paramDic:nil pageDic:pagination blockObject:^(NSDictionary *dic) {
    
        [activityView stopAnimate];
        if ([dic[@"errorCode"] intValue]==0) {
            
            for (NSDictionary *newDic in dic[@"recordList"]) {
                
                _chooseAddr=[[AddressModel alloc]init];
                [_chooseAddr setValuesForKeysWithDictionary:newDic];
                addressID=_chooseAddr.addrId;
                [_submitTableView reloadData];
            }
            
            
        }
        DMLog(@"%@",dic);
        
        
    }];
    
}


-(void)bottomViewData
{
    
    _preferentialNum.text=[NSString stringWithFormat:@"通宝币¥%.2f",[_goldNum floatValue]];
    self.needPayNum.text=[NSString stringWithFormat:@"¥%.2f",totale-[_goldNum floatValue]];
}



//- (void) registerForKeyboardNotifications
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
//    
//    //[self configDoneInKeyBoardButton];
//
//}

#pragma mark - 支付数量获取
- (void)editingDidBegin:(id)sender{
    DMLog(@"++");
//     _submitTableView.frame=CGRectMake(0, 0, KScreenWidth, _submitTableView.frame.size.height-216);
    //初始化数字键盘的“完成”按钮
//    [self configDoneInKeyBoardButton];
}
-(void)editingDidEnd:(UITextField *)textFD
{

//    _submitTableView.frame=CGRectMake(0, 0, KScreenWidth, _submitTableView.frame.size.height);
    if (myGoldNum>totale) {
        if ([textFD.text floatValue]>totale) {
            textFD.text=[NSString stringWithFormat:@"%.2f",totale];
            _goldNum=textFD.text;
            [self bottomViewData];
        }
        else
        {
            _goldNum=textFD.text;
            [self bottomViewData];
            return;
        }
        
    }else
    {
        if ([textFD.text intValue]>myGoldNum) {
            
            //        [UIAlertView alertWithTitle:@"温馨提示" message:@"您的通宝币数量不够" buttonTitle:nil];
            textFD.text=[NSString stringWithFormat:@"%.2f",myGoldNum];
            _goldNum=textFD.text;
            [self bottomViewData];
            return;
        }
        else
        {
            if (textFD.text==nil) {
                
               
                //        [UIAlertView alertWithTitle:@"温馨提示" message:@"您输入的通宝币多于合计金额" buttonTitle:nil];
                //        return;
            }
            else
            {
//                textFD.text=[NSString stringWithFormat:@"%d",(int)totale];
                _goldNum=textFD.text;
                [self bottomViewData];
            }
            
        }

    }
    
//    _goldNum=([textFD.text intValue]==0)?0:[textFD.text intValue];
//    textFD.text=_goldNum;
//    [self bottomViewData];
    DMLog(@"%@",_goldNum);
}

#pragma mark - 获取支付的密码
-(void)tongbaobiPwdEditingDidEnd:(UITextField *)textPwd
{
    biPwd=textPwd.text;
}

//#pragma mark- 键盘的完成按妞
//- (void)configDoneInKeyBoardButton{
//    
//    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
//    //初始化
//    if (doneInKeyboardButton == nil)
//    {
//        doneInKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [doneInKeyboardButton setTitle:@"完成" forState:UIControlStateNormal];
//        [doneInKeyboardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        doneInKeyboardButton.tag=5;
//        doneInKeyboardButton.frame = CGRectMake(0, screenHeight, 106, 53);
//        
//        doneInKeyboardButton.adjustsImageWhenHighlighted = NO;
//        [doneInKeyboardButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
//    }
//    //每次必须从新设定“完成”按钮的初始化坐标位置
//    doneInKeyboardButton.frame = CGRectMake(0, screenHeight, 106, 53);
//    
//        
//    //由于ios8下，键盘所在的window视图还没有初始化完成，调用在下一次 runloop 下获得键盘所在的window视图
//    [self performSelector:@selector(addDoneButton) withObject:nil afterDelay:0.0f];
//
//}
//- (void) addDoneButton{
//    //获得键盘所在的window视图
//    UIWindow *tempWindow =[[[UIApplication sharedApplication] windows] objectAtIndex:1];
//    [tempWindow addSubview:doneInKeyboardButton];    // 注意这里直接加到window上
//    [doneInKeyboardButton bringSubviewToFront:tempWindow];
//    
//}

//-(void)finishAction{
//    
//    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
//}

//-(void)keyboardWasShown:(NSNotification *) notif
//{
//    NSDictionary *info = [notif userInfo];
//    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
//    CGSize keyboardSize = [value CGRectValue].size;
//    CGFloat animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    NSInteger animationCurve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
//    if (doneInKeyboardButton){
//        
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:animationDuration];//设置添加按钮的动画时间
//        [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];//设置添加按钮的动画类型
//        //设置自定制按钮的添加位置(这里为数字键盘添加“完成”按钮)
//        doneInKeyboardButton.transform=CGAffineTransformTranslate(doneInKeyboardButton.transform, 0, -53);
//        
//        [UIView commitAnimations];
//    }
//    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:3];
//    [_submitTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    [UIView animateWithDuration:animationDuration animations:^{
//        
//        _submitTableView.frame=CGRectMake(0, 0, KScreenWidth, _submitTableView.frame.size.height-(keyboardSize.height-30));
//        
//    }];
//    
//        NSLog(@"keyBoard:%f", keyboardSize.height);
//}



//
//-(void)keyboardWasHidden:(NSNotification *) notif
//{
//    NSDictionary *info = [notif userInfo];
//    
//    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
//    CGSize keyboardSize = [value CGRectValue].size;
//    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
//    CGFloat animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    
//    if (doneInKeyboardButton.superview)
//    {
//        [UIView animateWithDuration:animationDuration animations:^{
//            //动画内容，将自定制按钮移回初始位置
//            doneInKeyboardButton.transform=CGAffineTransformIdentity;
//        } completion:^(BOOL finished) {
//            //动画结束后移除自定制的按钮
//            [doneInKeyboardButton removeFromSuperview];
//            doneInKeyboardButton=nil;
//        }];
//        
//    }
//    
//
//    //这个是指定哪一行的cell，让该行cell滑到tableView的最底端
//    [UIView animateWithDuration:animationDuration animations:^{
//        
//        _submitTableView.frame=CGRectMake(0, 0, KScreenWidth, _submitTableView.frame.size.height+(keyboardSize.height-30));
//        
//    }];
//}

#pragma mark- tabelviewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==3) {
        return 0;
    }
    return 5;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return 1;
        }
            break;

        case 2:
        {

            return _chooseListArr.count+2;
        }
            break;
        case 3:
        {
            if (_chooseVouchersPay) {
                
                return 0;
            }
            return 1;
        }
            
        default:
            break;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (_chooseAddr==nil) {
                return 113;
            }else
            {
                float hight=[NSString calculatemySizeWithFont:14 Text:[NSString stringWithFormat:@"%@%@",_chooseAddr.positon,_chooseAddr.details] width:KScreenWidth-30];
                return 113+hight-16;
            }
            //return 113;
        }
            break;
        case 1:
        {
            return 105;
        }
            break;
        case 2:
        {
            if (indexPath.row==0) {
                return 39;
            }
            if (indexPath.row==_chooseListArr.count+1) {
                return 68;
            }
            return 34;
        }
            break;
        case 3:
            
        {
            return 44;
        }
        default:
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *cellArr=[[NSBundle mainBundle] loadNibNamed:@"SubmitTableViewCell" owner:nil options:nil];
    SubmitTableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
        {
            
            
            cell=[cellArr objectAtIndex:0];
            if (_chooseAddr!=nil) {
                
                cell.customerName.text=_chooseAddr.name;
                cell.customerPhone.text=_chooseAddr.phone;
                cell.customerAddress.text=[NSString stringWithFormat:@"%@%@",_chooseAddr.positon,_chooseAddr.details];
                
                
            }
            [cell.addAddressBtn addTarget:self action:@selector(addAddressBtnClick) forControlEvents:1<<6];
            if (_whichPage==0) {
                cell.arriveTime.text=[NSString stringWithFormat:@"立即送达(大约%@分钟后送达)",_shopInfo.transitTime];
            }
            else
            {
                cell.arriveTime.text=@"立即送达";
            }
            
            
        }
            break;
        case 1:
        {
            cell=[cellArr objectAtIndex:1];
            cell.delegate=self;
        }
            break;
        case 2:
        {
            if (indexPath.row==0) {
                
                cell=[cellArr objectAtIndex:2];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                if (_whichPage==0) {
                    cell.storeName.text=[NSString stringWithFormat:@"%@(%@)",_shopInfo.shopName,_shopInfo.branchName];
                }
                else
                {
                    cell.storeName.text=@"消费宝直营超市";
                }
                
                return cell;
            }

            if (indexPath.row==_chooseListArr.count+1) {
                
                cell=[cellArr objectAtIndex:4];
                if (_whichPage==0) {
                    cell.sendPriceLabel.text=[NSString stringWithFormat:@"包含%@元配送费",_shopInfo.sendPrice];
                }
                else
                {
                    cell.sendPriceLabel.text=[NSString stringWithFormat:@"包含%@元配送费",_deliveryFee];
                }
                
                cell.totalMoney.text=[NSString stringWithFormat:@"¥%.2f",totale];
            
                cell.vouchersNum.text=[NSString stringWithFormat:@"当前可用通宝币为%.2f",myGoldNum];
                [cell.tongBaoBiBtn addTarget:self action:@selector(tongBaobiPayBtn:) forControlEvents:1<<6];
                
                if (!_chooseVouchersPay) {
                    
                    [cell.tongBaoBiBtn setImage:[UIImage imageNamed:@"3-(2)选择_03"] forState:0];
                    
                }else{
                    
                    [cell.tongBaoBiBtn setImage:[UIImage imageNamed:@"3-(2)选择_06"] forState:0];
                }
                
            }
            else{

                if (_whichPage==0) {
                    NSString *goodsId=_chooseListArr[indexPath.row-1];
                    SellerGoodsListModel *model=[_chooseListDic objectForKey:goodsId];
                    cell=[cellArr objectAtIndex:3];
                    
                    cell.goodsName.text=model.goodsName;
                    cell.goodsNum.text=[NSString stringWithFormat:@"x%@",model.chooseNum];
                    double totalMoney=[model.chooseNum intValue]*[model.price doubleValue];
                    cell.goodsMoney.text=[NSString stringWithFormat:@"¥%.2f",totalMoney];
                }
                else
                {
                    NSString *goodsId=_chooseListArr[indexPath.row-1];
                    ShoppingModel *model=[_chooseListDic objectForKey:goodsId];
                    cell=[cellArr objectAtIndex:3];
                    
                    cell.goodsName.text=model.goodsName;
                    cell.goodsNum.text=[NSString stringWithFormat:@"x%@",model.num];
                    double totalMoney=[model.num intValue]*[model.price doubleValue];
                    cell.goodsMoney.text=[NSString stringWithFormat:@"¥%.2f",totalMoney];
                }
               
                
                
            }
        }
            break;
        case 3:
        {
            cell=[cellArr objectAtIndex:5];
//            cell.backgroundColor=[UIColor redColor];
            //此处判断在关闭后打开时的 输入状态
            [cell.tongbaobiNum addTarget:self action:@selector(editingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
            [cell.tongbaobiNum addTarget:self action:@selector(editingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
            cell.tongbaobiNum.tag=10;
            cell.tongbaobiNum.delegate=self;
            //[cell.tongbaobiPwd addTarget:self action:@selector(tongbaobiPwdEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
            [cell.tongbaobiPwd addTarget:self action:@selector(tongbaobiPwdEditingDidEnd:) forControlEvents:UIControlEventEditingChanged];
            cell.tongbaobiPwd.tag=11;
            cell.tongbaobiPwd.delegate=self;
            

            cell.tongbaobiNum.text=_goldNum;

        }
        default:
            break;
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.26 animations:^{
       _submitTableView.frame=CGRectMake(0, -160, KScreenWidth, _submitTableView.frame.size.height);
    }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.26 animations:^{
       _submitTableView.frame=CGRectMake(0, 0, KScreenWidth, _submitTableView.frame.size.height);
    }];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
        {
//            if (_goldNum.length==0)
//            {
//                [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入通宝币数量" buttonTitle:nil];
//            }
//            else
//            {
            if (alertView.tag==10) {
                biPwd=[alertView textFieldAtIndex:0].text;
                [self.view endEditing:YES];
                if (_whichPage==0) {
                    if ([_goldNum floatValue]==0) {
                        NSDictionary *param=@{@"shopId":_shopInfo.shopId,@"goodsList":_goodsList,@"addrId":addressID,@"goldNum":_goldNum,@"payMethod":newpayMethod,@"sendDate":@"",@"payPwd":biPwd};
                        
                        DMLog(@"1018---%@",param);
                        
                        [activityView startAnimate];
                        
                        [RequstEngine requestHttp:@"1018" paramDic:param blockObject:^(NSDictionary *dic) {
                            
                            [activityView stopAnimate];
                            DMLog(@"1018-----%@",dic);
                            if ([dic[@"errorCode"] intValue]==0) {
                                //#warning 待处理线下支付的流程
                                //待处理
                                NSString *orderID=dic[@"orderId"];
                                NSString *totalPrice=[NSString stringWithFormat:@"%@",dic[@"totalPrice"]];
                                
                                if ([dic[@"totalPrice"] floatValue]==0) {
                                    PromptViewController * promptVC=[[PromptViewController alloc]init];
                                    promptVC.orderID=orderID;
                                    promptVC.whichPage=_whichPage;
                                    [self.navigationController pushViewController:promptVC animated:YES];
                                }
                                else
                                {
                                    PayOrderViewController *payVC=[[PayOrderViewController alloc]init];
                                    payVC.orderID=orderID;
                                    payVC.totalPrice=totalPrice;
                                    payVC.shopName=_shopInfo.shopName;
                                    payVC.whichPage=_whichPage;
                                    payVC.jumpWhichPage=0;
                                    payVC.paramStr=dic[@"param"][@"paramStr"];
                                    [self.navigationController pushViewController:payVC animated:YES];
                                    
                                }
                            }
                            else if ([dic[@"errorCode"] isEqualToString:@"00018"])
                            {
                                [activityView stopAnimate];
                                [self.view endEditing:YES];
                                UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:dic[@"errorMsg"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
                                alertView.tag=12;
                                alertView.delegate=self;
                                [alertView show];
                            }
                            
                            
                            
                            else{
                                
                                [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                                
                            }
                            
                        }];
                    }
                    else
                    {
                        if (biPwd.length==0) {
                            [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入通宝币支付密码" buttonTitle:nil];
                        }
                        else
                        {
                            NSDictionary *param=@{@"shopId":_shopInfo.shopId,@"goodsList":_goodsList,@"addrId":addressID,@"goldNum":_goldNum,@"payMethod":newpayMethod,@"sendDate":@"",@"payPwd":biPwd};
                            
                            DMLog(@"1018---%@",param);
                            
                            [activityView startAnimate];
                            
                            [RequstEngine requestHttp:@"1018" paramDic:param blockObject:^(NSDictionary *dic) {
                                
                                [activityView stopAnimate];
                                DMLog(@"1018-----%@",dic);
                                if ([dic[@"errorCode"] intValue]==0) {
                                    //#warning 待处理线下支付的流程
                                    //待处理
                                    NSString *orderID=dic[@"orderId"];
                                    NSString *totalPrice=[NSString stringWithFormat:@"%@",dic[@"totalPrice"]];
                                    
                                    if ([dic[@"totalPrice"] floatValue]==0) {
                                        PromptViewController * promptVC=[[PromptViewController alloc]init];
                                        promptVC.orderID=orderID;
                                        promptVC.whichPage=_whichPage;
                                        [self.navigationController pushViewController:promptVC animated:YES];
                                    }
                                    else
                                    {
                                        PayOrderViewController *payVC=[[PayOrderViewController alloc]init];
                                        payVC.orderID=orderID;
                                        payVC.totalPrice=totalPrice;
                                        payVC.shopName=_shopInfo.shopName;
                                        payVC.whichPage=_whichPage;
                                        payVC.jumpWhichPage=0;
                                        payVC.paramStr=dic[@"param"][@"paramStr"];
                                        [self.navigationController pushViewController:payVC animated:YES];
                                        
                                    }
                                }
                                
                                else if ([dic[@"errorCode"] isEqualToString:@"00018"])
                                {
                                    [activityView stopAnimate];
                                    [self.view endEditing:YES];
                                    UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:dic[@"errorMsg"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
                                    alertView.tag=12;
                                    alertView.delegate=self;
                                    [alertView show];
                                }
                                
                                else{
                                    
                                    //                                    [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:dic[@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                    [alertView show];
                                    
                                }
                                
                            }];
                        }
                    }
                    
                }
                else
                {
                    if ([_goldNum floatValue]==0) {
                        NSDictionary *param=@{@"goodsList":_goodsList,@"addrId":addressID,@"goldNum":_goldNum,@"payMethod":newpayMethod,@"sendDate":@"",@"payPwd":biPwd};
                        
                        DMLog(@"1018---%@",param);
                        
                        [activityView startAnimate];
                        
                        [RequstEngine requestHttp:@"1074" paramDic:param blockObject:^(NSDictionary *dic) {
                            
                            [activityView stopAnimate];
                            DMLog(@"1074-----%@",dic);
                            if ([dic[@"errorCode"] intValue]==0) {
                                //#warning 待处理线下支付的流程
                                //待处理
                                NSString *orderID=dic[@"orderId"];
                                NSString *totalPrice=[NSString stringWithFormat:@"%@",dic[@"totalPrice"]];
                                if ([dic[@"totalPrice"] floatValue]==0) {
                                    PromptViewController * promptVC=[[PromptViewController alloc]init];
                                    promptVC.orderID=orderID;
                                    promptVC.whichPage=_whichPage;
                                    [self.navigationController pushViewController:promptVC animated:YES];
                                }
                                else
                                {
                                    PayOrderViewController *payVC=[[PayOrderViewController alloc]init];
                                    payVC.orderID=orderID;
                                    payVC.totalPrice=totalPrice;
                                    payVC.shopName=_shopInfo.shopName;
                                    payVC.whichPage=_whichPage;
                                    payVC.jumpWhichPage=1;
                                    payVC.paramStr=dic[@"param"][@"paramStr"];
                                    [self.navigationController pushViewController:payVC animated:YES];
                                    
                                }
                            }
                            
                            else if ([dic[@"errorCode"] isEqualToString:@"00018"])
                            {
                                [activityView stopAnimate];
                                [self.view endEditing:YES];
                                UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:dic[@"errorMsg"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
                                alertView.tag=12;
                                alertView.delegate=self;
                                [alertView show];
                            }
                            
                            else{
                                
                                [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                                
                            }
                            
                        }];
                    }
                    else
                    {
                        if (biPwd.length==0) {
                            [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入通宝币支付密码" buttonTitle:nil];
                        }
                        else
                        {
                            NSDictionary *param=@{@"goodsList":_goodsList,@"addrId":addressID,@"goldNum":_goldNum,@"payMethod":newpayMethod,@"sendDate":@"",@"payPwd":biPwd};
                            
                            DMLog(@"1074---%@",param);
                            
                            [activityView startAnimate];
                            
                            [RequstEngine requestHttp:@"1074" paramDic:param blockObject:^(NSDictionary *dic) {
                                
                                [activityView stopAnimate];
                                DMLog(@"1018-----%@",dic);
                                if ([dic[@"errorCode"] intValue]==0) {
                                    //#warning 待处理线下支付的流程
                                    //待处理
                                    NSString *orderID=dic[@"orderId"];
                                    NSString *totalPrice=[NSString stringWithFormat:@"%@",dic[@"totalPrice"]];
                                    
                                    if ([dic[@"totalPrice"] floatValue]==0) {
                                        PromptViewController * promptVC=[[PromptViewController alloc]init];
                                        promptVC.orderID=orderID;
                                        promptVC.whichPage=_whichPage;
                                        [self.navigationController pushViewController:promptVC animated:YES];
                                    }
                                    else
                                    {
                                        PayOrderViewController *payVC=[[PayOrderViewController alloc]init];
                                        payVC.orderID=orderID;
                                        payVC.totalPrice=totalPrice;
                                        payVC.shopName=_shopInfo.shopName;
                                        payVC.whichPage=_whichPage;
                                        payVC.jumpWhichPage=1;
                                        payVC.paramStr=dic[@"param"][@"paramStr"];
                                        [self.navigationController pushViewController:payVC animated:YES];
                                        
                                    }
                                }
                                
                                else if ([dic[@"errorCode"] isEqualToString:@"00018"])
                                {
                                    [activityView stopAnimate];
                                    [self.view endEditing:YES];
                                    UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:dic[@"errorMsg"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
                                    alertView.tag=12;
                                    alertView.delegate=self;
                                    [alertView show];
                                }
                                
                                else{
                                    
                                    [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                                    
                                }
                                
                            }];
                        }
                    }
                    
                }

            }
            else
            {
                DMLog(@"去设置");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*1), dispatch_get_current_queue(), ^{
//                    [alertView dismissViewControllerAnimated:YES completion:^{
//                        [alert removeFromParentViewController];
//                        [controller.navigationController popViewControllerAnimated:YES];
                    SetPsdViewController * setVC=[[SetPsdViewController alloc]init];
                    [self.navigationController pushViewController:setVC animated:YES];
//                    }];
                });

               
            }
            
//            }

        }
            break;
        default:
            break;
    }
}
-(void)tongBaobiPayBtn:(UIButton *)sender
{
    if (_chooseVouchersPay) {
        
        if ((float)myGoldNum==0) {
            [UIAlertView alertWithTitle:@"温馨提示" message:@"通宝币余额不足" buttonTitle:nil];
        }
        else
        {
            _chooseVouchersPay=NO;
            [sender setImage:[UIImage imageNamed:@"3-(2)选择_03"] forState:0];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
            [_submitTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

        }
        
    }else{
        _goldNum=@"";
        biPwd=@"";
        _preferentialNum.text=[NSString stringWithFormat:@"通宝币¥%.f",[_goldNum floatValue]];
        self.needPayNum.text=[NSString stringWithFormat:@"¥%.2f",totale-[_goldNum floatValue]];
        [sender setImage:[UIImage imageNamed:@"3-(2)选择_06"] forState:0];
        _chooseVouchersPay=YES;
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
        [_submitTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)payMethod:(NSString *)pay
{
    newpayMethod=pay;
}


-(void)addAddressBtnClick
{
    DeliveryAddressViewController *deliveryAddressVC=[[DeliveryAddressViewController alloc]init];
    deliveryAddressVC.addressType=1;
    [self.navigationController pushViewController:deliveryAddressVC animated:YES];
    
    DMLog(@"添加地址");
}

-(void)setChooseAddr:(AddressModel *)chooseAddr
{
    
    
    _chooseAddr=chooseAddr;
    [_submitTableView reloadData];
    addressID=chooseAddr.addrId;
    
    DMLog(@"%@",chooseAddr);
}

- (IBAction)payOrderButton:(id)sender {
    
    
    
    if (addressID==nil) {
        
        [UIAlertView alertWithTitle:@"温馨提示" message:@"请选择配送地址" buttonTitle:nil];
        return;
    }
    if (_chooseVouchersPay==NO) {

        if (_goldNum.length==0)
        {
            [UIAlertView alertWithTitle:@"温馨提示" message:@"请输入通宝币数量" buttonTitle:nil];
        }

        else
        {
            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"请输入通宝币支付密码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
            [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
            dialog.tag=10;
            [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeASCIICapable];
            
            //设置输入框的键盘类型
            UITextField *tf = [dialog textFieldAtIndex:0];
            tf.layer.cornerRadius=3;
            tf.layer.masksToBounds=YES;
            tf.secureTextEntry=YES;
            [dialog show];
        }
        
       
    }
    if (_chooseVouchersPay==YES) {
        if (_whichPage==0) {
            NSDictionary *param=@{@"shopId":_shopInfo.shopId,@"goodsList":_goodsList,@"addrId":addressID,@"goldNum":@"",@"payMethod":newpayMethod,@"sendDate":@"",@"payPwd":biPwd};
            
            DMLog(@"1018---%@",param);
            
            [activityView startAnimate];
            
            [RequstEngine requestHttp:@"1018" paramDic:param blockObject:^(NSDictionary *dic) {
                
                [activityView stopAnimate];
                DMLog(@"1018-----%@",dic);
                if ([dic[@"errorCode"] intValue]==0) {
                    //#warning 待处理线下支付的流程
                    //待处理
                    NSString *orderID=dic[@"orderId"];
                    NSString *totalPrice=[NSString stringWithFormat:@"%@",dic[@"totalPrice"]];
                    
                    if ([totalPrice intValue]!=0||[totalPrice floatValue]<1) {
                        PayOrderViewController *payVC=[[PayOrderViewController alloc]init];
                        payVC.orderID=orderID;
                        payVC.totalPrice=totalPrice;
                        payVC.shopName=_shopInfo.shopName;
                        payVC.whichPage=_whichPage;
                        payVC.jumpWhichPage=0;
                        payVC.paramStr=dic[@"param"][@"paramStr"];
                        [self.navigationController pushViewController:payVC animated:YES];
                    }
                    else
                    {
                        PromptViewController * promptVC=[[PromptViewController alloc]init];
                        promptVC.orderID=orderID;
                        promptVC.whichPage=_whichPage;
                        
                        [self.navigationController pushViewController:promptVC animated:YES];
                        
                    }
                }
                else{
                    
                    [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                    
                }
                
            }];

        }
        else
        {
            NSDictionary *param=@{@"goodsList":_goodsList,@"addrId":addressID,@"goldNum":@"",@"payMethod":newpayMethod,@"sendDate":@"",@"payPwd":biPwd};
            
            DMLog(@"1074---%@",param);
            
            [activityView startAnimate];
            
            [RequstEngine requestHttp:@"1074" paramDic:param blockObject:^(NSDictionary *dic) {
                
                [activityView stopAnimate];
                DMLog(@"10174-----%@",dic);
                if ([dic[@"errorCode"] intValue]==0) {
                    //#warning 待处理线下支付的流程
                    //待处理
                    NSString *orderID=dic[@"orderId"];
                    NSString *totalPrice=[NSString stringWithFormat:@"%@",dic[@"totalPrice"]];
                    
                    if ([totalPrice intValue]!=0||[totalPrice floatValue]<1) {
                        PayOrderViewController *payVC=[[PayOrderViewController alloc]init];
                        payVC.orderID=orderID;
                        payVC.totalPrice=totalPrice;
                        payVC.shopName=_shopInfo.shopName;
                        payVC.whichPage=_whichPage;
                        payVC.jumpWhichPage=0;
                        payVC.paramStr=dic[@"param"][@"paramStr"];
                        [self.navigationController pushViewController:payVC animated:YES];
                    }
                    else
                    {
                        PromptViewController * promptVC=[[PromptViewController alloc]init];
                        promptVC.orderID=orderID;
                        promptVC.whichPage=_whichPage;
                        [self.navigationController pushViewController:promptVC animated:YES];
                        
                    }
                }
                else{
                    
                    [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                    
                }
                
            }];

        }
       
    }
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    [doneInKeyboardButton removeFromSuperview];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//    [super viewWillDisappear:animated];
//    
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_submitTableView endEditing:YES];
    [self.view endEditing:YES];
    
    return YES;
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
