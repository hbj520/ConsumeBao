//
//  FirstImgViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/15.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstImgViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) UIButton * addButton;
@property (nonatomic, retain) UIButton * uploadBtn;
@property (nonatomic, copy)void(^block)(NSDictionary *dic);

@property (nonatomic, retain) NSString * doorImg;

@property(nonatomic,assign)int whichPage;//哪一页
@end
