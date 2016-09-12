//
//  SearchViewController.h
//  eShangBao
//
//  Created by Dev on 16/1/21.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityModel.h"


@interface SearchViewController : UIViewController

@property(nonatomic,strong)CityModel *cityModel;
@property(nonatomic,strong)NSString  *latitude;
@property(nonatomic,strong)NSString  *longitude;

@property(nonatomic,assign)int  type;//搜索的类型 1商家 2 商品 3 线下
@property (weak, nonatomic) IBOutlet UITextField *searchContentText;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
