//
//  CommentDetailsTableViewCell.h
//  eShangBao
//
//  Created by doumee on 16/4/6.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentDetailsTableViewCell : UITableViewCell

@property(nonatomic,retain)UIImageView * headImg;

@property(nonatomic,retain)UILabel     * nameLabel;

@property(nonatomic,retain)UILabel     * scoreLabel;

@property(nonatomic,retain)UIImageView * scoreImg;

@property(nonatomic,retain)UILabel     * contentLabel;
@end
