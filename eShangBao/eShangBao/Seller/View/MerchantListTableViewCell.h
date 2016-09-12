//
//  MerchantListTableViewCell.h
//  eShangBao
//
//  Created by Dev on 16/1/20.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerDataModel.h"

@interface MerchantListTableViewCell : UITableViewCell

@property(nonatomic,strong)SellerListModel *nearModel;

@property (weak, nonatomic) IBOutlet UIImageView *merchantImage;

@property (weak, nonatomic) IBOutlet UILabel *merchantName;

@property (weak, nonatomic) IBOutlet UILabel *merchentDistance;
@property (weak, nonatomic) IBOutlet UILabel *merchentComment;

@property (weak, nonatomic) IBOutlet UILabel *merchentMonth;

@property (weak, nonatomic) IBOutlet UILabel *merchentAdd;

@property (weak, nonatomic) IBOutlet UIImageView *merchantFan;

@property (weak, nonatomic) IBOutlet UILabel *searchName;//搜索显示的名字
@property (weak, nonatomic) IBOutlet UIImageView *starImage;

@end
