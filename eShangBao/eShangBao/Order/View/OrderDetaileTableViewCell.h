//
//  OrderDetaileTableViewCell.h
//  eShangBao
//
//  Created by Dev on 16/1/27.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetaileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *completeTime;

@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *roadTime;

@property (weak, nonatomic) IBOutlet UILabel *payTime;
@property (weak, nonatomic) IBOutlet UILabel *payName;//是否支付完成

@property (weak, nonatomic) IBOutlet UILabel *submitTime;

@property (weak, nonatomic) IBOutlet UILabel *cancelTime;
@property (weak, nonatomic) IBOutlet UILabel *shopComplete;

//需判断是否需要显示
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UILabel *endOrder;

//判断要不要显示线条

@property (weak, nonatomic) IBOutlet UIImageView *submitLable;
@property (weak, nonatomic) IBOutlet UIImageView *payLabel;

@property (weak, nonatomic) IBOutlet UIImageView *roadLabel;




@end
