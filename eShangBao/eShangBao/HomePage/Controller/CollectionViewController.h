//
//  CollectionViewController.h
//  eShangBao
//
//  Created by doumee on 16/7/2.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerDataModel.h"
@interface CollectionViewController : UIViewController

@property(nonatomic,strong)SellerInfoModel *infoModel;

@property(nonatomic,strong)NSString * headImgUrl;

@property(nonatomic,strong)NSString * loginName;

@property(nonatomic,strong)NSString * phone;

@property(nonatomic,strong)NSString * shopName;

@property(nonatomic,strong)NSString * returnBate;

@property(nonatomic,strong)NSString * goldNum;

@property(nonatomic,strong)NSString * shopId;
//@property(nonatomic,strong)NSString * headImgUrl;//店铺头像
@property(nonatomic,strong)NSString * judge;//店铺评分

@property(nonatomic,strong)NSString * whichPage;
@end
