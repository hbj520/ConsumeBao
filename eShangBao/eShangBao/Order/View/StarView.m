//
//  StarView.m
//  EvaluationStar
//
//  Created by 赵贺 on 15/11/26.
//  Copyright © 2015年 赵贺. All rights reserved.
//

#import "StarView.h"

#define imageW  self.bounds.size.width/10

@interface StarView ()
{
    UILabel * _label;
}

@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;


@end
@implementation StarView


- (id)initWithFrame:(CGRect)frame EmptyImage:(NSString *)Empty StarImage:(NSString *)Star{
    
    
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _label=[[UILabel alloc]initWithFrame:CGRectMake(W(180), 0, W(32), H(20))];
        _label.textColor=RGBACOLOR(63, 62, 62, 1);
//            _label.backgroundColor=[UIColor cyanColor];
        _label.font=[UIFont systemFontOfSize:14];
        [self addSubview:_label];
        
        self.starBackgroundView = [self buidlStarViewWithImageName:Empty];
        self.starForegroundView = [self buidlStarViewWithImageName:Star];
        [self addSubview:self.starBackgroundView];
        
        self.userInteractionEnabled = YES;
        
        /**点击手势*/
        UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)];
        [self addGestureRecognizer:tapGR];
        
        /**滑动手势*/
        
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)];
        [self addGestureRecognizer:panGR];
        
        
        
    }
    return self;
    
}


- (UIView *)buidlStarViewWithImageName:(NSString *)imageName
{
//    CGRect frame = self.bounds;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, W(240), H(40))];
//    view.backgroundColor=[UIColor redColor];
    view.clipsToBounds = YES;
    
  
    for (int j = 0; j < 5; j ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(2*j*imageW, 0, imageW, imageW);
        [view addSubview:imageView];
    }
    
    
    
    return view;
}

-(void)tapGR:(UITapGestureRecognizer *)tapGR{
    CGPoint point =[tapGR locationInView:self];
    if (point.x<0) {
        point.x = 0;
    }
    
    int X = (int) point.x/(2*imageW);
    DMLog(@"***%d",X);
    NSString * tag;
    if (X+1<6) {
        tag=[NSString stringWithFormat:@"%d",X+1];
    }
    else
    {
        tag=@"5";
    }
    
    
    NSDictionary * dic=@{@"tag":tag};
    DMLog(@"++++++%@",dic);
    _block(dic);
    self.starForegroundView.frame = CGRectMake(0, 0, (X+1)*2*imageW, imageW);
    [self addSubview:self.starForegroundView];
    switch (X) {
        case 0:
            _label.text=@"很差";
            break;
        case 1:
            _label.text=@"一般";
            break;
        case 2:
            _label.text=@"可以";
            break;
        case 3:
            _label.text=@"很好";
            break;
        case 4:
            _label.text=@"很棒";
            break;
        default:
            break;
            
    }
    
    
}
@end
