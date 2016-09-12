//
//  SetPsdViewController.h
//  eShangBao
//
//  Created by doumee on 16/3/16.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetPsdViewController : UIViewController

@property(nonatomic,retain)UITextField * pswTF;//密码输入框

@property(nonatomic,retain)UITextField * againPswTF;//重复密码输入框

@property(nonatomic,retain)UITextField * phoneTF;

@property(nonatomic,retain)UITextField * checkTF;//验证码输入框

@property(nonatomic,retain)UILabel     * getSpeechCheckLabel;

@property(nonatomic,retain)UIButton    * getSpeechCheckBtn;
@end
