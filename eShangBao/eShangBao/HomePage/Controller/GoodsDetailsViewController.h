//
//  GoodsDetailsViewController.h
//  eShangBao
//
//  Created by doumee on 16/4/6.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsDetailsViewController : UIViewController

@property(nonatomic,retain)UIImageView * headImg;//头部图片

@property(nonatomic,retain)UILabel     * goodsNameLabel;//商品名称

@property(nonatomic,retain)UILabel     * priceLabel;//价格

@property(nonatomic,retain)UILabel     * returnBateLabel;//返币

@property(nonatomic,retain)UILabel     * deliveryFeeLabel;//配送费

@property(nonatomic,retain)UILabel     * startLabel;//起送价

@property(nonatomic,retain)UILabel     * countTitleLabel;//购买数量标题

@property(nonatomic,retain)UIButton    * reduceBtn;//数量减按钮

@property(nonatomic,retain)UIButton    * addBtn;//数量加按钮

@property(nonatomic,retain)UILabel     * countLabel;//购买数量

@property(nonatomic,retain)UIButton    * parameterBtn;//产品参数按钮

@property(nonatomic,retain)UIButton    * commentBtn;//评论详情按钮

@property(nonatomic,retain)UILabel     * rollLabel;//滚动Label

@property(nonatomic,retain)UILabel     * nameLabel;//品牌名称

@property(nonatomic,retain)UILabel     * goodsLabel;//产品名称

@property(nonatomic,retain)UILabel     * sizeLabel;//规格

@property(nonatomic,retain)UILabel     * zoneLabel;//产地

@property(nonatomic,retain)UILabel     * heightLabel;//重量

@property(nonatomic,retain)UIButton    * shoppingBtn;//购物车按钮

@property(nonatomic,retain)UIButton    * addGoodsBtn;//加入购物车

@property(nonatomic,retain)UIButton    * purchaseBtn;//立即购买

@property(nonatomic,retain)UIButton    * dailBtn;//打电话按钮

@property(nonatomic,retain)NSString    * goodsId;

@property(nonatomic,retain)NSString    * goodsName;//商品名称

@property(nonatomic,retain)NSString    * imgUrl;//商品首图

@property(nonatomic,retain)NSString    * monthOrderNum;//月售量

@property(nonatomic,retain)NSString    * price;//单价 单位元

@property(nonatomic,retain)NSString    * stock;//库存量

@property(nonatomic,retain)NSString    * barCode;//条形码

@property(nonatomic,retain)NSString    * imgList;//图片集合

@property(nonatomic,retain)NSString    * returnBate;//返币比例

@property(nonatomic,retain)NSString    * details;//商品描述

@property(nonatomic,retain)NSString    * categoryId;//分类编码

@property(nonatomic,retain)NSString    * categoryName;//分类名称

@property(nonatomic,retain)UILabel     * monthOrderNumLabel;//月销售量

//@property(nonatomic,retain)NSString    * monthOrderNum;//

@property(nonatomic,retain)UITableView * tableView;

@property(nonatomic,retain)NSMutableArray * nearArr;

@property(nonatomic,retain)NSString    * deliveryFee;

@property(nonatomic,retain)NSMutableArray    * deliveryFeeArr;

@property(nonatomic,retain)NSMutableArray * startPriceArr;;

@property(nonatomic,retain)NSString    * startPrice;

@property(nonatomic,retain)UILabel     * totleCountLabel;
@end
