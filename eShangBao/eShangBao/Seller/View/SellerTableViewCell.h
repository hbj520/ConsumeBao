//
//  SellerTableViewCell.h
//  eShangBao
//
//  Created by doumee on 16/1/14.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerDataModel.h"

@interface SellerTableViewCell : UITableViewCell


@property (nonatomic ,strong)SellerListModel *listModel;

@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;//店铺图片

@property (weak, nonatomic) IBOutlet UILabel *storeName;//名字

@property (weak, nonatomic) IBOutlet UIView *starView;//添加星星

@property (weak, nonatomic) IBOutlet UILabel *monthNum;//月销量

@property (weak, nonatomic) IBOutlet UILabel *addressName;//地址名字

@property (weak, nonatomic) IBOutlet UILabel *recentlyNum;//最近时间

@property (weak, nonatomic) IBOutlet UIImageView *starImage;
@property (weak, nonatomic) IBOutlet UIImageView *dizhiImg;
@property (weak, nonatomic) IBOutlet UIImageView *fanbiImg;












@end
