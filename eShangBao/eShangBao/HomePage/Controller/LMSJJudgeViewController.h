//
//  LMSJJudgeViewController.h
//  eShangBao
//
//  Created by doumee on 16/7/4.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerDataModel.h"
#import "OrderDataModel.h"
@interface LMSJJudgeViewController : UIViewController

@property(nonatomic,strong)OrderInfoModel *infoModel;

@property(nonatomic,strong)NSString * headImgUrl;//店铺头像

@property(nonatomic,strong)NSString * shopName;//店铺名称

@property(nonatomic,strong)NSString * judge;//店铺评分

@property(nonatomic,strong)NSString * shopId;

@property(nonatomic,strong)NSString * price;

@property(nonatomic,strong) NSString *orderId;

@end
