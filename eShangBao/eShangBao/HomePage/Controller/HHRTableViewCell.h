//
//  HHRTableViewCell.h
//  eShangBao
//
//  Created by Dev on 16/6/30.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerDataModel.h"
#import "HomeModel.h"
@interface HHRTableViewCell : UITableViewCell

//HHRSP
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;//商品图片
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsDescribe;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (nonatomic,strong) GroundingModel *groundModel;

//HHRJL
@property (weak, nonatomic) IBOutlet UILabel *rankingLabel;//排序位置
@property (weak, nonatomic) IBOutlet UIImageView *buyImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *buyDate;//购物时间



//HHRPL

@property (weak, nonatomic) IBOutlet UIImageView *userImage;//用户头像
@property (weak, nonatomic) IBOutlet UILabel *userPhone;
@property (weak, nonatomic) IBOutlet UILabel *createDate;
@property (weak, nonatomic) IBOutlet UIImageView *commentStar;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic,strong)CommentModel     *commentModel;
@property (nonatomic,strong)CommentList      *storeComment;
@property (nonatomic,strong)PurchaseRecordModel * infoModel;
//HHRQRGM

@property (weak, nonatomic) IBOutlet UILabel *allMoney;
@property (weak, nonatomic) IBOutlet UIButton *QRGMButton;


@end
