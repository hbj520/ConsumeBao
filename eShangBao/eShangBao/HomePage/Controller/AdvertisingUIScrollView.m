//
//  AdvertisingUIScrollView.m
//  eShangBao
//
//  Created by Dev on 16/7/12.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "AdvertisingUIScrollView.h"




@implementation AdvertisingUIScrollView
{
    CGRect myFrame;
    NSTimer *scrollTimer;
    int     currentPage;
    CGPoint currentContentOffset;
    
}


-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        myFrame=frame;
        self.pagingEnabled   = YES;
        self.bounces         = NO;
        self.delegate        = self;
        self.showsHorizontalScrollIndicator=NO;
        
        currentPage=0;
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, myFrame.origin.y + myFrame.size.height-20, myFrame.size.width, 20)];
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        //[self addSubview:_pageControl];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetImage) name:UIApplicationDidBecomeActiveNotification object:nil];
       // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimer) name:@"stopTimer" object:nil];
        
    }
    return self;
}

-(void)dealloc
{
    [scrollTimer invalidate];
    scrollTimer = nil;
}

-(void)removeImageView
{
    [scrollTimer invalidate];
    scrollTimer = nil;
    

}

-(void)stopTimer
{
    
}

-(void)resetImage
{
    [self setContentOffset:CGPointMake(myFrame.size.width, 0)];
    self.pageControl.currentPage = 0;
}


-(void)setActivityArr:(NSMutableArray *)activityArr
{
 
    _activityArr=activityArr;
    self.contentSize=CGSizeMake(KScreenWidth*activityArr.count, 0);
    [self setContentOffset:CGPointMake(0, 0)];
    _pageControl.numberOfPages = activityArr.count;
    _pageControl.frame = CGRectMake(KScreenWidth/2.-20*activityArr.count/2., myFrame.origin.y + myFrame.size.height-20, 20*activityArr.count, 20);
    _pageControl.currentPage=0;
    _pageControl.hidden=NO;

    activityModel *model=[activityArr lastObject];
    if ([model.isLink intValue]<2) {
        TapImageView *tapImage =[[TapImageView alloc]initWithFrame:CGRectMake(-myFrame.size.width, 0, myFrame.size.width, myFrame.size.height)];
        tapImage.tag = activityArr.count+9;
        tapImage.delegate = self;
        tapImage.contentMode = UIViewContentModeScaleAspectFill;
        tapImage.layer.masksToBounds=YES;
        [tapImage setImageWithURLString:model.imgUrl placeholderImage:DEFAULTADVERTISING];
        [self addSubview:tapImage];
    }else{
        
        UIWebView *myWeb=[[UIWebView alloc]initWithFrame:CGRectMake(-myFrame.size.width, 0, myFrame.size.width, myFrame.size.height)];
        [self addSubview:myWeb];
        NSURL *url = [NSURL URLWithString:@"http://devimages.apple.com/iphone/samples/bipbop/gear1/prog_index.m3u8"];
        //http://114.215.188.193:8080/consumption/ad/20160604/5d2742c7-95e2-44ee-96a8-9ac0420a65a6.png
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [myWeb loadRequest:request];
        [self addSubview:myWeb];
    }

    
    for (int i = 0; i<activityArr.count; i++) {
        
        activityModel *model=activityArr[i];
        
        if ([model.isLink intValue]<2) {
            TapImageView *tapImage =[[TapImageView alloc]initWithFrame:CGRectMake(i*myFrame.size.width, 0, myFrame.size.width, myFrame.size.height)];
            tapImage.tag = i+10;
            tapImage.delegate = self;
            tapImage.contentMode = UIViewContentModeScaleAspectFill;
            tapImage.layer.masksToBounds=YES;
            [tapImage setImageWithURLString:model.imgUrl placeholderImage:DEFAULTADVERTISING];
            [self addSubview:tapImage];
        }else{
            
            UIWebView *myWeb=[[UIWebView alloc]initWithFrame:CGRectMake(i*myFrame.size.width, 0, myFrame.size.width, myFrame.size.height)];
            [self addSubview:myWeb];
             NSURL *url = [NSURL URLWithString:@"http://devimages.apple.com/iphone/samples/bipbop/gear1/prog_index.m3u8"];
            //http://114.215.188.193:8080/consumption/ad/20160604/5d2742c7-95e2-44ee-96a8-9ac0420a65a6.png
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [myWeb loadRequest:request];
            [self addSubview:myWeb];
        }
    }
    if (_activityArr.count<=1) {
        
        _pageControl.hidden=YES;
        
    }else{
        
        
        _pageControl.hidden=NO;
        scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:scrollTimer forMode:NSRunLoopCommonModes];
    }
    
    
    [self addSubview:_pageControl];
}

-(void)imageViewTaped:(id)sender
{
    [self.webDelegate scrollWebImageTaped:sender];
}

-(void)changeImage
{
    CGPoint contentOffset = self.contentOffset;
    currentPage++;
    contentOffset.x = contentOffset.x+KScreenWidth;
    _pageControl.currentPage=currentPage;
    [self setContentOffset:contentOffset animated:YES];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    currentContentOffset=scrollView.contentOffset;
    [scrollTimer invalidate];
    scrollTimer = nil;
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (currentPage>=_activityArr.count-1) {
        
        currentPage=-1;
        CGPoint contentOffset;
        contentOffset.x=-myFrame.size.width;
        [self setContentOffset:contentOffset animated:NO];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    
     _pageControl.frame = CGRectMake(KScreenWidth/2.-20*_activityArr.count/2.+(scrollView.contentOffset.x), myFrame.origin.y + myFrame.size.height-20, 20*_activityArr.count, 20);
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (_activityArr.count>1) {
        
        
        scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:scrollTimer forMode:NSRunLoopCommonModes];
        
        
    }
    
    int page=scrollView.contentOffset.x/myFrame.size.width;
    
    if (currentContentOffset.x==scrollView.contentOffset.x) {
        
        return;
    }
    
    currentPage=page;
     _pageControl.currentPage=page;
    if (currentPage==_activityArr.count-1) {
        
        currentPage=-1;
        CGPoint contentOffset;
        contentOffset.x=-myFrame.size.width;
        [self setContentOffset:contentOffset animated:NO];
    }
    
   
    
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
