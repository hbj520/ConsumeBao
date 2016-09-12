//
//  DeliveryAddressViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliveryAddressViewController : UIViewController

@property(nonatomic,assign)int   addressType;//判断地图的类型 1 选择收货地址


@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)NSMutableArray *nearDataArr;//附近的数据
@end
