//
//  PersonalTableViewCell.h
//  eShangBao
//
//  Created by doumee on 16/3/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalTableViewCell : UITableViewCell

@property(nonatomic,assign)int type;
@property(nonatomic,retain)NSString * myImgUrl;
@property(nonatomic,retain)NSString * myNickName;
@end
