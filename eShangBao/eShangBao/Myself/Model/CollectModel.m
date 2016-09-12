//
//  CollectModel.m
//  eShangBao
//
//  Created by doumee on 16/1/30.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "CollectModel.h"

@implementation CollectModel

+(instancetype)collectWithDict:(NSDictionary *)dict{
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

@implementation categoryListModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

@implementation GoodsInfoModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

@implementation VIPModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end  