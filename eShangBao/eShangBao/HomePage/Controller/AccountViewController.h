//
//  AccountViewController.h
//  eShangBao
//
//  Created by doumee on 16/2/19.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UIViewController
@property(nonatomic,retain)NSString * memberId;//编码

@property(nonatomic,retain)UIImageView * headImg;//头像

@property(nonatomic,retain)UILabel * nickNameLabel;//昵称

@property(nonatomic,retain)UILabel * phoneLabel;//号码


@property(nonatomic,retain)UITextField * coinTF;//通宝币数量

@property(nonatomic,retain)UITextField * rematkTF;//备注信息

@property(nonatomic,retain)UIButton * surePayBtn;//确认付款
@property(nonatomic,retain)NSString * inviteCode;

@property(nonatomic,retain)NSString * headImgUrl;

@property(nonatomic,retain)NSString * loginName;

@property(nonatomic,retain)NSString * phone;
@end
