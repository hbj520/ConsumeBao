//
//  RecommendTableViewCell.h
//  eShangBao
//
//  Created by doumee on 16/1/25.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerDataModel.h"
#import "BrokenLineView.h"
@interface RecommendTableViewCell : UITableViewCell
{
    UICollectionView * _recommendCollectionView;
    UIView * view;
    BrokenLineView *brokenView;
}

@property (nonatomic,strong)UIButton *detailsButton;
@property (nonatomic,strong)SellerListModel * model;
@property (nonatomic,retain)NSMutableArray * dataArr;

@property (nonatomic,assign)int type;//0 首页的 1 详情的

+(instancetype)nowStatusWithTableView:(UITableView *)tableView section:(NSInteger)section cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
