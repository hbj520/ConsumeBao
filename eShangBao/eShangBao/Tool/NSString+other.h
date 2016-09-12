 //
//  NSString+other.h
//  eShangBao
//
//  Created by Dev on 16/1/26.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (other)


/**
 *  计算在宽度一定的时候的字符高度
 *
 *  @param Fone   字体大小
 *  @param string 计算的字符
 *  @param aWidth 最大宽度
 *
 *  @return 字符的高度
 */
+(float)calculatemySizeWithFont:(NSInteger)Fone Text:(NSString *)string width:(CGFloat)aWidth;

/**
 *  一般的情况下的字符的宽高计算
 *
 *  @param Fone   字符的大小
 *  @param string 需计算的字符
 *
 *  @return 返回自字符的宽高
 */
+(CGSize)calculateSizeWithFont:(NSInteger)Fone Text:(NSString *)string ;

/**
 *  转换时间戳的时间并计算时间
 *
 *  @param timeStr 输入时间戳
 *
 *  @return 时间
 */
+(NSString *)showTimeFormat:(NSString *)timeStr;

/**
 *  转换时间戳并输出自定义的格式
 *
 *  @param timeStr 需转换的时间
 *  @param format  需转换的格式
 *
 *  @return 返回自定义的时间
 */
+(NSString *)showTimeFormat:(NSString *)timeStr Format:(NSString *)format;
/**
 *  正则判断是否为手机号码
 *
 *  @param phone 需判断的字符
 *
 *  @return 判断结果
 */
+ (BOOL)validatePhone:(NSString *)phone;

/**
 *  判断是非登录
 *
 *  @return YES 登录过 NO 没有 
 */
+ (BOOL)isLogin;
/**
 *  用户类型  0 普通会员 1 合伙人 2 商家
 *
 *  @return 默认为 0
 */
+ (int)userType;


+ (BOOL)checkNumber:(NSString *)phone;

@end
