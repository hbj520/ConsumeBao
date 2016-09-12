//
//  UUID.m
//  divorce_ios
//
//  Created by liuyu on 15-1-4.
//  Copyright (c) 2015年 liuyu. All rights reserved.
//

#import "UUID.h"

@implementation UUID

+ (NSString *)uuid
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    //return [uuid stringByAppendingFormat:@".png"];
    return uuid;
}


+ (NSString *)yyyyMMdd_Date
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"YYYYMMdd"];
    NSString *locationString = [df stringFromDate:nowDate];
    return locationString;
}
@end
