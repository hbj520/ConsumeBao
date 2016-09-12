//
//  BusinessViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/20.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessViewController : UIViewController
@property(nonatomic,retain)UILabel * moneyLabel;

@property(nonatomic,retain)UILabel * countLabel;

@property(nonatomic,retain)UILabel * zheqianLabel;

@property(nonatomic,retain)UILabel * withdrawMoneyLabel;

@property(nonatomic,retain)NSString * useType;

@property(nonatomic,strong)NSString * isShop;//是否是联盟商家

@property(nonatomic,strong)NSString * partnerAgencyPayStatus;//支付状态

@property(nonatomic,strong)NSString * shopId;

@property(nonatomic,strong)UIButton * jumpBtn;
@end
