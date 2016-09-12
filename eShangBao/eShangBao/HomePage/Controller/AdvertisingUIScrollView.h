//
//  AdvertisingUIScrollView.h
//  eShangBao
//
//  Created by Dev on 16/7/12.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapImageView.h"

@protocol WebViewBottmDelegate <NSObject>

-(void)scrollWebImageTaped:(UIImageView *)imageView;

@end

@interface AdvertisingUIScrollView : UIScrollView<UIScrollViewDelegate,ImageTapDelegate>

@property(nonatomic,strong)NSMutableArray *activityArr;

@property (nonatomic,assign) NSTimeInterval      chageTime;//切换时间
@property (nonatomic,retain) UIPageControl       *pageControl;
@property (nonatomic,assign) id<WebViewBottmDelegate>  webDelegate;

-(void)removeImageView;

@end
