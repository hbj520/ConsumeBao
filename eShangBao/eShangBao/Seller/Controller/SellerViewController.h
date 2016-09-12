//
//  SellerViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/13.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <CoreLocation/CoreLocation.h>

@interface SellerViewController : UIViewController

@property (strong, nonatomic) UIView *headView;
@property (weak, nonatomic) IBOutlet UITableView *myTableVeiw;
@property (strong, nonatomic) UIView *titleView;


@property (strong, nonatomic) UIView *advertisingView;//广告View

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (strong, nonatomic)  UILabel *selectedLabel;

@property (strong, nonatomic) UIScrollView *categoryScrollView;

@property (strong, nonatomic) UIView *categoryView;

@property (weak, nonatomic) IBOutlet UILabel *foodLabel;
@property (weak, nonatomic) IBOutlet UILabel *supermarketLabel;
@property (weak, nonatomic) IBOutlet UILabel *monopolyLabel;
@property (weak, nonatomic) IBOutlet UILabel *seafoodLabel;
@property (strong, nonatomic)  UIButton *fujiBtn;
@property (strong, nonatomic)  UIButton *changquBtn;
@property (strong, nonatomic)  UIButton *zuixingBtn;
@property (strong, nonatomic)  UILabel *bottomBtn;

@end
