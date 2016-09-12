//
//  PayOrderViewController.h
//  eShangBao
//
//  Created by Dev on 16/1/22.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayOrderViewController : UIViewController

@property(nonatomic,strong)NSString          *orderID;
@property(nonatomic,strong)NSString          *totalPrice;
@property(nonatomic,strong)NSString          *shopName;


@property (weak, nonatomic) IBOutlet UILabel *orderName;
@property (weak, nonatomic) IBOutlet UILabel *orderMoneyNum;
@property (weak, nonatomic) IBOutlet UILabel *needMoneyNum;
@property (weak, nonatomic) IBOutlet UIImageView *ChatChooseImage;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIImageView *zfbChooseImage;
@property (nonatomic,assign) int   whichPage;
@property (nonatomic,assign) int   jumpWhichPage;//判断支付宝支付成功跳回哪一页

@property (nonatomic,strong) NSString * paramStr;
@end
