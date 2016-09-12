//
//  CityModel.m
//  eShangBao
//
//  Created by doumee on 16/2/25.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "CityModel.h"
#import "HomeModel.h"
@implementation CityModel

+(instancetype)deliveryGroupWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
        
        NSMutableArray * cityArr=[NSMutableArray array];
        for (NSDictionary *dic in _lstCity) {
            ProvinceModel *model=[ProvinceModel deliveryWithDict:dic];
            [cityArr addObject:model];
        }
        _lstCity=cityArr;
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{};

@end
