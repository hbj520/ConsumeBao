//
//  BankCardViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/20.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCXCreateAlertView.h"
@interface BankCardViewController : UIViewController
@property(nonatomic,assign)CGFloat navigationHeight;
@property(nonatomic,strong)SCXCreateAlertView *menu;
@property(nonatomic,strong)NSArray *titleNameArray;
@property(nonatomic,strong)UILabel * bankNameLabel;
@property(nonatomic,strong)UITextField * cityTF;
@property(nonatomic,strong)UITextField * cardNumberTF;
@property(nonatomic,strong)UITextField * nameTF;
@property(nonatomic,strong)UITextField * phoneTF;
@property(nonatomic,strong)UITextField * checkTF;
@property(nonatomic,retain)UIButton    * addBtn;
@property(nonatomic,retain)UIButton    * button;
@property(nonatomic,retain)UIButton    * saveBtn;
@property(nonatomic,retain)UIButton    * checkBtn;

@property(nonatomic,copy)void(^block)(NSDictionary * dict);
+(BankCardViewController *)sharedViewController;

@property(nonatomic,strong)NSString * phoneNumber;//手机号


@property(nonatomic,retain)UILabel     * getSpeechCheckLabel;

@property(nonatomic,retain)UIButton    * getSpeechCheckBtn;

@end
