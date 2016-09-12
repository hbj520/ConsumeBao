//
//  SYQMoneyTableViewCell.h
//  eShangBao
//
//  Created by Dev on 16/6/29.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYQMoneyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;//总钱
@property (weak, nonatomic) IBOutlet UIButton *reduction;//减号
@property (weak, nonatomic) IBOutlet UIButton *add;//加号
@property (weak, nonatomic) IBOutlet UILabel *numLabel;//数量
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;//确认够

@property (weak, nonatomic) IBOutlet UIImageView *xfzcImage;

@end
