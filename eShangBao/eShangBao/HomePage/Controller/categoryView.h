//
//  categoryView.h
//  eShangBao
//
//  Created by doumee on 16/4/6.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface categoryView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView * _collectionView;
}

@property(nonatomic,copy)void(^block)(NSDictionary * dict);
@property(nonatomic,retain)NSMutableArray * categoryArr;//分类数组

@property(nonatomic,retain)NSMutableArray * cateIdArr;

@property(nonatomic,retain)NSMutableArray * cateNameArr;

@property(nonatomic,retain)NSString       * cateName;//类别名称
@end
