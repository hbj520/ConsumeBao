//
//  HeadTableViewCell.h
//  eShangBao
//
//  Created by doumee on 16/1/16.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadTableViewCell : UITableViewCell

@property(nonatomic,retain)UIImageView *headImg;//头像

@property(nonatomic,retain)UILabel * titleLabel;//昵称

@property(nonatomic,retain)UILabel * phoneLabel;//

@property(nonatomic,retain)UIImageView * levelImg;

@property(nonatomic,retain)UIButton * loginBtn;

@property(nonatomic,retain)UILabel  * nameLabel;//姓名

@property(nonatomic,retain)UILabel  * levelLabel;//等级

@property(nonatomic,retain)UILabel  * dateLabel;//日期


@property(nonatomic,strong)UIButton *chooseButton1;//佣金
@property(nonatomic,strong)UIButton *chooseButton2;//福利
@property(nonatomic,strong)UIButton *chooseButton3;//收益权
@property(nonatomic,strong)UIButton *chooseButton4;//收益权分红


@property(nonatomic,strong)NSMutableArray * coinArr;

+(instancetype)nowStatusWithTableView:(UITableView *)tableView coinArr:(NSMutableArray*)coinArr;
@end
