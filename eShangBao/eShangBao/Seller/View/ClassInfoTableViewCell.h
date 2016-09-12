//
//  ClassInfoTableViewCell.h
//  eShangBao
//
//  Created by Dev on 16/1/20.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerDataModel.h"

@protocol classListInfoDelegate <NSObject>

-(void)getGoodsinfoData:(SellerGoodsListModel *)goodsListModel;

-(void)addAndReductionDelegateType:(int)type;

@end



@interface ClassInfoTableViewCell : UITableViewCell

@property(nonatomic,strong)id<classListInfoDelegate>delegate;
@property(nonatomic,strong) SellerGoodsListModel  *goodListModel;
@property(nonatomic,strong) NSString              *chooseGoodsNum;
@property(nonatomic,strong)CommentList            *commentModel;

@property (weak, nonatomic) IBOutlet UILabel *listName;
@property (weak, nonatomic) IBOutlet UIImageView *classZan;

@property (weak, nonatomic) IBOutlet UIImageView *classInfocellImage;
@property (weak, nonatomic) IBOutlet UILabel *classInfoCellName;
@property (weak, nonatomic) IBOutlet UILabel *classInfoFanNum;//返币率
@property (weak, nonatomic) IBOutlet UILabel *classInfoCellMonthNum;//月销量
@property (weak, nonatomic) IBOutlet UILabel *classInfoCellZanNum;//点赞数
@property (weak, nonatomic) IBOutlet UILabel *classInfoCellMoneyNum;//单价
@property (weak, nonatomic) IBOutlet UILabel *backMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *classInfoCellReduction;
@property (weak, nonatomic) IBOutlet UILabel *classInfoCellNum;//商品数
@property (weak, nonatomic) IBOutlet UIButton *classInfoCellAdd;//添加



@property (weak, nonatomic) IBOutlet UILabel *commentName;//评论者的名字
@property (weak, nonatomic) IBOutlet UIView *commentStarNum;//评论的❤️数
@property (weak, nonatomic) IBOutlet UILabel *commentContent;//内容
@property (weak, nonatomic) IBOutlet UIImageView *commentStarImage;//图片

@property (weak, nonatomic) IBOutlet UILabel *goodsName;//商品名字
@property (weak, nonatomic) IBOutlet UILabel *chooseNum;


@end
