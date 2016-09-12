//
//  ManageStoreViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/22.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageStoreViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray * _timeArray;
}

@property(nonatomic,strong)NSString    * isShop;

@property(nonatomic,retain)UITextField * mainTF;

@property(nonatomic,retain)UITextField * branchTF;

@property(nonatomic,retain)UITextField * phoneTF;

@property(nonatomic,retain)UITextField * telephoneTF;

@property(nonatomic,retain)UIButton * saveBtn;

@property(nonatomic,retain)UIPickerView * pickerView;
@end
