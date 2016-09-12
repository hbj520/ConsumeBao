//
//  SJXQCommentTableViewCell.h
//  eShangBao
//
//  Created by doumee on 16/6/30.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellerDataModel.h"

@interface SJXQCommentTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView * headImg;

@property(nonatomic,strong)UILabel     * phoneLabel;

@property(nonatomic,strong)UIImageView * scoreImg;

@property(nonatomic,strong)UILabel     * commentLabel;

@property(nonatomic,strong)UILabel     * dateLabel;

@property(nonatomic,retain)CommentList *commentModel;

@end
