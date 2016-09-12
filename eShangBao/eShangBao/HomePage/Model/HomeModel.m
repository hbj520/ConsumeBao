//
//  HomeModel.m
//  eShangBao
//
//  Created by doumee on 16/1/30.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

@end

@implementation adModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end


@implementation activityModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

@implementation levelModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

@implementation ProvinceModel

+(instancetype)deliveryWithDict:(NSDictionary *)dict
{
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

@implementation GroundingModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

@implementation CommentModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

@implementation ShoppingModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

@implementation ProjectIntroductionModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

@implementation UsufructModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

@implementation PurchaseRecordModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end