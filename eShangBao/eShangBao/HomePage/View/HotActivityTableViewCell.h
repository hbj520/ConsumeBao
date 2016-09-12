//
//  HotActivityTableViewCell.h
//  eShangBao
//
//  Created by doumee on 16/4/5.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol pushDetailsVCDelegate <NSObject>

-(void)pushDetailsVC:(ProjectIntroductionModel *)projectModel;

@end

@interface HotActivityTableViewCell : UITableViewCell

@property(nonatomic,strong)id<pushDetailsVCDelegate>mydelegate;

//@property(nonatomic,retain)UIImageView * image1;
//
//@property(nonatomic,retain)UIImageView * image2;
//
//@property(nonatomic,retain)UIImageView * image3;
//
//@property(nonatomic,retain)UIButton    * button1;
//
//@property(nonatomic,retain)UIButton    * button2;
//
//@property(nonatomic,retain)UIButton    * button3;

@property(nonatomic,strong)NSMutableArray *dataModelArr;


@end
