//
//  CollectViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/18.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectViewController : UIViewController

@property(nonatomic,retain)UITableView * tableView;

@property(nonatomic,retain)NSMutableArray * dataArr;

@property(nonatomic,retain)NSMutableArray * nearArr;
@end
