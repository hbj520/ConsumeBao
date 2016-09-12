//
//  FillImageMsgViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/15.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FillImageMsgViewController : UIViewController

@property (nonatomic,retain)NSString * inviteCode;//邀请码

@property (nonatomic,retain)NSString * shopName;//门店名称

@property (nonatomic,retain)NSString * branchName;//分店名称

@property (nonatomic,retain)NSString * branchPhone;//门店电话

@property (nonatomic,retain)NSString * shopAddr;//门店地址

@property (nonatomic,retain)NSString * categoryId;//经营分类编码

@property (nonatomic,retain)NSString * name;//真实姓名

@property (nonatomic,retain)NSString * idcardno;//身份证号

@property (nonatomic,retain)NSString * latitude;

@property (nonatomic,retain)NSString * longitude;

@property (nonatomic,retain)NSString * doorImg;

@property (nonatomic,retain)NSString * businessImg;

@property (nonatomic,retain)NSString * licenseImg;

@property (nonatomic,strong)NSString * whichPage;

@property (nonatomic,strong)NSString * vctype;

@property (nonatomic,strong)NSString * phone;

@property (nonatomic,strong)NSString * cityId;//城市编码

@property (nonatomic,strong)NSString * cityName;//城市名称

@property (nonatomic,strong)NSString * provinceId;//省份编码

@property (nonatomic,strong)NSString * provinceName;//省份名称

@property (nonatomic,strong)NSString * loginName;
@end
