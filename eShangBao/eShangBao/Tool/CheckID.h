//
//  CheckID.h
//  eShangBao
//
//  Created by doumee on 16/3/10.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckID : NSObject
+ (BOOL)verifyIDCardNumber:(NSString *)value;
@end
