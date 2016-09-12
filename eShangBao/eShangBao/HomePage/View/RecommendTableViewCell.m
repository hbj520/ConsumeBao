//
//  RecommendTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/1/25.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "RecommendTableViewCell.h"
#import "RecommendCollectionViewCell.h"
#import "StoreInfoViewController.h"


@implementation RecommendTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

+(instancetype)nowStatusWithTableView:(UITableView *)tableView section:(NSInteger)section cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (!cell) {
        cell=[[RecommendTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell1"];
    }
    cell.opaque=YES;
    [cell addSubviews:section];
    return cell;
}

-(void)addSubviews:(NSInteger)height
{
    view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 33)];
    view.backgroundColor=RGBACOLOR(249, 249, 249, 1);
    UILabel * label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 2, 33)];
    label1.backgroundColor=RGBACOLOR(247, 137, 0, 1);
    [view addSubview:label1];
    
    UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, W(100), 33)];
    titleLabel.text=@"收益权走势图";
    titleLabel.textColor=GRAYCOLOR;
    titleLabel.font=[UIFont systemFontOfSize:12];
    [view addSubview:titleLabel];
    [self.contentView addSubview:view];
    
    //此处数据待处理
    
    
    
}

-(void)setDataArr:(NSMutableArray *)dataArr
{
    [brokenView removeFromSuperview];
    brokenView=[[BrokenLineView alloc]initWithFrame:CGRectMake(0, 33, KScreenWidth, 170)];
    //
    brokenView.abscissaNum=6;
    [self.contentView addSubview:brokenView];
    DMLog(@"datarr＝%@",dataArr);
    NSMutableArray *dateArr1=[NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary *dateDic=[NSMutableDictionary dictionary];
    NSMutableDictionary *abscissaDic=[NSMutableDictionary dictionary];
    
    
    NSDate * mydate = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //[dateArr1 addObject:currentDateStr];
    //[dateDic setObject:@"6" forKey:currentDateStr];
    DMLog(@"---当前的时间的字符串 =%@",currentDateStr);
    for (int i=1; i<8; i++) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSDateComponents *comps = nil;
        
        comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:mydate];
        
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        
        [adcomps setYear:0];
        
        [adcomps setMonth:0];
        
        [adcomps setDay:-i];
        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
        NSString *beforDate = [dateFormatter stringFromDate:newdate];
        DMLog(@"---前7天=%@",beforDate);
        [dateArr1 addObject:beforDate];
        [dateDic setObject:[NSString stringWithFormat:@"%d",7-i] forKey:beforDate];

    }
//    
//    for (int i=1; i<8; i++) {
//        
//        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//        
//        NSDateComponents *comps = nil;
//        
//        comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMonth fromDate:mydate];
//        
//        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
//        
//        [adcomps setYear:0];
//        
//        [adcomps setMonth:0];
//        
//        [adcomps setDay:-i];
//        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
//        NSString *beforDate = [dateFormatter stringFromDate:newdate];
//        DMLog(@"---前7天=%@",beforDate);
//        [dateArr1 addObject:beforDate];
//        
//    }

    
    NSString *maxStr=@"0";
    UsufructModel *newModel=dataArr[0];
    NSString *minStr=[NSString stringWithFormat:@"%@",newModel.rate];
    for (UsufructModel *model in  dataArr) {
        
        NSString *dateStr=[model.createDate substringFromIndex:model.createDate.length-5];
        DMLog(@"dateStr==%@",dateStr);
        NSString *key=dateDic[dateStr];
        if ([model.rate floatValue]>[maxStr floatValue]) {
            maxStr=model.rate;
        }
        if ([model.rate floatValue]<[minStr floatValue]) {
            
            minStr=model.rate;
        }
        [abscissaDic setObject:model.rate forKey:key];
    }
    
    brokenView.maxStr=maxStr;
    brokenView.minStr=minStr;
    brokenView.ordinateNum=5;
    brokenView.dateArr=dateArr1;
    brokenView.abscissaArr=abscissaDic;
    
    
}
-(void)setType:(int)type
{
    if (type==0) {
        
        _detailsButton=[UIButton buttonWithType:0];
        _detailsButton.frame=CGRectMake(0, 0, KScreenWidth-15, 33);
        [_detailsButton setTitle:@"了解详情 >  " forState:0];
        _detailsButton.titleLabel.font=[UIFont systemFontOfSize:12];
        _detailsButton.contentHorizontalAlignment=2;
        [_detailsButton setTitleColor:GRAYCOLOR forState:0];
        [view addSubview:_detailsButton];
        
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
