//
//  ManageOrderTableViewCell.h
//  eShangBao
//
//  Created by doumee on 16/1/21.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageOrderTableViewCell : UITableViewCell

//orderCell
@property (weak, nonatomic) IBOutlet UILabel *orderCode;//订单号
@property (weak, nonatomic) IBOutlet UILabel *payState;//支付状态
@property (weak, nonatomic) IBOutlet UILabel *userName;//买家姓名
@property (weak, nonatomic) IBOutlet UILabel *userPhone;//电话
@property (weak, nonatomic) IBOutlet UILabel *userAddress;//地址
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UIImageView *starImage;
@property (weak, nonatomic) IBOutlet UILabel *phoneLable;
@property (weak, nonatomic) IBOutlet UILabel *addressLable;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;


//collectCell
@property (weak, nonatomic) IBOutlet UILabel *storeName;//商店名字
@property (weak, nonatomic) IBOutlet UILabel *monthNum;//月销量
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *startNum;//起送价
@property (weak, nonatomic) IBOutlet UILabel *destinationAddress;//目的地址
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;//收藏按钮
@property (weak, nonatomic) IBOutlet UIImageView *shopAddImg;

@property(nonatomic,retain)UILabel * collectIdLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@end
