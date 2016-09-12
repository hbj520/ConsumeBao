//
//  OrderTableViewCell.h
//  eShangBao
//
//  Created by doumee on 16/1/25.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDataModel.h"



@interface OrderTableViewCell : UITableViewCell<UIAlertViewDelegate>

@property(nonatomic,strong)OrderInfoModel   *orderInfo;

@property(nonatomic,retain)UILabel * titleLabel;

@property(nonatomic,retain)UILabel * stateLabel;

@property(nonatomic,retain)UIImageView * headImg;

@property(nonatomic,retain)UILabel * moneyLabel;

@property(nonatomic,copy)UILabel * dateLabel;

@property(nonatomic,copy)UIButton * commentBtn;

@property(nonatomic,copy)UIButton * againBtn;

@property(nonatomic,copy)UIButton * gotoBtn;

@property(nonatomic,copy)UIButton * payOrderBtn;

@property(nonatomic,copy)UIButton * cancelBtn;//取消订单

@property(nonatomic,retain)NSString * orderID;

@property(nonatomic,retain)UILabel * tongbaibiLabel;
@end
