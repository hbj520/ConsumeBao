//
//  RecommendViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/18.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendViewController : UIViewController
@property(nonatomic,retain)UITableView * myTableVeiw;

@property(nonatomic,retain)UIView * coverView;

@property(nonatomic,retain)NSString * myImgUrl;//我的头像地址

@property(nonatomic,retain)NSString * myNickName;//我的昵称

@property(nonatomic,retain)NSString * myCoin;//我的通宝币

@property(nonatomic,retain)UIButton * lastBtn;

@property(nonatomic,strong)NSString * floor;
@end
