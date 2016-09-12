//
//  BillTableViewCell.h
//  eShangBao
//
//  Created by doumee on 16/1/29.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillTableViewCell : UITableViewCell

@property(nonatomic,retain)UILabel * timeLabel;// 时间

@property(nonatomic,retain)UILabel * countLabel;// 支出，收入

@property(nonatomic,retain)UILabel * balanceLabel;// 余额

@property(nonatomic,retain)UILabel * storeLabel;// 店名
@end
