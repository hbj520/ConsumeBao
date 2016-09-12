//
//  CategoryViewController.h
//  eShangBao
//
//  Created by doumee on 16/4/5.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryViewController : UIViewController

@property(nonatomic,retain)UITextField * searchTF;

@property(nonatomic,retain)UIButton    * searchBtn;

@property(nonatomic,retain)UILabel     * categoryLabel;

@property(nonatomic,retain)UIImageView * categoryImg;

//@property(nonatomic,retain)UIButton    * categoryBtn;

@property(nonatomic,retain)UILabel     * defaultLabel;

@property(nonatomic,retain)UILabel     * countLabel;

@property(nonatomic,retain)UILabel     * priceLabel;

@property(nonatomic,retain)UIImageView * countImg;

@property(nonatomic,retain)UIImageView * priceImg;

@property(nonatomic,retain)UICollectionView * collectionView;

@property(nonatomic,retain)NSString    * categoryId;

@property(nonatomic,retain)NSString    * goodsName;

@property(nonatomic,retain)NSString    * categoryName;
@end
