//
//  MyselfMsgViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/19.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyselfMsgViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UIImage * headImage;
@property (nonatomic, strong) UIButton * saveBtn;

@property (nonatomic, strong) UIView * coverView;
@property (nonatomic, retain) UIImageView * vipImg;//会员卡
@property (nonatomic, retain) UILabel * levelLabel;//等级
@property (nonatomic, retain) UILabel * inviteCodeLabel;//编号

@property (nonatomic, retain) NSString * partnerAgencyPayStatus;
@end
