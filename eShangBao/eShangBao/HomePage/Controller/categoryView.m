
//
//  categoryView.m
//  eShangBao
//
//  Created by doumee on 16/4/6.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "categoryView.h"
#import <QuartzCore/QuartzCore.h>
#import "CategoryCollectionViewCell.h"
#import "SellerDataModel.h"
@implementation categoryView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        _categoryArr=[NSMutableArray arrayWithCapacity:0];
        _cateNameArr=[NSMutableArray arrayWithCapacity:0];
        _cateIdArr=[NSMutableArray arrayWithCapacity:0];
        [self merchatList];
    }
    
    return self;
}

-(void)merchatList
{
    if (_categoryArr.count>0) {
        [_categoryArr removeAllObjects];
    }
    
    NSDictionary * param=@{@"shopId":@""};
    [RequstEngine requestHttp:@"1009" paramDic:param blockObject:^(NSDictionary *dic) {
        DMLog(@"1009---%@",dic);
        DMLog(@"error----%@",dic[@"errorMsg"]);
        
        if ([dic[@"errorCode"] intValue]==00000) {
            [_categoryArr addObject:@"全部"];
            [_cateIdArr   addObject:@""];
            [_cateNameArr addObject:@"全部"];
            for (NSDictionary * newDic in dic[@"categoryList"]) {
                CategoryListModel * model=[[CategoryListModel alloc]init];
                [model setValuesForKeysWithDictionary:newDic];
                [_categoryArr addObject:model];
                [_cateIdArr   addObject:newDic[@"cateId"]];
                [_cateNameArr addObject:newDic[@"cateName"]];
            }
            
            [self loadUI];
//            [_collectionView reloadData];
        }
    }];

}
-(void)loadUI
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, H(180)) collectionViewLayout:flowLayout];
    // 注册一个复用的xib文件
    [_collectionView registerClass:[CategoryCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //    _collectionView.scrollEnabled=NO;
    //    _recommendCollectionView.backgroundColor = [UIColor colorWithRed:39/255.0 green:39/255.0 blue:39/255.0 alpha:1];
    //collectionView.backgroundColor=[UIColor redColor];
    _collectionView.backgroundColor=BGMAINCOLOR;
    _collectionView.pagingEnabled=YES;
    _collectionView.allowsMultipleSelection = YES;//默认为NO,是否可以多选
    [self addSubview:_collectionView];
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //    return _dataArr.count;
    
    return _cateNameArr.count;
    //    DMLog(@"count---%ld",(long)_dataArr.count);
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    CategoryListModel*model=_categoryArr[indexPath.row];
    CategoryCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLabel.text=_cateNameArr[indexPath.row];
    if ([_cateName isEqualToString:cell.titleLabel.text]) {
        cell.titleLabel.textColor=RGBACOLOR(255, 97, 0, 1);
    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (HEIGHT<=568) {
//        return CGSizeMake(WIDTH/4, 20);
//    }
//    else
//    {
        return CGSizeMake(WIDTH/4-20, 30);
//    }
    //    return CGSizeMake(W(150), H(150));
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(H(5), 0, H(5), W(10));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return W(5);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    CategoryListModel * model=_categoryArr[indexPath.row];
//    CategoryCollectionViewCell * cell=[collectionView cellForItemAtIndexPath:indexPath];
//    cell.titleLabel.textColor=RGBACOLOR(255, 97, 0, 1);
    NSDictionary * dic=@{@"cateId":_cateIdArr[indexPath.row],@"cateName":_cateNameArr[indexPath.row]};
    
    _block(dic);
    [self removeFromSuperview];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
