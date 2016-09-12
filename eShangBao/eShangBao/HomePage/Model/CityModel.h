//
//  CityModel.h
//  eShangBao
//
//  Created by doumee on 16/2/25.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject

@property(nonatomic,retain)NSArray * lstCity;//城市数组
@property(nonatomic,retain)NSString * cityId;//城市编码
@property(nonatomic,retain)NSString * cityName;//城市名称
@property(nonatomic,retain)NSString * provinceid;//
@property(nonatomic,retain)NSString * id;
@property(nonatomic,retain)NSString * name;
+(instancetype)deliveryGroupWithDict:(NSDictionary *)dict;
@end
