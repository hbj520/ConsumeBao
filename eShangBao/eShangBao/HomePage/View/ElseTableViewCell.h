//
//  ElseTableViewCell.h
//  eShangBao
//
//  Created by doumee on 16/1/25.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAdView.h"
#import "YGQPaoMaView.h"
#import "SellerDataModel.h"

@protocol jumpToCategaryDelegate <NSObject>

-(void)pushView:(int)vcType;

@end

@interface ElseTableViewCell : UITableViewCell<UIScrollViewDelegate>
{
    NSArray * imgArr;
    UIScrollView *_scrollView;
    NSTimer * scrollTimer;
//    NSMutableArray * titleArr;
//    int page;
    UIPageControl * _pageControl;
}
@property (nonatomic,assign)id<jumpToCategaryDelegate>delegate;
@property (nonatomic,retain)UIView *adView ;

@property (nonatomic,retain)YGQPaoMaView * ygqView;

@property (nonatomic,retain)UIButton * button1;

@property (nonatomic,retain)UIButton * button2;

@property (nonatomic,retain)UIButton * button3;

@property (nonatomic,retain)UIButton * button4;

@property (nonatomic,assign)NSInteger  buttonTag;

@property (nonatomic,retain)UIImageView * bannerImg;

@property (nonatomic,retain)UILabel * hotspotLabel;//热点

@property (nonatomic,retain)UILabel * detailLabel;

@property (nonatomic,retain)NSMutableArray * titleArr;

@property (nonatomic,retain)NSString * titleStr;

@property (nonatomic,retain)UIImageView * recImg;

@property (nonatomic,retain)UILabel * labelShow;//滚动label

@property (nonatomic,retain)UIScrollView * scrollView;

@property (nonatomic,retain)NSMutableArray * categoryArr;

@property (nonatomic,retain)CategoryListModel * model;
+(instancetype)StatusTableView:(UITableView *)tableView Array:(NSMutableArray*)array cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
