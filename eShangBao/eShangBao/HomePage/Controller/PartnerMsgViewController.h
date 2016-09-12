//
//  PartnerMsgViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/15.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartnerMsgViewController : UIViewController

@property(nonatomic,retain)UITextField * inviteTF;

@property(nonatomic,retain)UITextField * nameTF;

@property(nonatomic,retain)UITextField * IDTF;

@property(nonatomic,retain)UITextField * phoneTF;

@property(nonatomic,retain)NSString    * whichPage;//哪一页跳过去的

@property(nonatomic,strong)ProjectIntroductionModel *projectModel;
@end
