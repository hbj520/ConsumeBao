//
//  NSString+other.m
//  eShangBao
//
//  Created by Dev on 16/1/26.
//  Copyright © 2016年 doumee. All rights reserved.
//

#define KScreenW [UIScreen mainScreen].bounds.size.width
#define KScreenH  [UIScreen mainScreen].bounds.size.height

#import "NSString+other.h"
#include "NSDate+MJ.h"

@implementation NSString (other)

+(float)calculatemySizeWithFont:(NSInteger)Fone Text:(NSString *)string width:(CGFloat)aWidth
{
    NSDictionary *attr = @{NSFontAttributeName :[UIFont systemFontOfSize:Fone]};
    CGSize retSize = [string boundingRectWithSize:CGSizeMake(aWidth, MAXFLOAT)
                                          options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                       attributes:attr
                                          context:nil].size;
    return retSize.height;

}

+(CGSize)calculateSizeWithFont:(NSInteger)Fone Text:(NSString *)string
{
    NSDictionary *attr = @{NSFontAttributeName :[UIFont systemFontOfSize:Fone]};
    CGSize retSize = [string boundingRectWithSize:CGSizeMake(KScreenW-16, 0)
                                          options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                       attributes:attr
                                          context:nil].size;
    return retSize;
}

+(NSString *)showTimeFormat:(NSString *)timeStr
{
    double time=[timeStr doubleValue];
    NSDateFormatter * fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"YYYY-MM-dd-HH:mm:ss"];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:time/1000.0];
    NSString *newTime;
    if (createDate.isThisYear) {
        if (createDate.isToday) { // 今天
            NSDateComponents *cmps = [createDate deltaWithNow];
            if (cmps.hour >= 1) { // 至少是1小时前发的
                newTime=[NSString stringWithFormat:@"%ld小时前", (long)cmps.hour];
                
            } else if (cmps.minute >= 1) { // 1~59分钟之前发的
                
                newTime= [NSString stringWithFormat:@"%ld分钟前", (long)cmps.minute];
                
            } else { // 1分钟内发的
                newTime= @"刚刚";
            }
        } else if (createDate.isYesterday) { // 昨天
            //fmt.dateFormat = @"昨天 HH:mm";
            //newTime=[fmt stringFromDate:createDate];
            return @"昨天";
        } else { // 至少是前天
            // fmt.dateFormat = @"MM-dd HH:mm";
            fmt.dateFormat=@"MM-dd";
            
            newTime=[fmt stringFromDate:createDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM";
        newTime=[fmt stringFromDate:createDate];
    }
    
    return newTime;

}

+(NSString *)showTimeFormat:(NSString *)timeStr Format:(NSString *)format
{
    double time=[timeStr doubleValue];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"YYYY-MM-dd-HH:mm:ss"];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:time/1000.0];
    NSString *newTime;
    fmt.dateFormat = format;
    newTime=[fmt stringFromDate:createDate];
    return newTime;

}


+ (BOOL)validatePhone:(NSString *)phone
{
    NSString *phoneRegex = @"1[3|4|5|6|7|8|9|][0-9]{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}


+(BOOL)isLogin
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]==nil) {
        
        return NO;
        
    }
    return YES;
}

+(int)userType{
    
    int usertype=[[[NSUserDefaults standardUserDefaults] objectForKey:@"userType"] intValue];
    switch (usertype) {
        case 0:
        {
            return 0;
        }
            break;
        case 1:
        {
            return 1;
        }
            break;

        case 2:
        {
            return 2;
        }
            break;
        default:
            break;
    }
    return 0;
}


+ (BOOL)checkNumber:(NSString *)phone
{
    NSString *phoneRegex = @"^[0-9A-Za-z]{6,14}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}



@end
