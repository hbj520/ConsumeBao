//
//  CoinModel.h
//  eShangBao
//
//  Created by doumee on 16/1/30.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoinModel : NSObject
@property(nonatomic,strong)NSString * totalCount;//记录总数
@property(nonatomic,strong)NSString * firstQueryTime;//第一次查询时间
@property(nonatomic,strong)NSString * recordId;//编码
@property(nonatomic,strong)NSString * goldNum;//通宝币数量
@property(nonatomic,strong)NSString * createDate;//交易时间
@property(nonatomic,strong)NSString * content;//交易内容
@property(nonatomic,strong)NSString * type;//交易类型 0 收入 1 支出
+(instancetype)coinWithDict:(NSDictionary *)dict;
@end
