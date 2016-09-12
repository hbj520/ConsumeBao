//
//  OrderDetailViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/26.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailViewController : UIViewController

@property(nonatomic,strong)NSString  *orderID;//选择的订单ID
@property(nonatomic,strong)NSString  *orderType;

@property (weak, nonatomic) IBOutlet UILabel *chooseLabel;
- (IBAction)chooseOrderTypeButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *tabelScrollView;

@property(nonatomic,assign)int type;
@property(nonatomic,retain)NSString * status;//订单状态

@property(nonatomic,assign)int whichType;
@end
