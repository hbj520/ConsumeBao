//
//  SYQViewController.h
//  eShangBao
//
//  Created by Dev on 16/6/29.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYQViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_myTableView;
    NSMutableArray *titalViewArr;//头标题titalArr
    
}

@property (nonatomic,strong)NSMutableArray *usufructArr;

@end
