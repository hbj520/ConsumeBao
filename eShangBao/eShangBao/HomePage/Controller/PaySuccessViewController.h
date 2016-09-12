//
//  PaySuccessViewController.h
//  eShangBao
//
//  Created by doumee on 16/7/16.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDataModel.h"
@interface PaySuccessViewController : UIViewController

@property(nonatomic,strong)UILabel * shopNameLabel;

@property(nonatomic,strong)UILabel * priceLabel;

@property(nonatomic,strong)UILabel * priceDetailsLabel;

@property(nonatomic,strong)UILabel * statusLabel;

@property(nonatomic,strong)UILabel * discountLabel;

@property(nonatomic,strong)UILabel * dateLabel;

@property(nonatomic,strong)UILabel * orderNumLabel;

@property(nonatomic,strong)UILabel * shopNamesLabel;

@property(nonatomic,strong)NSString * orderId;

@property(nonatomic,strong)UILabel * otherPayLabel;

@property(nonatomic,strong)UILabel * goldNumLabel;

@property(nonatomic,strong)UILabel * payStyleLabel;

@property(nonatomic,strong)NSString * whichPage;

@property(nonatomic,strong)NSString * buyOrSeller;

@property(nonatomic,strong)OrderInfoModel *model;

@property(nonatomic,strong)NSString * upOrDown;

@property(nonatomic,strong)NSString * status;
@end
