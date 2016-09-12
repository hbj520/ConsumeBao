//
//  BrokenLineView.h
//  eShangBao
//
//  Created by Dev on 16/6/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrokenLineView : UIView


@property(nonatomic,assign)float abscissaMax;//最大的横坐标
@property(nonatomic,assign)float ordinateMax;//最大的纵坐标
@property(nonatomic,assign)int   abscissaNum;//横坐标数量
@property(nonatomic,assign)int   ordinateNum;//纵坐标数量
@property(nonatomic,strong)NSString *maxStr;
@property(nonatomic,strong)NSString *minStr;

@property(nonatomic,strong)NSMutableDictionary *abscissaArr;
@property(nonatomic,strong)NSMutableArray *dateArr;//日期数组

@end
