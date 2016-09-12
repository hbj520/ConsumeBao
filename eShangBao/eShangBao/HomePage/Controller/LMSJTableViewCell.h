//
//  LMSJTableViewCell.h
//  eShangBao
//
//  Created by Dev on 16/6/29.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerDataModel.h"

@interface LMSJTableViewCell : UITableViewCell

@property(nonatomic,strong)SellerListModel *ListModel;

@property(nonatomic,strong)MycollectModel  *collectModel;

@property (weak, nonatomic) IBOutlet UIImageView *storeImage;//图片
@property (weak, nonatomic) IBOutlet UILabel *storeName;//名字
@property (weak, nonatomic) IBOutlet UIImageView *storeStar;//评价
@property (weak, nonatomic) IBOutlet UILabel *storeAddress;//地址
@property (weak, nonatomic) IBOutlet UIImageView *fanImage;//反币
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *goldNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end
