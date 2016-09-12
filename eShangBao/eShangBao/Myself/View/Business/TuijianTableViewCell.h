//
//  TuijianTableViewCell.h
//  eShangBao
//
//  Created by doumee on 16/2/17.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TuijianTableViewCell : UITableViewCell

@property(nonatomic,retain)UIImageView * headImg;//推荐头像

@property(nonatomic,retain)UILabel * nameLabel;//推荐名称

@property(nonatomic,retain)UILabel * payMoneyLabel;//消费金额

@property(nonatomic,retain)UILabel * returnCoinLabel;//返币数量

@property(nonatomic,retain)UILabel * levelLabel;

@property(nonatomic,retain)UILabel * payStatusLabel;
@end
