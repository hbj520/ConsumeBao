//
//  OrderInfoTableViewCell.h
//  eShangBao
//
//  Created by Dev on 16/1/27.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *storeName;//店铺名字


@property (weak, nonatomic) IBOutlet UILabel *goodsName;//商品名称
@property (weak, nonatomic) IBOutlet UILabel *goodsNum;//数量
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;//单价

@property (weak, nonatomic) IBOutlet UILabel *distributionNum;


@property (weak, nonatomic) IBOutlet UILabel *vouchersNum;//抵用

@property (weak, nonatomic) IBOutlet UILabel *totalNum;//总价格
@property (weak, nonatomic) IBOutlet UILabel *actualPrice;//实际支付

@property (weak, nonatomic) IBOutlet UILabel *immediatelyGo;//立即配送
@property (weak, nonatomic) IBOutlet UILabel *cell6Name;//


@property (weak, nonatomic) IBOutlet UILabel *userNameAndPhone;//用户名字电话
@property (weak, nonatomic) IBOutlet UILabel *userAddress;//用户地址

@property (weak, nonatomic) IBOutlet UILabel *getNum;//获得的返回币

@property (weak, nonatomic) IBOutlet UIButton *storeInfoBtn;


@end
