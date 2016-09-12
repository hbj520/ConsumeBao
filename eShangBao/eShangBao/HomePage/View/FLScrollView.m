//
//  FLScrollView.m
//  ImageTest
//
//  Created by apple on 15-4-23.
//  Copyright (c) 2015年 fengling2300. All rights reserved.
//

#import "FLScrollView.h"


@implementation FLScrollView{
    CGRect myFrame;
    NSTimer *scrollTimer;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        myFrame              = frame;
        self.pagingEnabled   = YES;
        self.bounces         = NO;
        self.delegate        = self;
        self.backgroundColor = [UIColor clearColor];
        
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, myFrame.origin.y + myFrame.size.height-20, myFrame.size.width, 20)];
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetImage) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimer) name:@"stopTimer" object:nil];
        
    }
    return self;
}

-(void)stopTimer
{
    [scrollTimer invalidate];
    scrollTimer = nil;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)resetImage{
    [self setContentOffset:CGPointMake(myFrame.size.width, 0)];
    self.pageControl.currentPage = 0;
}

-(void)setChageTime:(NSTimeInterval)chageTime{
    if (scrollTimer) {
        [scrollTimer invalidate];
        scrollTimer = nil;
    }
}

-(void)changeImage{
    
    CGPoint contentOffset = self.contentOffset;
    contentOffset.x = contentOffset.x+KScreenWidth;
    [self setContentOffset:contentOffset animated:YES];
    
}

-(void)setImageArray:(NSMutableArray *)imageArray{
    
    _pageControl.numberOfPages = imageArray.count;
    _pageControl.frame = CGRectMake(0, myFrame.origin.y + myFrame.size.height-20, 20*imageArray.count, 20);
    self.location = _location;
    [self setContentSize:CGSizeMake((imageArray.count+2)*myFrame.size.width, myFrame.size.height)];
    [self setContentOffset:CGPointMake(myFrame.size.width, 0)];
    
    UIImageView *firstImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, myFrame.size.width, myFrame.size.height)];
    //firstImage.contentMode=2;
    firstImage.contentMode = UIViewContentModeScaleAspectFill;
    firstImage.layer.masksToBounds=YES;
   // [firstImage setImage:[imageArray lastObject]];
    //
    [firstImage setImageWithURLString:[imageArray lastObject] placeholderImage:DEFAULTADVERTISING];
    [self addSubview:firstImage];
    for (int i = 0; i<imageArray.count; i++) {
        TapImageView *tapImage =[[TapImageView alloc]initWithFrame:CGRectMake((i+1)*myFrame.size.width, 0, myFrame.size.width, myFrame.size.height)];
        tapImage.tag = i+10;
        tapImage.delegate = self;
        tapImage.contentMode = UIViewContentModeScaleAspectFill;
        tapImage.layer.masksToBounds=YES;
        //[tapImage setImage:imageArray[i]];
        [tapImage setImageWithURLString:imageArray[i] placeholderImage:DEFAULTADVERTISING];
        [self addSubview:tapImage];
    }
    UIImageView *lastImage = [[UIImageView alloc]initWithFrame:CGRectMake((imageArray.count+1)*myFrame.size.width, 0, myFrame.size.width, myFrame.size.height)];
    //lastImage.contentMode=2;
    //[lastImage setImage:imageArray[0]];
    if (imageArray.count>0) {
        [lastImage setImageWithURLString:imageArray[0] placeholderImage:DEFAULTADVERTISING];
    }
    lastImage.contentMode = UIViewContentModeScaleAspectFill;
    lastImage.layer.masksToBounds=YES;
    [self addSubview:lastImage];
    if (imageArray.count==1) {
        _pageControl.hidden=YES;
    }
    else
    {
        scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:scrollTimer forMode:NSRunLoopCommonModes];
        _pageControl.hidden=NO;
    }
    
    _imageArray = imageArray;

}

-(void)imageViewTaped:(id)sender{
    
    [self.imgDelegate scrollImageTaped:sender];
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [scrollTimer invalidate];
    scrollTimer = nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1{

    if (_imageArray.count==1) {
    }
    
    
    if (_imageArray.count>1) {
        
        scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:scrollTimer forMode:NSRunLoopCommonModes];
        
        if (scrollView1.contentOffset.x == 0) {
            
            scrollView1.contentOffset = CGPointMake(_imageArray.count*myFrame.size.width, 0);
            
        }else if(scrollView1.contentOffset.x >= (_imageArray.count+1)*myFrame.size.width){
            
            scrollView1.contentOffset = CGPointMake(myFrame.size.width, 0);
        }
        else
        {
//            scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
            if (scrollView1.contentOffset.x == 0) {
                scrollView1.contentOffset = CGPointMake(_imageArray.count*myFrame.size.width, 0);
            }else if(scrollView1.contentOffset.x >= (_imageArray.count+1)*myFrame.size.width){
                scrollView1.contentOffset = CGPointMake(myFrame.size.width, 0);
            }
            _pageControl.currentPage = scrollView1.contentOffset.x/myFrame.size.width-1;
        }

    }
    
    
   
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView1{
    if (_imageArray.count==1) {
        
    }
    else
    {
        if (scrollView1.contentOffset.x == 0) {
            scrollView1.contentOffset = CGPointMake(_imageArray.count*myFrame.size.width, 0);
        }else if(scrollView1.contentOffset.x >= (_imageArray.count+1)*myFrame.size.width){
            scrollView1.contentOffset = CGPointMake(myFrame.size.width, 0);
        }
        _pageControl.currentPage = scrollView1.contentOffset.x/myFrame.size.width-1;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_imageArray.count==1) {
        
    }
    else
    {
        if (scrollView.contentOffset.y < 0) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
        }
        
        if (scrollView.contentOffset.y > 0) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
        }
    }
    
    
}
-(void)setLocation:(PageControlLocation)location{
    if (location == PageControlCenter) {
        _pageControl.frame = CGRectMake(myFrame.size.width/2-10*_imageArray.count, myFrame.origin.y + myFrame.size.height-20, 20*_imageArray.count, 20);
    }else if(location == PageControlLeft){
        _pageControl.frame = CGRectMake(0, myFrame.origin.y + myFrame.size.height-20, 20*_imageArray.count, 20);
    }else if(location == PageControlRight){
        _pageControl.frame = CGRectMake(myFrame.size.width - 20*_imageArray.count, myFrame.origin.y + myFrame.size.height-20, 20*_imageArray.count, 20);
    }
    _location = location;
}

@end
