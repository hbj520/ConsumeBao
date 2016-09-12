//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"
#import "OrderDetailViewController.h"
#import "AppDelegate.h"
@implementation WXApiManager
{
    NSString *strMsg,*strTitle;
}

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

- (void)dealloc {
    self.delegate = nil;
//    [super dealloc];
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)]) {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
            [_delegate managerDidRecvMessageResponse:messageResp];
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [_delegate managerDidRecvAuthResponse:authResp];
        }
    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAddCardResponse:)]) {
            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
            [_delegate managerDidRecvAddCardResponse:addCardResp];
        }
    }else if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strMsg = [NSString stringWithFormat:@"支付结果"];
        strTitle=[NSString stringWithFormat:@"支付结果"];
        
        
        
        UIWindow *mywindow=[UIApplication sharedApplication].keyWindow;
        UIViewController *newVC=[[UIViewController alloc]init];
        [mywindow addSubview:newVC.view];
        TBActivityView *activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
        activityView.rectBackgroundColor=MAINCOLOR;
        activityView.showVC=newVC;
        [newVC.view addSubview:activityView];
        [activityView startAnimate];;

        
        
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                NSDictionary * param=@{@"type":TYPE,@"orderId":ORDERID};
                [RequstEngine requestHttp:@"1061" paramDic:param blockObject:^(NSDictionary *dic) {
                    [newVC.view removeFromSuperview];
                    [activityView stopAnimate];
                    DMLog(@"1061---%@",dic);
                    DMLog(@"error---%@",dic[@"errorMsg"]);
                    if ([dic[@"errorCode"] intValue]==00000)
                    {
                    
                        if ([PAGE isEqualToString:@"0"])
                        {
                            NSDictionary * params=@{@"orderId":ORDERID,@"status":@"1"};
                            [RequstEngine requestHttp:@"1019" paramDic:params blockObject:^(NSDictionary *dic) {
                                DMLog(@"1019---%@",dic);
                                DMLog(@"error---%@",dic[@"errorMsg"]);
                                if ([dic[@"errorCode"]intValue]==00000) {
                                    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"付款成功！" delegate:self cancelButtonTitle:@"返回上级" otherButtonTitles:@"查看订单", nil];
                                     alert.delegate=self;
                                    [alert show];
                                }else{
                                    
                                    [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                                    
                                }
                            }];

                        }
                        else
                        {
                            if ([WHICH isEqualToString:@"0"]) {
                                NSDictionary * params=@{@"type":TYPES,@"orderId":ORDERID};
                                [RequstEngine requestHttp:@"1026" paramDic:params blockObject:^(NSDictionary *dic) {
                                    DMLog(@"1026---%@",dic);
                                    DMLog(@"error---%@",dic[@"errorMsg"]);
                                    if ([dic[@"errorCode"] intValue]==00000) {
                                        strMsg = @"支付结果：成功！";
                                        DMLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                                        [alert show];
                                        [UIAlertView alertWithTitle:@"温馨提示" message:strMsg buttonTitle:nil];
                                        [[NSNotificationCenter defaultCenter]postNotificationName:@"become" object:nil];
                                    }else{
                                        
                                        [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                                        
                                    }

                                }];
                            }
                            else if([WHICH isEqualToString:@"1"])
                            {
                                NSDictionary * params=@{@"memberId":MEMBERID,@"orderId":ORDERID};
                                [RequstEngine requestHttp:@"1029" paramDic:params blockObject:^(NSDictionary *dic) {
                                    DMLog(@"1029---%@",dic);
                                    DMLog(@"error---%@",dic[@"errorMsg"]);
                                    if ([dic[@"errorCode"] intValue]==00000) {
//                                        strMsg = @"支付结果：成功！";
//                                        DMLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                                        [alert show];
                                        [UIAlertView alertWithTitle:@"温馨提示" message:@"推荐成功" buttonTitle:nil];
                                        [[NSNotificationCenter defaultCenter]postNotificationName:@"become" object:nil];
                                    }else{
                                        
                                        [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                                        
                                    }

                                }];
                            }
                            else if([WHICH isEqualToString:@"2"])
                            {
                                NSDictionary * param=@{@"orderId":ORDERID,@"type":USERTYPE};
                                [RequstEngine requestHttp:@"1035" paramDic:param blockObject:^(NSDictionary *dic) {
                                    DMLog(@"1035---%@",dic);
                                    DMLog(@"error---%@",dic[@"errorMsg"]);
                                    if ([dic[@"errorCode"] intValue]==00000) {
//                                        strMsg = @"支付结果：成功！";
//                                        DMLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                                        [alert show];
                                        [UIAlertView alertWithTitle:@"温馨提示" message:@"升级成功" buttonTitle:nil];
                                        [[NSNotificationCenter defaultCenter]postNotificationName:@"levelUp" object:nil];
                                    }else{
                                        
                                        [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                                        
                                    }


                                }];
                            }
                            else if ([WHICH isEqualToString:@"3"])
                            {
                                NSDictionary * param=@{@"orderId":ORDERID};
                                [RequstEngine requestHttp:@"1086" paramDic:param blockObject:^(NSDictionary *dic) {
                                    DMLog(@"1086---%@",dic);
                                    DMLog(@"error---%@",dic[@"errorMsg"]);
                                    if ([dic[@"errorCode"] intValue]==00000) {
//                                        strMsg = @"支付结果：成功！";
//                                        DMLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                                        [alert show];
                                        [[NSNotificationCenter defaultCenter]postNotificationName:@"transferSuccess" object:nil];
                                    }else{
                                        
                                        [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                                        
                                    }
                                    
                                    
                                }];

                            }
                            else
                            {
                                NSDictionary * param=@{@"orderId":ORDERID,@"payType":@"0"};
                                [RequstEngine requestHttp:@"1063" paramDic:param blockObject:^(NSDictionary *dic) {
                                    DMLog(@"1063---%@",dic);
                                    DMLog(@"error---%@",dic[@"errorMsg"]);
                                    if ([dic[@"errorCode"] intValue]==00000) {
//                                        strMsg = @"支付结果：成功！";
//                                        DMLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                                        [alert show];
                                        [UIAlertView alertWithTitle:@"温馨提示" message:@"充值成功" buttonTitle:nil];
                                        [[NSNotificationCenter defaultCenter]postNotificationName:@"backTopup" object:nil];
                                    }else{
                                        
                                        [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                                        
                                    }
                                    
                                }];
                            }
//                            strMsg = @"支付结果：成功！";
//                            DMLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                            [alert show];
                        }

                    }
                    else{
                        
                        [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                        
                    }
                }];
            }
                break;
                
            default:
//                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                 strMsg = [NSString stringWithFormat:@"支付结果：失败"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [newVC.view removeFromSuperview];
                [activityView stopAnimate];

                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
       //        [alert release];
    }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            DMLog(@"返回商家");
            
            
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"backToBusiness" object:nil];
//           [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
//            [self.]
        }
            break;
        case 1:
        {
            DMLog(@"查看订单");
            [[NSNotificationCenter defaultCenter]postNotificationName:@"inspectOrder" object:nil];
//            AppDelegate *app = [UIApplication sharedApplication].delegate;
//            OrderDetailViewController *test = [[OrderDetailViewController alloc] init];
//            test.orderID=ORDERID;
//            [app.con_mainNav pushViewController:test animated:YES];
        }
            break;
        default:
            break;
    }
}
- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvGetMessageReq:)]) {
            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *)req;
            [_delegate managerDidRecvGetMessageReq:getMessageReq];
        }
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvShowMessageReq:)]) {
            ShowMessageFromWXReq *showMessageReq = (ShowMessageFromWXReq *)req;
            [_delegate managerDidRecvShowMessageReq:showMessageReq];
        }
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvLaunchFromWXReq:)]) {
            LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
            [_delegate managerDidRecvLaunchFromWXReq:launchReq];
        }
    }
}

@end
