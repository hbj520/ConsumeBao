//
//  BoundViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/19.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoundViewController : UIViewController

@property(nonatomic,retain)UITextField * phoneTF;//手机号

@property(nonatomic,retain)UITextField * checkTF;//验证码

@property(nonatomic,retain)UITextField * pswTF;//密码

@property(nonatomic,retain)UILabel     * getSpeechCheckLabel;

@property(nonatomic,retain)UIButton    * getSpeechCheckBtn;

@property(nonatomic,retain)UIButton    * checkBtn;

@property(nonatomic,retain)UIButton    * askBtn;

@property(nonatomic,copy)  void(^block)(NSString * phone);
@end
