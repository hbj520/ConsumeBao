//
//  OrderDataModel.h
//  eShangBao
//
//  Created by Dev on 16/1/30.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDataModel : NSObject

@end
/**
 *   1021  我的订单的详情
 */
@interface OrderInfoModel : NSObject

@property(nonatomic,strong)NSString        *orderId;//订单编码
@property(nonatomic,strong)NSString        *shopId;//商家编码
@property(nonatomic,strong)NSString        *shopName;//商家名称
@property(nonatomic,strong)NSString        *branchName;//分店名称
@property(nonatomic,strong)NSString        *createDate;//下单时间
@property(nonatomic,strong)NSString        *doorImg;//店铺头像
@property(nonatomic,strong)NSString        *price;//订单总价
@property(nonatomic,strong)NSString        *memberImgUrl;//买家头像
@property(nonatomic,strong)NSString        *memberName;//买家昵称
@property(nonatomic,strong)NSString        *status;//订单状态
@property(nonatomic,strong)NSString        *isComment;//是否评价
@property(nonatomic,strong)NSString        *payMethod;//支付方式
@property(nonatomic,strong)NSString        *goldNum;//消费通宝币数量
@property(nonatomic,strong)NSString        *shopMobile;//商家电话
@property(nonatomic,strong)NSString        *sendPrice;//配送费
@property(nonatomic,strong)NSString        *backGoldNum;
@property(nonatomic,strong)NSString        *orderType;//订单类型
@property(nonatomic,strong)NSString        *totalPrice;
@property(nonatomic,strong)NSString        *paramStr;
//数组
@property(nonatomic,strong)NSDictionary    *addr;//具体地址信息
//@property(nonatomic,strong)NSDictionary    *param; 
@property(nonatomic,strong)NSArray         *goodsList;//订单详细

//自定义参数
@property(nonatomic,strong)NSString         *firstQueryTime;//时间
@property(nonatomic,strong)NSString         *page;//页码
@property(nonatomic,strong)NSString         *totalCount;//总数

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end

@interface OrderGoodsList : NSObject


@property(nonatomic,strong)NSString       *goodsId;
@property(nonatomic,strong)NSString       *goodsImg;
@property(nonatomic,strong)NSString       *goodsName;
@property(nonatomic,strong)NSString       *goodsNum;
@property(nonatomic,strong)NSString       *goodsPrice;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end

