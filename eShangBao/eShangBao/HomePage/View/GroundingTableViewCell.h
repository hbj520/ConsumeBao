//
//  GroundingTableViewCell.h
//  eShangBao
//
//  Created by doumee on 16/4/5.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAdView.h"

@protocol jumpToCategaryDelegates <NSObject>

-(void)pushView:(UIViewController*)VC;

@end
@interface GroundingTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,FLAdViewDelegate>
{
    UICollectionView * _groundingCollectionView;;
    UIImageView *bgImageView;
    UIWebView *myWeb;
    FLAdView  *adView;
}


@property (nonatomic,retain)NSMutableArray * dataArr;
@property (nonatomic,strong)activityModel  * model;

@property (nonatomic,assign)id<jumpToCategaryDelegates>delegate;
+(instancetype)nowStatusWithTableView:(UITableView *)tableView section:(NSInteger)section cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
