//
//  UIViewController+root.h
//  eShangBao
//
//  Created by Dev on 16/1/19.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (root)

/**
 *  去掉返回的文字
 */
-(void)backButton;
/**
 *  去掉上一个头标题文字比较多的时候
 */
-(void)backOtherButton;

-(void)loginUser;

@end
