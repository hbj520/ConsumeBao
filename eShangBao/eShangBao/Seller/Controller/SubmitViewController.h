//
//  SubmitViewController.h
//  eShangBao
//
//  Created by Dev on 16/1/21.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerDataModel.h"
#import "ConsumerModel.h"
#import "HomeModel.h"
@interface SubmitViewController : UIViewController

@property(nonatomic,strong)AddressModel           *chooseAddr;

@property(nonatomic,strong)NSString               *shopId;
@property(nonatomic ,strong)NSMutableDictionary   *chooseListDic;//定单的内容
@property(nonatomic ,strong)NSMutableArray        *chooseListArr;//订单商品的ID
@property(nonatomic,strong)SellerInfoModel               *shopInfo;//
@property(nonatomic,strong)ShoppingModel                 *shoppingInfo;
@property(nonatomic,assign)float chooseTotalMoney;
@property(nonatomic,assign)int    whichPage;//0 商家，1 直营超市
@property (weak, nonatomic) IBOutlet UILabel *preferentialNum;//优惠的
@property (weak, nonatomic) IBOutlet UILabel *needPayNum;//还需支付的
@property (nonatomic,retain)NSString * deliveryFee;
@end
