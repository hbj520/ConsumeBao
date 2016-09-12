//
//  ClassificationViewController.h
//  eShangBao
//
//  Created by Dev on 16/1/19.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassificationViewController : UIViewController

@property(nonatomic,assign)int  index;//是第几个类
@property(nonatomic,strong)NSMutableArray *categoryArr;
@property(nonatomic,strong)NSString       *latitude;
@property(nonatomic,strong)NSString       *longitude;

@property(nonatomic,assign)int        vcType;//区分是那个类进入 0 商家 1 首页

@property (weak, nonatomic) IBOutlet UIImageView *arrowOne;
@property (weak, nonatomic) IBOutlet UILabel *oneName;//第一组排序

@property (weak, nonatomic) IBOutlet UIImageView *arrowTwo;
@property (weak, nonatomic) IBOutlet UILabel *twoName;//第二组排序

@property (weak, nonatomic) IBOutlet UIImageView *arrowThree;
@property (weak, nonatomic) IBOutlet UILabel *threeName;//第三组排序

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UIView *chooseClassView;//选择的view
@property (strong, nonatomic)UITableView *chooseTableView;

@end
