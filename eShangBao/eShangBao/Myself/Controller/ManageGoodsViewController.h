//
//  ManageGoodsViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/21.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageGoodsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *categoryView;//分类
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;//分类表

@property (weak, nonatomic) IBOutlet UILabel *chooseLabel;

@property (weak, nonatomic) IBOutlet UIView *editorView;//编辑
@property (weak, nonatomic) IBOutlet UIImageView *editorBgView;
@property (weak, nonatomic) IBOutlet UILabel *titelName;
@property (weak, nonatomic) IBOutlet UITextField *categoryName;
@property (weak, nonatomic) IBOutlet UITextField *sortNum;
@property (weak, nonatomic) IBOutlet UIView *inputView;//编辑框
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;
@property (weak, nonatomic) IBOutlet UIButton *addCategoryBtn;
@property (weak, nonatomic) IBOutlet UIButton *editorCategoryBtn;


- (IBAction)cancelBtn:(id)sender;

- (IBAction)categoryEditorBtn:(id)sender;

@end
