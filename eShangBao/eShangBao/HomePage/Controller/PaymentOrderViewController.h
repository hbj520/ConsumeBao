//
//  PaymentOrderViewController.h
//  eShangBao
//
//  Created by doumee on 16/7/1.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerDataModel.h"
#import "ConsumerModel.h"
#import "HomeModel.h"
@interface PaymentOrderViewController : UIViewController
@property(nonatomic,strong)AddressModel           *chooseAddr;
@property(nonatomic,strong)GroundingModel         *groundingModel;

@property(nonatomic ,strong)NSMutableDictionary   *chooseListDic;//定单的内容
@property(nonatomic ,strong)NSMutableArray        *chooseListArr;//订单商品的ID
@property(nonatomic,strong)SellerInfoModel               *shopInfo;//
@property(nonatomic,strong)ShoppingModel                 *shoppingInfo;
@property(nonatomic,assign)float chooseTotalMoney;
@property(nonatomic,assign)int    whichPage;//0 商家，1 直营超市

@property(nonatomic,strong)NSString * orderName;//订单名称

@property(nonatomic,strong)NSString * orderPrice;//订单金额
@end
