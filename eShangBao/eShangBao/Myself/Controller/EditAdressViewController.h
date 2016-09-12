//
//  EditAdressViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAdressViewController : UIViewController

@property (nonatomic,copy)NSString * nameStr;

@property (nonatomic,copy)NSString * addressStr;

@property(nonatomic,copy)NSString * phoneStr;

@property(nonatomic,retain)UITextField * nameTF;

@property(nonatomic,retain)UITextField * addressTF;

@property(nonatomic,retain)UITextField * phoneTF;

@property(nonatomic,retain)UITextField * detailTF;

@property(nonatomic,retain)NSString * addrId;

@property(nonatomic,retain)NSString * latitude;

@property(nonatomic,retain)NSString * longitude;

@property(nonatomic,retain)NSString * details;
@end
