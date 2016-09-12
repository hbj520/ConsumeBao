//
//  ShoppingTableViewCell.h
//  eShangBao
//
//  Created by doumee on 16/4/6.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingTableViewCell : UITableViewCell

@property(nonatomic,retain)UIImageView * headImg;

@property(nonatomic,retain)UILabel     * nameLabel;

@property(nonatomic,retain)UIButton    * deleteBtn;

@property(nonatomic,retain)UIButton    * reduceBtn;

@property(nonatomic,retain)UIButton    * addBtn;

@property(nonatomic,retain)UILabel     * countLabel;

@property(nonatomic,retain)UILabel     * priceLabel;
@end
