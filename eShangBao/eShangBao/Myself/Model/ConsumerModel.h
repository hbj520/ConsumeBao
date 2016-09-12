//
//  ConsumerModel.h
//  eShangBao
//
//  Created by doumee on 16/1/30.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *  1003  个人资料接口
 */
@interface ConsumerModel : NSObject

@property(nonatomic,strong)NSString * memberid;//用户ID
@property(nonatomic,strong)NSString * name;//用户名
@property(nonatomic,strong)NSString * phone;//用户手机号
@property(nonatomic,strong)NSString * type;//会员身份会员身份 0普通会员 1合伙人 2商家;默认为0
@property(nonatomic,strong)NSString * imgUrl;//用户头像
@property(nonatomic,strong)NSString * loginName;//登录账号
@property(nonatomic,strong)NSString * sex;//用户性别0男 1女2未知；默认为2
@property(nonatomic,strong)NSString * birthday;//出生日期
@property(nonatomic,strong)NSString * age;//年龄
@property(nonatomic,strong)NSString * qq;//QQ号
@property(nonatomic,strong)NSString * email;//邮箱地址
@property(nonatomic,strong)NSString * provinced;//省份编码
@property(nonatomic,strong)NSString * provinceName;//省份名称
@property(nonatomic,strong)NSString * cityId;//城市编码
@property(nonatomic,strong)NSString * cityName;//城市名称
@property(nonatomic,strong)NSString * addr;//详细地址
@property(nonatomic,strong)NSString * goldNum;//通宝币数量；默认为0
@property(nonatomic,strong)NSString * openId;//微信标准
@property(nonatomic,strong)NSString * bankUsername;//开户人姓名
@property(nonatomic,strong)NSString * bankName;//开户行名称
@property(nonatomic,strong)NSString * bankNo;//银行卡号
@property(nonatomic,strong)NSString * partnerAgencyMethod;//代理费支付方式（0线上支付1线下支付）;默认为1 线下支付
@property(nonatomic,strong)NSString * partnerAgencyPayStatus;//代理费支付状态（0未支付1已支付）;默认为0 未支付
@property(nonatomic,strong)NSString * houseFund;//房基金;默认为0
@property(nonatomic,strong)NSString * carFund;//车基金;默认为0
@property(nonatomic,strong)NSString * payDate;//支付日期
@property(nonatomic,strong)NSString * parterLevel;//合伙人级别编码
@property(nonatomic,strong)NSString * levelname;//合伙人等级名称
@property(nonatomic,strong)NSString * inviteCode;//邀请码
@property(nonatomic,strong)NSString * bankAddr;//开户行所在地

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end


/*
 * 1017 收货地址列表
 */

@interface ReceiveAddrModel : NSObject

@property(nonatomic,strong)NSString * name;//收货人姓名
@property(nonatomic,strong)NSString * sex;//收货人性别
@property(nonatomic,strong)NSString * phone;//收货人手机号
@property(nonatomic,strong)NSString * positon;//定位地址
@property(nonatomic,strong)NSString * details;//楼号-门牌号
@property(nonatomic,strong)NSString * latitude;//经度
@property(nonatomic,strong)NSString * longitude;//纬度
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end



/*
 *  我的收藏列表 1053
 */

@interface MycollectModel : NSObject

//@property(nonatomic,strong)NSString * firstQueryTime;//第一次查询时间;只有当请求参数page为1时，才重新取值，否则page为>1的值时，均与page=1的值一样，保证查询值不重复
//@property(nonatomic,strong)NSString * totalCount;//记录总数
@property(nonatomic,strong)NSString * shopId;//用户ID
//@property(nonatomic,strong)NSString * objectId;
@property(nonatomic,strong)NSString * collectId;//收藏编码
@property(nonatomic,strong)NSString * shopName;//门店名称
@property(nonatomic,strong)NSString * branchName;//分店名称
@property(nonatomic,strong)NSString * branchPhone;//门店电话
@property(nonatomic,strong)NSString * province;//省份名称
@property(nonatomic,strong)NSString * city;//城市名称
@property(nonatomic,strong)NSString * score;//店铺评价得分
@property(nonatomic,strong)NSString * doorImg;//门店图片地址
@property(nonatomic,strong)NSString * monthOrderNum;//月销量
@property(nonatomic,strong)NSString * startSendPrice;//起送费
@property(nonatomic,strong)NSString * sendPrice;//配送费
@property(nonatomic,strong)NSString * replyNum;//评论数
@property(nonatomic,strong)NSString * distance;//距离
@property(nonatomic,strong)NSString * shopAddr;//店铺地址
@property(nonatomic,strong)NSString * objectId;//对象编码
@property(nonatomic,strong)NSString * shopreturnrate;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end


/*
 * 通宝币列表 1031
 */

@interface MycoinModel : NSObject

//@property(nonatomic,strong)NSString * totalCount;//记录总数
//@property(nonatomic,strong)NSString * firstQueryTime;//第一次查询时间
@property(nonatomic,strong)NSString * recordId;//编码
@property(nonatomic,strong)NSString * goldNum;//通宝币数量
@property(nonatomic,strong)NSString * createDate;//交易时间
@property(nonatomic,strong)NSString * content;//交易内容
@property(nonatomic,strong)NSString * type;//交易类型 0 收入 1 支出

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end


/*
 * 我的订单列表 1021
 */

@interface OrderModel : NSObject

@property(nonatomic,strong)NSString * orderId;//订单编码
@property(nonatomic,strong)NSString * shopId;//商家编码
@property(nonatomic,strong)NSString * shopName;//店铺名称
@property(nonatomic,strong)NSString * branchName;//分店名称
@property(nonatomic,strong)NSString * createDate;//下单时间
@property(nonatomic,strong)NSString * doorImg;//店铺头像
@property(nonatomic,strong)NSString * price;//订单总价
@property(nonatomic,strong)NSString * memberImgUrl;//买家头像
@property(nonatomic,strong)NSString * memberName;//买家昵称
@property(nonatomic,strong)NSString * status;//订单状态
@property(nonatomic,strong)NSString * isComment;//是否已评价
@property(nonatomic,strong)NSString * payMethod;//支付方式
@property(nonatomic,strong)NSString * goldNum;//消费通宝币数量

//数组
@property(nonatomic,strong)NSArray * addr;//收货地址
@property(nonatomic,strong)NSArray * goodsList;//订单明细a
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end

/*
 * 商家分类列表  1008
 */

@interface ClassifyModel : NSObject

@property(nonatomic,strong)NSString * cateId;//分类标识（唯一）
@property(nonatomic,strong)NSString * cateName;//分类名称
@property(nonatomic,strong)NSString * iconUrl;//分类图标地址

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end

/*
 * 1030 我的推荐列表
 */

@interface RecommendModel : NSObject

@property(nonatomic,strong)NSString * memberId;//会员编码
@property(nonatomic,strong)NSString * memberName;//会员姓名
@property(nonatomic,strong)NSString * createDate;//加入时间
@property(nonatomic,strong)NSString * imgUrl;//头像地址
@property(nonatomic,strong)NSString * levelName;//等级名称
@property(nonatomic,strong)NSString * goldNum;//通宝币数量
@property(nonatomic,strong)NSString * payStatus;//支付状态0未支付 1已支付
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end



/*
 *  1017  用户地址列表
 */

@interface AddressModel : NSObject

@property(nonatomic,strong)NSString * name;//收货人姓名
@property(nonatomic,strong)NSString * sex;//收货人性别
@property(nonatomic,strong)NSString * phone;//收货人手机号
@property(nonatomic,strong)NSString * positon;//定位地址
@property(nonatomic,strong)NSString * details;//楼号-门牌号
@property(nonatomic,strong)NSString * latitude;//经度
@property(nonatomic,strong)NSString * longitude;//纬度
@property(nonatomic,strong)NSString * addrId;//

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end

/*
 *  我是商家--订单列表
 */
@interface MyOrderModel : NSObject

@property(nonatomic,retain)NSString * orderId;
@property(nonatomic,retain)NSString * shopName;
@property(nonatomic,retain)NSString * createDate;
@property(nonatomic,retain)NSString * doorImg;
@property(nonatomic,retain)NSString * price;
@property(nonatomic,retain)NSString * status;
@property(nonatomic,retain)NSString * isComment;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end

/*
 * 1076  账单列表
 */

@interface BillModel : NSObject

@property(nonatomic,retain)NSString * accountId;//标识（唯一）
@property(nonatomic,retain)NSString * money;//账单金额
@property(nonatomic,retain)NSString * remain;//账户余额
@property(nonatomic,retain)NSString * createDate;//创建时间
@property(nonatomic,retain)NSString * info;//描述
@property(nonatomic,retain)NSString * type;//类型 0 收入 1支出

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end

/*
 *  1090 已购买收益权列表
 */

@interface PurchaseProfitModel : NSObject

@property(nonatomic,retain)NSString * createDate;//购买日期
@property(nonatomic,retain)NSString * num;//购买数量
@property(nonatomic,retain)NSString * outDate;//到期日期
@property(nonatomic,retain)NSString * payStatus;//支付状态
@property(nonatomic,retain)NSString * status;//状态

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end

/*
 *  1091 收益权分红列表
 */

@interface ProfitShareModel : NSObject

@property(nonatomic,retain)NSString * num;//

@property(nonatomic,retain)NSString * createDate;//

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
