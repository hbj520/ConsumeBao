//
//  BrokenLineView.m
//  eShangBao
//
//  Created by Dev on 16/6/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "BrokenLineView.h"
#import "LineView.h"

@implementation BrokenLineView
{
     LineView *bgView;
    UIView    *myView;
    UILabel  *numLabel;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        myView=[[UIView alloc]initWithFrame:CGRectMake(28, 14, frame.size.width-40, frame.size.height-30)];
        myView.backgroundColor=RGBACOLOR(255, 253, 246, 1);
        [self addSubview:myView];
        
        bgView=[[LineView alloc]initWithFrame:CGRectMake(28, 14, frame.size.width-40, frame.size.height-30)];
        bgView.backgroundColor=[UIColor clearColor];
//        bgView.layer.borderWidth=1.5;
//        bgView.layer.borderColor=RGBACOLOR(250, 250, 250, 1).CGColor;

        [self addSubview:bgView];
    }
    return self;
}

-(void)setAbscissaNum:(int)abscissaNum
{
    _abscissaNum=abscissaNum;
    float distance=bgView.bounds.size.width/abscissaNum;
    
    for (int i=1; i<abscissaNum; i++) {
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(distance*i,0 , 1, bgView.bounds.size.height)];
        label.backgroundColor=RGBACOLOR(230, 230, 230, 1);
        [myView addSubview:label];
        
    }
}

-(void)setDateArr:(NSMutableArray *)dateArr
{
    _dateArr=dateArr;
    float distance=bgView.bounds.size.width/(dateArr.count-1);
    
    for (int i=0; i<dateArr.count; i++) {
        UILabel *ordinateLabel=[[UILabel alloc]initWithFrame:CGRectMake(28+(distance*i)-10, bgView.bounds.size.height+18, 30, 8)];
        ordinateLabel.text=dateArr[6-i];
        ordinateLabel.font=[UIFont systemFontOfSize:6];
        ordinateLabel.textColor=MAINCHARACTERCOLOR;
        [self addSubview:ordinateLabel];
        
    }
    
}

-(void)setAbscissaArr:(NSMutableDictionary *)abscissaArr
{
    
    float newMax1=[_maxStr floatValue]+5;
    float newMin=([_minStr floatValue]-5<=0)?0:[_minStr floatValue]-5;
    float newMax=newMax1-newMin;
    float distance=bgView.bounds.size.width/_abscissaNum;
    
    NSMutableArray *pointArr=[NSMutableArray array];
    
    //for (NSString *key in [abscissaArr allKeys])
    for (int i=0;i<7;i++)
    {
        NSString *key=[NSString stringWithFormat:@"%d",i];
        if (abscissaArr[key]) {
            
            float abscissa=[abscissaArr[key] intValue]-newMin;
            CGPoint point=CGPointMake( distance*[key intValue] , bgView.bounds.size.height*(1-abscissa/newMax));
            
            [pointArr addObject:[NSValue valueWithCGPoint:point]];
            
            
            if (i==6) {
                
                
                float strH=[NSString calculateSizeWithFont:8 Text:[NSString stringWithFormat:@"%.2f",[abscissaArr[key] floatValue]]].width;
                numLabel=[[UILabel alloc]initWithFrame:CGRectMake(distance*i-40+28, bgView.bounds.size.height*(1-abscissa/newMax)-5+10, strH+4, 12)];
                numLabel.backgroundColor=MAINCOLOR;
                numLabel.text=[NSString stringWithFormat:@"%.2f",[abscissaArr[key] floatValue]];
                numLabel.textAlignment=1;
                numLabel.textColor=[UIColor whiteColor];
                numLabel.font=[UIFont systemFontOfSize:8];
                numLabel.layer.cornerRadius=6;
                numLabel.layer.masksToBounds=YES;
                //[bgView addSubview:numLabel];
               
            }
        }
        
        
        
    }
    
    bgView.pointArr=pointArr;
    [bgView setNeedsDisplay];
    [self addSubview:numLabel];
   // [numLabel bringSubviewToFront:bgView];
}

-(void)setMaxStr:(NSString *)maxStr
{
    _maxStr=maxStr;
}
-(void)setMinStr:(NSString *)minStr
{
    _minStr=minStr;
}

-(void)setOrdinateNum:(int)ordinateNum
{
    
    
    float newMax=[_maxStr floatValue]+5;
    float newMin=([_minStr floatValue]-5<=0)?0:[_minStr floatValue]-5;
    
    float  distance1=(newMax-newMin)/ordinateNum;
    float distance=bgView.bounds.size.height/ordinateNum;
    
    for (int i=0; i<ordinateNum+1; i++) {
        
        if (i<ordinateNum) {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0,distance*i, bgView.bounds.size.width,1 )];
        label.backgroundColor=RGBACOLOR(230, 230, 230, 1);
        [myView addSubview:label];
            
        }
        
        //等待数据确定是否需要写出去
        UILabel *ordinateLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 14+(distance*i)-3, 24, 8)];
        ordinateLabel.text=[NSString stringWithFormat:@"%.2f",newMax-distance1*i];
        ordinateLabel.font=[UIFont systemFontOfSize:6];
        ordinateLabel.textAlignment=2;
        ordinateLabel.textColor=MAINCHARACTERCOLOR;
        [self addSubview:ordinateLabel];
        
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
