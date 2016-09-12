//
//  SubmitTableViewCell.h
//  eShangBao
//
//  Created by Dev on 16/1/21.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol submitPaymentMethodDelegate <NSObject>


-(void)payMethod:(NSString *)pay;

@end

@interface SubmitTableViewCell : UITableViewCell
@property (nonatomic,strong)id<submitPaymentMethodDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *customerName;//名字
@property (weak, nonatomic) IBOutlet UILabel *customerPhone;//电话
@property (weak, nonatomic) IBOutlet UILabel *customerAddress;//地址
@property (weak, nonatomic) IBOutlet UILabel *arriveTime;//到达时间
@property (weak, nonatomic) IBOutlet UIButton *addAddressBtn;


@property (weak, nonatomic) IBOutlet UIImageView *onlinePayImage;//线上支付选择
@property (weak, nonatomic) IBOutlet UIImageView *offlinePayImage;//线下

@property (weak, nonatomic) IBOutlet UILabel *storeName;//商店名字

@property (weak, nonatomic) IBOutlet UILabel *goodsName;//商品名称
@property (weak, nonatomic) IBOutlet UILabel *goodsNum;//商品数量
@property (weak, nonatomic) IBOutlet UILabel *goodsMoney;//价钱


@property (weak, nonatomic) IBOutlet UILabel *totalMoney;//总钱
@property (weak, nonatomic) IBOutlet UILabel *vouchersNum;//代金数量
@property (weak, nonatomic) IBOutlet UIImageView *vouchersChooseImage;//选择的图标
@property (nonatomic,assign)BOOL                 chooseVouchersPay;
@property (weak, nonatomic) IBOutlet UITextField *chooseCoinTF;

@property (weak, nonatomic) IBOutlet UILabel *sendPriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *tongBaoBiBtn;

@property (weak, nonatomic) IBOutlet UITextField *tongbaobiNum;
@property (weak, nonatomic) IBOutlet UITextField *tongbaobiPwd;

@end
