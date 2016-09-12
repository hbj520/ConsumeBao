//
//  CoinViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/19.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoinViewController : UIViewController

@property(nonatomic,retain)UITableView * tableView;

@property(nonatomic,retain)NSMutableArray * dataArr;

@property(nonatomic,retain)NSMutableArray * getCoinArr;//收入通宝币数组

@property(nonatomic,retain)NSMutableArray * payCoinArr;//支出通宝币数组

@property(nonatomic,retain)NSString * bankNo;

@property(nonatomic,retain)NSString * goldNum;//通宝币数量

@property(nonatomic,retain)NSString * carFund;//车基金

@property(nonatomic,retain)NSString * houseFund;//房基金

@property(nonatomic,retain)UILabel *  moneyLabel;//

@property(nonatomic,retain)NSString * memberType;
@end
