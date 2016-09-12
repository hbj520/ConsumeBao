//
//  NicknameViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/20.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NicknameViewController : UIViewController

@property(nonatomic,retain)UIButton * sureBtn;

@property(nonatomic,copy)void(^block)(NSDictionary * dic);

@property(nonatomic,retain)NSString * nickName;//昵称
@end
