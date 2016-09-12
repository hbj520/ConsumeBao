//
//  ManageOrderViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/21.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageOrderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *proceedBtn;
@property (weak, nonatomic) IBOutlet UIButton *accomplishBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *scrollLabel;

@end
