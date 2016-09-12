//
//  SJXQMsgTableViewCell.h
//  eShangBao
//
//  Created by doumee on 16/6/30.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerDataModel.h"

@interface SJXQMsgTableViewCell : UITableViewCell

@property(nonatomic,strong)SellerInfoModel *infoModel;

@property(nonatomic,strong)UIImageView * headImg;

@property(nonatomic,strong)UILabel     * storeNameLabel;

@property(nonatomic,strong)UIImageView * scoreImg;

@property(nonatomic,strong)UILabel     * scoreLabel;

@property(nonatomic,strong)UILabel     * typeLabel;

@property(nonatomic,strong)UILabel     * addressLabel;

@property(nonatomic,strong)UIButton    * locationBtn;

@property(nonatomic,strong)UIButton    * dailBtn;


@end
