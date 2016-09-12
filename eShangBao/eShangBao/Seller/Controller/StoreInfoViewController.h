//
//  StoreInfoViewController.h
//  eShangBao
//
//  Created by Dev on 16/1/19.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerDataModel.h"

@interface StoreInfoViewController : UIViewController

@property(nonatomic,strong)SellerListModel *shopModel;
@property(nonatomic,strong)NSString        *latitude;
@property(nonatomic,strong)NSString        *longitude;


@property(nonatomic,strong)NSString  *shopID;

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;//头像
@property (weak, nonatomic) IBOutlet UILabel *storeName;//名字
@property (weak, nonatomic) IBOutlet UILabel *starLabel;//起送价
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//送达时间

@property (weak, nonatomic) IBOutlet UILabel *chooseLabel;


@property (weak, nonatomic) IBOutlet UIView *goodsView;//商品
@property (weak, nonatomic) IBOutlet UITableView *goodsTable;//类别种类
@property (weak, nonatomic) IBOutlet UITableView *goodsListTable;//商品列表


@property (weak, nonatomic) IBOutlet UITableView *evaluationTable;//评价列表
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;//收藏按钮

@property (weak, nonatomic) IBOutlet UITableView *merchantsTable;
@property (weak, nonatomic) IBOutlet UIButton *chooseGoodsBtn;//购物车按钮
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet UILabel *chooseGoodsNum;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyNum;

@property (weak, nonatomic) IBOutlet UILabel *nothingLabel;//毛都没有

@property (nonatomic,retain)NSString * isCollected;

@end
