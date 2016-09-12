//
//  XFZCViewController.h
//  eShangBao
//
//  Created by Dev on 16/6/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFZCViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray *projectModelArr;
@property (nonatomic,strong)UITableView    *myTableView;

@end
