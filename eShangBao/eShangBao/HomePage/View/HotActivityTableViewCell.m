//
//  HotActivityTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/4/5.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "HotActivityTableViewCell.h"

@implementation HotActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.opaque=YES;
    
        
        self.backgroundColor=RGBACOLOR(249, 249, 249, 1);
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, H(2), 32)];
        lineLabel.backgroundColor=RGBACOLOR(247, 137, 0, 1);
        [self.contentView addSubview:lineLabel];
        
        UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 6, W(100), H(20))];
        titleLabel.text=@"众筹项目介绍";
        titleLabel.font=[UIFont systemFontOfSize:12];
        titleLabel.textColor=GRAYCOLOR;
        [self.contentView addSubview:titleLabel];
        
       // long projectNum=(_projectModelArr.count+1)/2;
        
    }
    
    return self;
}

#warning 待处理 主要在赋值
-(void)setDataModelArr:(NSMutableArray *)dataModelArr
{
    
    _dataModelArr=dataModelArr;
    long projectNum=(dataModelArr.count+1)/2;
    UIView *contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 33, KScreenWidth, 75*projectNum+10)];
    contentView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:contentView];
    

    float viewW=(KScreenWidth-30)/2.;
    for (int i = 0; i<dataModelArr.count; i++) {
        
        
        
        ProjectIntroductionModel *model=dataModelArr[i];
        
        UIView *blockView=[[UIView alloc]initWithFrame:CGRectMake(10+(i%2*(10+viewW)), 10+(i/2*(75)), viewW, 65)];
        blockView.layer.borderWidth=1;
        blockView.tag=10+i;
        blockView.layer.borderColor=RGBACOLOR(231, 231, 231, 1).CGColor;
        [contentView addSubview:blockView];
        
        
        float titalLabel1W=[NSString calculateSizeWithFont:12. Text:model.name].width;
        UILabel *titalLabel1=[[UILabel alloc]initWithFrame:CGRectMake(W(10), 15, titalLabel1W, 12)];
        titalLabel1.font=[UIFont systemFontOfSize:12.];
        titalLabel1.text=model.name;
        titalLabel1.textColor=MAINCHARACTERCOLOR;
        [blockView addSubview:titalLabel1];
        
        UILabel *moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titalLabel1.frame), 17, 100, 10)];
        moneyLabel.font=[UIFont systemFontOfSize:10];
        moneyLabel.text=[NSString stringWithFormat:@"(%@元)",model.price];
        moneyLabel.textColor=MAINCHARACTERCOLOR;
        [blockView addSubview:moneyLabel];
        
        
        
        UILabel *detailsLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(blockView.bounds)-60, 36, 50, 16)];
        detailsLabel.font=[UIFont systemFontOfSize:10];
        detailsLabel.text=@"了解详情";
        detailsLabel.backgroundColor=RGBACOLOR(237, 108, 45, 1);
        detailsLabel.textAlignment=1;
        detailsLabel.textColor=[UIColor whiteColor];
        [blockView addSubview:detailsLabel];
        
        UIButton *detailsButton=[UIButton buttonWithType:0];
        //[detailsButton setTitle:@"了解详情" forState:0];
        //            detailsButton.backgroundColor=RGBACOLOR(237, 108, 45, 1);
        detailsButton.frame=blockView.bounds;
        detailsButton.titleLabel.font=[UIFont systemFontOfSize:10];
        //            [detailsButton setTitleColor:[UIColor whiteColor] forState:0];
        detailsButton.tag=i;
        [detailsButton addTarget:self action:@selector(detailsButtonClick:) forControlEvents:1<<6];
        [blockView addSubview:detailsButton];
        
        UIImageView *starImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titalLabel1.frame)+12, 65, 10)];
        int starNum=[model.score intValue];
        starImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d_05副本",starNum]];

//        starImage.image=[UIImage imageNamed:@"5_05副本"];
        [blockView addSubview:starImage];
        
    }
        

    
    
}

-(void)detailsButtonClick:(UIButton *)sender
{
    ProjectIntroductionModel *model=_dataModelArr[sender.tag];
    if ([_mydelegate respondsToSelector:@selector(pushDetailsVC:)]) {
        [_mydelegate pushDetailsVC:model];
    }
    DMLog(@"查看详情");
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
