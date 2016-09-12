//
//  ChooseBankViewController.h
//  eShangBao
//
//  Created by doumee on 16/7/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseBankViewController : UIViewController

@property(nonatomic,copy)void(^block)(NSString * bankName);
@end
