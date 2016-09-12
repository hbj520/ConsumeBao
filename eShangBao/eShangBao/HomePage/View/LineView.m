//
//  LineView.m
//  FamilyTree
//
//  Created by Dev on 16/5/20.
//  Copyright © 2016年 wangqi. All rights reserved.
//

#import "LineView.h"

@implementation LineView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    
    self.backgroundColor=[UIColor clearColor];
}

-(void)drawRect:(CGRect)rect
{
 

//    // 1.获得图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath *path=[UIBezierPath bezierPath];
    CGPoint point;
    if (_pointArr.count>0) {
        point=[_pointArr[0] CGPointValue];
    }
    [path moveToPoint:point];
    for (int i = 1;i<_pointArr.count;i++) {
        
            CAShapeLayer *pathLayer = [CAShapeLayer layer];
            pathLayer.frame = self.bounds;

            if (i==_pointArr.count-1) {
                
                CGPoint point=[_pointArr[i] CGPointValue];
                
                point.x=point.x-6;
                point.y=point.y;
                
                CGContextSetRGBStrokeColor(ctx,251/255.,73/255,38/255,1.0);//画笔线的颜色
                CGContextSetLineWidth(ctx, 2.0);//线的宽度
                CGContextAddArc(ctx, point.x+2, point.y, 2.5, 0, 2*M_PI, 0); //添加一个圆
                CGContextStrokePath(ctx);
                
                [path addLineToPoint:point];
                pathLayer.lineWidth = 3.0f;
                
                
            }else{
                
                
                [path addLineToPoint:[_pointArr[i] CGPointValue]];
                pathLayer.lineWidth = 3.0f;
                
            }
            pathLayer.path = path.CGPath;
            pathLayer.strokeColor = RGBACOLOR(251, 73, 8, 1.0).CGColor;
            pathLayer.fillColor = nil;
            [self.layer addSublayer:pathLayer];
            
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = 2.0;
            pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
            pathAnimation.toValue = [NSNumber numberWithFloat:2.0f];
            [pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
        
        
        
            // 更新界面
            [path stroke];
       
       
    }
}

@end
