//
//  ClassifyViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/22.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassifyViewController : UIViewController
@property (nonatomic,copy)void(^block)(NSDictionary *dic);

@property(nonatomic,assign)int classify;//判断是哪个页面跳过来的
@end
