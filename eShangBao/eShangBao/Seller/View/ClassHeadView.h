//
//  ClassHeadView.h
//  eShangBao
//
//  Created by Dev on 16/1/20.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerDataModel.h"

@protocol chooseCommentDelegate <NSObject>

//-(void)chooseCommenType:(int)type;




@end


@interface ClassHeadView : UIView

@property (nonatomic,assign)SellerInfoModel *infoMedel;

//@property(nonatomic,strong)id<chooseCommentDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *allComments;//全部
@property (weak, nonatomic) IBOutlet UIButton *goodsComments;//好
@property (weak, nonatomic) IBOutlet UIButton *generalComments;//中
@property (weak, nonatomic) IBOutlet UIButton *poorComments;//差

@property (weak, nonatomic) IBOutlet UIButton *contentBtn;//
@property (weak, nonatomic) IBOutlet UILabel *allScoreLabel;//
@property (weak, nonatomic) IBOutlet UILabel *quelityScoreLabel;//
@property (weak, nonatomic) IBOutlet UILabel *sendScoreLabel;//





@property(nonatomic,strong)UIButton *selectedBtn;
@end
