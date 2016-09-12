//
//  ElseTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/1/25.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "ElseTableViewCell.h"
#import "SXMarquee.h"
#import "CategoryViewController.h"
@implementation ElseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

+(instancetype)StatusTableView:(UITableView *)tableView Array:(NSMutableArray*)array cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ElseTableViewCell * cell=[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell=[[ElseTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"elseCell"];
        [cell addSubviews:array];
        
    }
    cell.opaque=YES;
    return cell;
}

-(void)addSubviews:(NSMutableArray*)array
{
    
    if (!_adView) {
        
        _adView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, W(180))];
        _adView.backgroundColor=[UIColor brownColor];
    }
    
    _recImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, W(180))];
    _recImg.contentMode=2;
    _recImg.layer.masksToBounds=YES;
    [self.contentView addSubview:_recImg];
    
    //第一排的图标
    imgArr=@[@"1_xfzc",@"2_syqzc",@"3_hhrrz",@"4_xszn"];
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(_adView), WIDTH, 80)];
    view.opaque=YES;
    [self.contentView addSubview:view];

    
    
    NSArray * titleArrs1=@[@"消费宝商城",@"联营超市",@"联盟商家",@"我的主页"];
    //NSArray * titleArrs=@[@"联营超市",@"超市供应商",@"合伙人入口",@"新手指南"];
    NSArray * titleArrs=@[@"消费众筹",@"收益权众筹",@"合伙人入口",@"新手入门"];
    
    float  viewWidth=KScreenWidth/4.;

    for (int i=0; i<titleArrs1.count; i++) {
        
        //_model=titleArrs1[i];
        UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake(viewWidth*i, 0, viewWidth, 80)];
        //            btnView.backgroundColor=RGBACOLOR(10*i, 20*i, 20, 1);
        [view addSubview:btnView];
        
        
        UILabel *categoryName=[[UILabel alloc]initWithFrame:CGRectMake(0, 58, viewWidth, 14)];
        categoryName.font=[UIFont systemFontOfSize:12];
        categoryName.textAlignment=1;
        categoryName.text=titleArrs[i];
        categoryName.textColor=MAINCHARACTERCOLOR;
        [btnView addSubview:categoryName];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 36, 36)];
        imageView.center=CGPointMake(categoryName.center.x, imageView.center.y);
        imageView.backgroundColor=MAINCOLOR;
        imageView.layer.cornerRadius=imageView.frame.size.height/2.;
        imageView.layer.masksToBounds=YES;
        imageView.opaque=YES;
        imageView.image=[UIImage imageNamed:imgArr[i]];
        [btnView addSubview:imageView];
        
    }
    
    
    _button1=[UIButton buttonWithType:0];
    _button1.frame=CGRectMake(0, H(5), W(80), H(80));
    _button1.tag=10;
    [view addSubview:_button1];
    
    
    _button2=[UIButton buttonWithType:0];
    _button2.tag=11;
    _button2.frame=CGRectMake(W(80), H(5), W(80), H(80));
    [view addSubview:_button2];
    
    _button3=[UIButton buttonWithType:0];
    _button3.tag=12;
    _button3.frame=CGRectMake(W(80)*2, H(5), W(80), H(80));
    [view addSubview:_button3];
    
    _button4=[UIButton buttonWithType:0];
    _button4.tag=13;
    _button4.frame=CGRectMake(W(80)*3, H(5), W(80), H(80));
    [view addSubview:_button4];
    
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, kDown(view), WIDTH, H(80))];
    _scrollView.showsHorizontalScrollIndicator=NO;
    [self.contentView addSubview:_scrollView];
    
    //第二排的图标
    NSArray *myImage=@[@"5_sfbsc",@"6_lycs",@"7_sj",@"8_wdzy"];
    if (titleArrs1.count<=4) {
        
        float  vieWidth=KScreenWidth/titleArrs1.count;
        for (int i=0; i<titleArrs1.count; i++) {
            UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake(vieWidth*i, 0, vieWidth, H(75))];
            [_scrollView addSubview:btnView];
            
            
            UILabel *categoryName=[[UILabel alloc]initWithFrame:CGRectMake(0, 48, vieWidth, 14)];
            categoryName.font=[UIFont systemFontOfSize:12];
            categoryName.textAlignment=1;
            categoryName.text=titleArrs1[i];
            categoryName.textColor=MAINCHARACTERCOLOR;
            [btnView addSubview:categoryName];
            
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 4, 36, 36)];
            imageView.center=CGPointMake(categoryName.center.x, imageView.center.y);
            imageView.backgroundColor=MAINCOLOR;
            imageView.layer.cornerRadius=imageView.frame.size.height/2.;
            imageView.layer.masksToBounds=YES;
            imageView.opaque=YES;
            imageView.image=[UIImage imageNamed:myImage[i]];
            [btnView addSubview:imageView];
            
            
            UIButton *chooseCategoryBtn=[[UIButton alloc]initWithFrame:btnView.bounds];
            chooseCategoryBtn.tag=i;
            [chooseCategoryBtn addTarget:self action:@selector(speciesButtonClick:) forControlEvents:1<<6];
            [btnView addSubview:chooseCategoryBtn];
            
            
        }
       
    }else{
        
        float  vieWidth=KScreenWidth/4-W(10);
        for (int i=0; i<titleArrs1.count; i++) {
            
            //_model=titleArrs1[i];
            UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake(vieWidth*i, 0, vieWidth, H(70))];
            [_scrollView addSubview:btnView];
            
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(W(25), 4, W(36), W(36))];
            imageView.layer.cornerRadius=imageView.frame.size.height/2.;
            imageView.layer.masksToBounds=YES;
            imageView.image=[UIImage imageNamed:myImage[i]];
            [btnView addSubview:imageView];
            
            UILabel *categoryName=[[UILabel alloc]initWithFrame:CGRectMake(W(3), kDown(imageView)+4, vieWidth+W(10), 14)];
            categoryName.textAlignment=NSTextAlignmentCenter;
            categoryName.font=[UIFont systemFontOfSize:12];
            categoryName.textAlignment=1;
            categoryName.text=titleArrs1[i];
            categoryName.textColor=MAINCHARACTERCOLOR;
            [btnView addSubview:categoryName];
            
            UIButton *chooseCategoryBtn=[[UIButton alloc]initWithFrame:btnView.bounds];
            chooseCategoryBtn.tag=i;
            [chooseCategoryBtn addTarget:self action:@selector(speciesButtonClick:) forControlEvents:1<<6];
            [btnView addSubview:chooseCategoryBtn];
            
        }
        _scrollView.contentSize=CGSizeMake(vieWidth*titleArrs1.count+20, 0);
        
    }
}


-(void)speciesButtonClick:(UIButton * )sender
{
    //点击事件跳转待处理。。。。
//    DMLog(@"点击了");
//    _model=_categoryArr[sender.tag];
//    DMLog(@"name----%@",_model.cateName);
//    CategoryViewController * cateVC=[[CategoryViewController alloc]init];
//    cateVC.hidesBottomBarWhenPushed=YES;
//    cateVC.categoryName=_model.cateName;
//    cateVC.categoryId=_model.cateId;
    [self.delegate pushView:(int)sender.tag];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
