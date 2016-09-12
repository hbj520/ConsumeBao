//
//  VIPlevelViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/29.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIPlevelViewController : UIViewController
{
    NSInteger _seleteRow;
}
@property(nonatomic,retain)UIButton * weixinBtn;

@property(nonatomic,retain)UIButton * payinCashBtn;

@property (nonatomic,retain)UIButton * sureBtn;

@property (nonatomic,retain)UIButton * accomplishBtn;

@property (nonatomic,retain)NSString * claddifyStr;

@property (nonatomic,retain)NSString * levelName;

@property (nonatomic,retain)NSString * myLevelName;

@property(nonatomic,retain)UIButton * zhifubaoBtn;

@property (nonatomic,retain)NSString * level;

@property(nonatomic,retain)NSString * currentLevelFee;

@property(nonatomic,retain)NSString * userType;
@end
