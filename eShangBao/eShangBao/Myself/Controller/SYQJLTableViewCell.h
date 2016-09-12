//
//  SYQJLTableViewCell.h
//  eShangBao
//
//  Created by Dev on 16/7/6.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsumerModel.h"
@interface SYQJLTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *gmNum;//购买数量
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;//头图片
@property (weak, nonatomic) IBOutlet UILabel *zfType;//支付状态
@property (weak, nonatomic) IBOutlet UILabel *startDate;
@property (weak, nonatomic) IBOutlet UILabel *endDate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


//分红
@property (weak, nonatomic) IBOutlet UILabel *createDate;
@property (weak, nonatomic) IBOutlet UILabel *incomeNum;

@property (nonatomic,copy) PurchaseProfitModel * infoModel;
@end
