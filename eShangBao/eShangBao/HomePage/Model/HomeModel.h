//
//  HomeModel.h
//  eShangBao
//
//  Created by doumee on 16/1/30.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject

@end


/**
 *  1011 广告列表接口
 */

@interface adModel : NSObject

@property(nonatomic,strong)NSString * adid;//ID
@property(nonatomic,strong)NSString * title;//标题
@property(nonatomic,strong)NSString * content;//详细内容
@property(nonatomic,strong)NSString * imgUrl;//图片链接
@property(nonatomic,strong)NSString * startDate;//开始时间
@property(nonatomic,strong)NSString * endDate;//结束时间
@property(nonatomic,strong)NSString * isLink;//是否外链接  0 不是；1 是

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end

/**
 *  1005  首页活动列表
 */

@interface activityModel : NSObject

@property(nonatomic,strong)NSString * activityID;//活动标识
@property(nonatomic,strong)NSString * imgUrl;//图片地址
@property(nonatomic,strong)NSString * isLink;//是否为外链接  0 不是；1 是
@property(nonatomic,strong)NSString * title;//活动标题
@property(nonatomic,strong)NSString * content;// 详细内容 ，如果isLink为0，内容为html格式，如果isLink为1，内容为外链接地址

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end


/*
 * 1023 合伙人\商家 等级列表
 */

@interface levelModel : NSObject

@property(nonatomic,strong)NSString * levelId;//等级编码
@property(nonatomic,strong)NSString * name;//等级名称
@property(nonatomic,strong)NSString * firstRebate;//一级返利
@property(nonatomic,strong)NSString * secondRebate;//二级返利
@property(nonatomic,strong)NSString * thirdRebate;//三级返利
@property(nonatomic,strong)NSString * price;//价格
@property(nonatomic,strong)NSString * baseReb;//基本返利
@property(nonatomic,strong)NSString * serviceYear;//服务年限
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end

/*
 *  1050 省份列表
 */

@interface ProvinceModel : NSObject

@property(nonatomic,retain)NSString * name;//省份名称
@property(nonatomic,retain)NSString * provinceId;//省份编码
@property(nonatomic,strong)NSArray  *lstCity;



+(instancetype)deliveryWithDict:(NSDictionary *)dict;
@end


/*
 * 1067 消费报直营超市商品列表接口
 */

@interface GroundingModel : NSObject

@property(nonatomic,retain)NSString * goodsId;//商品标识（唯一）
@property(nonatomic,retain)NSString * goodsName;//商品名称
@property(nonatomic,retain)NSString * imgUrl;//商品首图
@property(nonatomic,retain)NSString * monthOrderNum;//月售量
@property(nonatomic,retain)NSString * price;//单价 单位元
@property(nonatomic,retain)NSString * shopId;//所属店铺编码
@property(nonatomic,retain)NSString * shopName;//店铺名称;
@property(nonatomic,retain)NSString * branchName;//分店名称
@property(nonatomic,retain)NSString * returnBate;//商家返币比例
@property(nonatomic,retain)NSString * createDate;//创建时间
@property(nonatomic,retain)NSString * stockNum;//库存量
@property(nonatomic,retain)NSString * isDeleted;//是否已下架 0 未下架 1已下架
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end

/*
 *  1073 商品评价列表接口
 */
@interface CommentModel : NSObject

@property(nonatomic,retain)NSString * commentId;//评论编码
@property(nonatomic,retain)NSString * content;//评价内容
@property(nonatomic,retain)NSString * createdate;//发布时间
@property(nonatomic,retain)NSString * memberId;//用户编码
@property(nonatomic,retain)NSString * memberImgUrl;//评论人头像
@property(nonatomic,retain)NSString * memberName;//用户昵称
@property(nonatomic,retain)NSString * score;//打分
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end

/*
 *  1072  购物车商品列表接口
 */
@interface ShoppingModel : NSObject

@property(nonatomic,retain)NSString * goodsId;//商品标识（唯一）
@property(nonatomic,retain)NSString * goodsName;//商品名称
@property(nonatomic,retain)NSString * imgUrl;//商品首图
@property(nonatomic,retain)NSString * num;//购物车数量
@property(nonatomic,retain)NSString * price;//单价 单位元
@property(nonatomic,retain)NSString * shopcartId;//购物车记录编码
@property(nonatomic,retain)NSString * isDeleted;//是否已下架 0 未下架 1已下架
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end

@interface ProjectIntroductionModel : NSObject

@property (nonatomic,strong)NSString *name;//xx合伙人
@property (nonatomic,strong)NSString *price;//加盟费
@property (nonatomic,strong)NSString *firstRebate;
@property (nonatomic,strong)NSString *icon;
@property (nonatomic,strong)NSString *imgUrl;
@property (nonatomic,strong)NSString *levelId;
@property (nonatomic,strong)NSString *secondRebate;
@property (nonatomic,strong)NSString *serviceYear;
@property (nonatomic,strong)NSString *thirdRebate;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *benefit;
@property (nonatomic,strong)NSString *score;
@property (nonatomic,strong)NSString *info;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;


@end


@interface UsufructModel : NSObject

@property (nonatomic,strong)NSString *createDate;
@property (nonatomic,strong)NSString *rate;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end

/*
 *  1092 合伙人商品购买记录列表
 */

@interface PurchaseRecordModel : NSObject

@property(nonatomic,strong)NSString *memberId;//购买会员编码
@property(nonatomic,strong)NSString *memberImgUrl;//购买会员头像
@property(nonatomic,strong)NSString *memberName;//购买会员姓名
@property(nonatomic,strong)NSString *buyDate;//购买时间

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end




