//
//  PartnerPayViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/16.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartnerPayViewController : UIViewController

@property(nonatomic,retain)UIButton * goldBtn;

@property(nonatomic,retain)UIButton * platinumBtn;

@property(nonatomic,retain)UIButton * diamondBtn;

@property (nonatomic,retain)UIButton * sureBtn;

@property (nonatomic,retain)UIButton * accomplishBtn;

@property(nonatomic,retain)UIButton * weixinBtn;

@property(nonatomic,retain)UIButton * zhifubaoBtn;

@property(nonatomic,retain)UIButton * payinCashBtn;

@property(nonatomic,copy)NSString * name;//合伙人姓名

@property(nonatomic,copy)NSString * idcard;//合伙人身份证号

@property(nonatomic,copy)NSString * inviteCode;//合伙人邀请码

@property(nonatomic,retain)NSString * tuiName;//推荐人姓名

@property(nonatomic,retain)NSString * phone;//推荐人手机号

@property(nonatomic,retain)NSString * idNumber;//推荐人身份证号

@property(nonatomic,retain)NSString * etype;//推荐身份

@property(nonatomic,retain)NSString * payType;//支付方式

@property(nonatomic,retain)NSString * loginName;

@property(nonatomic,assign)int whichPage;//从哪个页面跳转过来


@end
