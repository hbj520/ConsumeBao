//
//  CoinModel.m
//  eShangBao
//
//  Created by doumee on 16/1/30.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "CoinModel.h"

@implementation CoinModel
+(instancetype)coinWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{};

@end
