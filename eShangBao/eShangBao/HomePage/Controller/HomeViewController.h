//
//  HomeViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/13.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAdView.h"
@interface HomeViewController : UIViewController<FLAdViewDelegate,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,copy)UILabel * lineLab;

@property(nonatomic,copy)UIButton * downBtn;

@property(nonatomic,copy)UIImageView * recImg;

@property(nonatomic,copy)UIImageView * chooseusImg;

@property(nonatomic,copy)UIButton * chooseusDownBtn;

@property(nonatomic,copy)UIButton * scanBtn;

@property(nonatomic,copy)UIButton * erweimaBtn;
@end
