//
//  HHRViewController.h
//  eShangBao
//
//  Created by Dev on 16/6/29.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHRViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,assign)int VCType;//0 创业 1 银 2 金 3 钻石
@property(nonatomic,strong)UITableView *myTabelView;
@property(nonatomic,strong)ProjectIntroductionModel *projectModel;


@property(nonatomic,strong)NSMutableArray *goodsListArr;//商品列表
@property(nonatomic,strong)NSMutableArray *goodsRecordArr;//商品记录
@property(nonatomic,strong)NSMutableArray *goodsCommentsArr;//评论数组

@end
