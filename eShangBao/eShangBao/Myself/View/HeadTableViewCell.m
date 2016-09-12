
//
//  HeadTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/1/16.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "HeadTableViewCell.h"

@implementation HeadTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

+(instancetype)nowStatusWithTableView:(UITableView *)tableView coinArr:(NSMutableArray *)coinArr
{
    HeadTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"headCell"];
    if (!cell) {
        cell=[[HeadTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"headCell"];
    }
    
    [cell addSubviews:coinArr];
    return cell;
}


-(void)addSubviews:(NSMutableArray*)coinArr
{
    self.backgroundColor=RGBACOLOR(251, 98, 7, 1);
    
    UIImageView * bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 140)];
    //        bgImg.backgroundColor=[UIColor redColor];
    bgImg.image=[UIImage imageNamed:@"personal_bg"];
    [self.contentView addSubview:bgImg];
    
    _headImg=[[UIImageView alloc]initWithFrame:CGRectMake(20, 38+10+5, 55, 55)];
    _headImg.layer.cornerRadius=_headImg.frame.size.height/2;
    _headImg.layer.masksToBounds=YES;
    _headImg.backgroundColor=[UIColor redColor];
    [self.contentView addSubview:_headImg];
    
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_headImg)+10, 22+20+10, WIDTH-20*2-48-10, 15)];
    _titleLabel.text=@"昵称: 夜尽天明";
    _titleLabel.font=[UIFont systemFontOfSize:12];
    _titleLabel.textColor=[UIColor whiteColor];
    [self.contentView addSubview:_titleLabel];
    
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_headImg)+10, kDown(_titleLabel)+5, WIDTH-20*2-48-10, 15)];
    _nameLabel.textColor=[UIColor whiteColor];
    _nameLabel.text=@"姓名: 赵天明";
    _nameLabel.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:_nameLabel];
    
    _levelLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_headImg)+10, kDown(_nameLabel)+5, WIDTH-20*2-48-10, 15)];
    _levelLabel.textColor=[UIColor whiteColor];
    _levelLabel.text=@"会员级别: 金商合伙人";
    _levelLabel.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:_levelLabel];
    
    //        _dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_headImg)+10, kDown(_levelLabel)+5, WIDTH-20*2-48-10, 15)];
    //        _dateLabel.textColor=[UIColor whiteColor];
    //        _dateLabel.text=@"注册日期: 2016-01-01";
    //        _dateLabel.font=[UIFont systemFontOfSize:12];
    //        [self.contentView addSubview:_dateLabel];
    
    
    
    UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(bgImg), WIDTH, 140)];
    coverView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:coverView];
    
    UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, WIDTH, 1)];
    lineLabel.backgroundColor=BGMAINCOLOR;
    [coverView addSubview:lineLabel];
    
    UILabel * rowLine=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2, 0, 1, 140)];
    rowLine.backgroundColor=BGMAINCOLOR;
    [coverView addSubview:rowLine];
    
    
    _chooseButton1=[UIButton buttonWithType:0];
    _chooseButton2=[UIButton buttonWithType:0];
    _chooseButton3=[UIButton buttonWithType:0];
    _chooseButton4=[UIButton buttonWithType:0];
    
    _chooseButton1.tag=1;
    _chooseButton2.tag=2;
    _chooseButton3.tag=3;
    _chooseButton4.tag=4;
    
    NSArray * buttonArr=@[_chooseButton1,_chooseButton2,_chooseButton3,_chooseButton4];
    NSArray * imgArr=@[@"moneyType_1",@"moneyType_2",@"moneyType_3",@"moneyType_4"];
    NSArray * titleArr=@[@"佣金账户(通宝币)",@"福利投资积分",@"收益权",@"收益权分红"];
    //        NSArray * detailsArr=@[@"2500.00",@"5万积分可购买商品",@"一次购买不得超过1万元",@"可转入佣金账户"];
    for (int i=0; i<4; i++) {
        UIImageView * iconImg=[[UIImageView alloc]initWithFrame:CGRectMake((i%2)*WIDTH/2+20, (i/2)*70+18, 30, 30)];
        //            iconImg.backgroundColor=[UIColor cyanColor];
        iconImg.image=[UIImage imageNamed:imgArr[i]];
        iconImg.layer.cornerRadius=iconImg.frame.size.height/2;
        iconImg.layer.masksToBounds=YES;
        [coverView addSubview:iconImg];
        
        UIButton *newButton=buttonArr[i];
        newButton.frame=CGRectMake(KScreenWidth/2.*(i%2), 70*(i/2), KScreenWidth/2., 70);
        //newButton.backgroundColor=[UIColor redColor];
        [coverView addSubview:newButton];
        
        
        UILabel * iconLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(iconImg)+5, 14+(i/2)*70, 100, 20)];
        //            iconLabel.backgroundColor=[UIColor redColor];
        iconLabel.text=titleArr[i];
        iconLabel.textColor=MAINCHARACTERCOLOR;
        iconLabel.font=[UIFont systemFontOfSize:12];
        [coverView addSubview:iconLabel];
        
        UILabel * iconDetailLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(iconImg)+5, kDown(iconLabel), 100, 20)];
        //            iconDetailLabel.backgroundColor=[UIColor cyanColor];
        iconDetailLabel.text=[NSString stringWithFormat:@"%@",coinArr[i]];
        iconDetailLabel.textColor=MAINCHARACTERCOLOR;
        iconDetailLabel.font=[UIFont systemFontOfSize:12];
        [coverView addSubview:iconDetailLabel];
    }
    //        _headImg=[[UIImageView alloc]initWithFrame:CGRectMake(W(12), H(5)+H(40), W(50), H(50))];
    //        _headImg.layer.masksToBounds=YES;
    //        _headImg.layer.cornerRadius=3;
    //        _headImg.contentMode=2;
    //        [self.contentView addSubview:_headImg];
    //
    //        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_headImg)+W(10), H(10)+H(40), W(100), H(20))];
    //        _titleLabel.font=[UIFont systemFontOfSize:14];
    //        _titleLabel.textColor=[UIColor whiteColor];
    ////        _titleLabel.backgroundColor=[UIColor cyanColor];
    ////        CGSize size =  [self sizeWithString:_titleLabel.text font:_titleLabel.font];
    ////        _titleLabel.frame = CGRectMake(kRight(_headImg)+W(10), H(10), size.width, size.height);
    //        //        categorLabel.center = self.contentView.center;
    //        [self.contentView addSubview:_titleLabel];
    //
    //        _phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_headImg)+W(10), kDown(_titleLabel)+H(5), W(200), H(20))];
    //        _phoneLabel.textColor=[UIColor whiteColor];
    //        _phoneLabel.font=[UIFont systemFontOfSize:12];
    //        [self.contentView addSubview:_phoneLabel];
    //
    //        _levelImg=[[UIImageView alloc]initWithFrame:CGRectMake(kRight(_titleLabel), H(10)+H(40), W(20), H(20))];
    ////        _levelImg.image=[UIImage imageNamed:@"hhr_z"];
    //        _levelImg.contentMode=2;
    //        [self.contentView addSubview:_levelImg];
    //
    _loginBtn=[UIButton buttonWithType:0];
    _loginBtn.hidden=YES;
    _loginBtn.frame=CGRectMake(kRight(_headImg)+15, 22+20+10+5+10, 80, H(25));
    _loginBtn.layer.borderWidth=1.5;
    _loginBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    _loginBtn.layer.cornerRadius=3;
    _loginBtn.layer.masksToBounds=YES;
    [_loginBtn setTitle:@"立即登录" forState:0];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:0];
    _loginBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:_loginBtn];
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
       
        
        
    }
    
    return self;
}

// 定义成方法方便多个label调用 增加代码的复用性
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(320, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
