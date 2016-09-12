//
//  AddGoodsViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/21.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddGoodsViewController : UIViewController

@property (nonatomic, assign)int                  type;//判断是添加还是编辑 1编辑
@property(nonatomic,strong)   NSString            *goodsId;


@property (nonatomic, strong) NSMutableArray      *assets;
@property (nonatomic, strong) NSDateFormatter     *dateFormatter;
@property (nonatomic, retain) UIButton            * addButton;
@property (nonatomic, retain) UILabel             * scripeLabel;
@property (nonatomic, retain) UITextView          * describeTV;
@property (nonatomic, retain) UIButton            * addImgBtn;
@property (nonatomic, retain) NSMutableArray      * addImgArr;
@property (nonatomic, retain) UIButton            * deleteImgBtn;
@property (nonatomic, retain) UILabel             * classify;
@property (nonatomic, retain) UIButton            * saveBtn;
@property (nonatomic, retain) UITextField         * saveTF;//库存输入框
@property (nonatomic, retain) UITextField         * priceTF;//价格输入框
@property (nonatomic, retain) UIButton            * zhichiBtn;
@property (nonatomic, retain) UITextField         * biliTF;//返币比例
@end
