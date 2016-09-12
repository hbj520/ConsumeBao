//
//  ClassTableViewCell.h
//  eShangBao
//
//  Created by Dev on 16/1/19.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerDataModel.h"

@interface ClassTableViewCell : UITableViewCell

@property(nonatomic,strong)SellerListModel *ListModel;

@property (weak, nonatomic) IBOutlet UIImageView *starImageView;

@property (weak, nonatomic) IBOutlet UIImageView *storeImage;//商店图片
@property (weak, nonatomic) IBOutlet UILabel *storeName;//名字
@property (weak, nonatomic) IBOutlet UILabel *storeDistance;//距离
@property (weak, nonatomic) IBOutlet UIView *starView;//评价的星星
@property (weak, nonatomic) IBOutlet UILabel *monthNum;//月销量
@property (weak, nonatomic) IBOutlet UILabel *starLabel;//起送条件
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;//地址
@property (weak, nonatomic) IBOutlet UIImageView *fanImage;//返回 图标

@property (weak, nonatomic) IBOutlet UIImageView *chooseOne;
@property (weak, nonatomic) IBOutlet UILabel *chooseName;

@property (weak, nonatomic) IBOutlet UIImageView *shooseImage;
@property (weak, nonatomic) IBOutlet UILabel *chooseImageName;
@property (weak, nonatomic) IBOutlet UIImageView *chooseTwo;




@end
