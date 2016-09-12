//
//  CollectTableViewCell.h
//  eShangBao
//
//  Created by doumee on 16/1/18.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectTableViewCell : UITableViewCell
@property(nonatomic,retain)UIImageView * headImg;

@property(nonatomic,retain)UILabel * titleLabel;

@property(nonatomic,retain)UILabel * backLabel;

@property(nonatomic,copy)UIButton * starBtn;

@property(nonatomic,retain)UIButton * simmilorBtn;
@end
