//
//  MainViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/25.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAdView.h"
#import "CategoryViewController.h"
#import "ElseTableViewCell.h"
//#import "AllianceViewController.h"
#import "XFZCViewController.h"
#import "PartnerViewController.h"
#import "RecommendCollectionViewCell.h"
#import "ChooseusTableViewCell.h"
#import "ScanerVC.h"
#import "RecommendTableViewCell.h"
#import "CreateCodeViewController.h"
#import "ScanerPayViewController.h"
#import "HomeModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "UIImageView+WebCache.h"
#import "SellerDataModel.h"
#import <CoreLocation/CoreLocation.h>
#import "AdvertisingViewController.h"
#import "StoreInfoViewController.h"
#import "HotActivityTableViewCell.h"
#import "GroundingTableViewCell.h"
@interface MainViewController : UIViewController

@property (nonatomic,retain)UIButton * addButton;

@property (nonatomic,retain)UIImageView * recImg;

@property (nonatomic,retain)UIImageView * recImg1;

@property (nonatomic,retain)UIButton * downBtn;

@property(nonatomic,copy)UIButton * scanBtn;

@property(nonatomic,copy)UIButton * erweimaBtn;

@property(nonatomic,retain)UITableView * tableView;

@property (nonatomic,retain)FLAdView *adView ;

@property (nonatomic,retain)NSMutableArray * categoryArr;//分类数组

@property (nonatomic,retain)NSMutableArray * groundingArr;//最近上架数组
@end
