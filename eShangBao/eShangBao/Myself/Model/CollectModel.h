//
//  CollectModel.h
//  eShangBao
//
//  Created by doumee on 16/1/30.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectModel : NSObject

@property(nonatomic,strong)NSString * firstQueryTime;//第一次查询时间;只有当请求参数page为1时，才重新取值，否则page为>1的值时，均与page=1的值一样，保证查询值不重复
@property(nonatomic,strong)NSString * totalCount;//记录总数
@property(nonatomic,strong)NSString * shopId;//用户ID
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
+(instancetype)collectWithDict:(NSDictionary *)dict;
@end

/**
 *  商家类别
 */
@interface categoryListModel : NSObject

@property(nonatomic,strong)NSString  *cateId;
@property(nonatomic,strong)NSString  *cateName;
@property(nonatomic,strong)NSString  *productNum;
@property(nonatomic,strong)NSString  *sortNum;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end

/**
 *  1039 商品详情
 */

@interface GoodsInfoModel : NSObject

@property(nonatomic,strong)NSString  *barCode;
@property(nonatomic,strong)NSString  *branchName;
@property(nonatomic,strong)NSString  *goodsId;
@property(nonatomic,strong)NSString  *goodsName;
@property(nonatomic,strong)NSString  *imgUrl;
@property(nonatomic,strong)NSString  *monthOrderNum;
@property(nonatomic,strong)NSString  *price;
@property(nonatomic,strong)NSString  *returnBate;
@property(nonatomic,strong)NSString  *shopId;
@property(nonatomic,strong)NSString  *shopName;
@property(nonatomic,strong)NSString  *stock;//库存
@property(nonatomic,strong)NSArray   *imgList;//商品列表
@property(nonatomic,strong)NSString  *details;//描述
@property(nonatomic,strong)NSString  *categoryId;
@property(nonatomic,strong)NSString  *categoryName;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end

@interface VIPModel : NSObject

@property(nonatomic,strong)NSString * memberId;//会员编码
@property(nonatomic,strong)NSString * memberImgUrl;//会员头像
@property(nonatomic,strong)NSString * memberName;//会员姓名
@property(nonatomic,strong)NSString * lockDate;//锁定时间

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end

