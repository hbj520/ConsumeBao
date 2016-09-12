//
//  ManageGoodsTableViewCell.h
//  eShangBao
//
//  Created by doumee on 16/1/21.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectModel.h"
#import "SellerDataModel.h"


@protocol manageGoodsDelegate <NSObject>

-(void)manageDelegate:(int)type;
-(void)manageModelDelegate:(SellerGoodsListModel *)goodsModel;

@end

@interface ManageGoodsTableViewCell : UITableViewCell
@property (nonatomic,strong)SellerGoodsListModel *goodsModel;
@property(nonatomic,strong)id<manageGoodsDelegate>delegate;

@property (nonatomic,strong)NSString *isDelete;
@property (weak, nonatomic) IBOutlet UIImageView *storeImage;//商店图片
@property (weak, nonatomic) IBOutlet UILabel *goodsName;//商品名称
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;//价格
@property (weak, nonatomic) IBOutlet UILabel *goodsSales;//销量
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *fanbiLabel;//返币
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;//点击的按钮
@property (weak, nonatomic) IBOutlet UIImageView *shelvesImage;
@property (weak, nonatomic) IBOutlet UILabel *shelvesLabel;


@property(nonatomic,strong) categoryListModel  *categroyModel;
@property (weak, nonatomic) IBOutlet UIButton  *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton  *editorBtn;
@property (weak, nonatomic) IBOutlet UILabel   *categoryName;//分类名称
@property (weak, nonatomic) IBOutlet UILabel   *goodsNum;//商品数量


@end
