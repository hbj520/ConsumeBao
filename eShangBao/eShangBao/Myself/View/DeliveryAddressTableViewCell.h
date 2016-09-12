//
//  DeliveryAddressTableViewCell.h
//  eShangBao
//
//  Created by doumee on 16/1/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliveryAddressTableViewCell : UITableViewCell

@property(nonatomic,retain)UILabel * nameLabel;

@property(nonatomic,retain)UILabel * phoneLabel;

@property(nonatomic,retain)UILabel * addressLabel;

@property(nonatomic,retain)UILabel * addIDLabel;

@property(nonatomic,retain)UILabel * longitudeLabel;

@property(nonatomic,retain)UILabel * latitudeLabel;

@property(nonatomic,retain)UIButton * managmentBtn;

@end
