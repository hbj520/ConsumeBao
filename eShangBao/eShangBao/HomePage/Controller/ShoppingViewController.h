//
//  ShoppingViewController.h
//  eShangBao
//
//  Created by doumee on 16/4/6.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingViewController : UIViewController

@property(nonatomic,retain)UILabel * totleLabel;

@property(nonatomic,retain)UIButton * accountBtn;

@property(nonatomic,retain)NSString    * deliveryFee;

@property(nonatomic,retain)NSMutableArray    * deliveryFeeArr;

@property(nonatomic,retain)NSMutableArray * startPriceArr;;

@property(nonatomic,retain)NSString    * startPrice;

@property(nonatomic,retain)UIButton    * clearAllBtn;

@property(nonatomic,retain)NSString    * shopcartId;
@end
