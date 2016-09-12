//
//  TopupViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Product : NSObject{
@private
    float     _price; // 价格
    NSString * type;  // 类型
    
}

@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *type;

@end

@interface TopupViewController : UIViewController
@property(nonatomic,retain)UIButton * weixinBtn;

@property(nonatomic,retain)UIButton * zfbBtn;

@property(nonatomic,retain)UILabel * payCountLabel;

@property (nonatomic,copy) NSString*count;      // 支付余额

@property (nonatomic,copy) NSString*urlString;

@property (nonatomic,copy) NSString*orderNo;    // 支付订单号

@property (nonatomic,strong)UIButton * accomplishBtn;

@end
