//
//  FillMsgViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/15.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FillMsgViewController : UIViewController

@property(nonatomic,retain)UIButton * forkBtn;

@property(nonatomic,retain)UITextField * inviteTF;//邀请码输入框

@property(nonatomic,retain)UITextField * mainTF;//门店名称输入框

@property(nonatomic,retain)UITextField * branchTF;//分店名称输入框

@property(nonatomic,retain)UITextField * phoneTF;//门店电话输入框

@property(nonatomic,retain)UITextField * telephoneTF;//手机号码输入框

@property(nonatomic,retain)UITextField * nameTF;//真是姓名输入框

@property(nonatomic,retain)UITextField * idNumberTF;//身份证号输入框

@property(nonatomic,retain)UITextField * loginTF;//登录名输入框

@property(nonatomic,retain)UIButton * saveBtn;

@property (nonatomic,retain)NSString * latitude;

@property (nonatomic,retain)NSString * longitude;

@property(nonatomic,strong)NSString * whichPage;

@property(nonatomic,strong)NSString * vctype;
@end
