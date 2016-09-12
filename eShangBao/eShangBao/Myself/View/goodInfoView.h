//
//  goodInfoView.h
//  eShangBao
//
//  Created by Dev on 16/1/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectModel.h"

@interface goodInfoView : UIView

@property(nonatomic,strong)GoodsInfoModel *goodsModel;

@property (weak, nonatomic) IBOutlet UIImageView *goodsHeadImage;

@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *returnBate;
@property (weak, nonatomic) IBOutlet UILabel *monthOrderNum;
@property (weak, nonatomic) IBOutlet UILabel *stock;


@end
