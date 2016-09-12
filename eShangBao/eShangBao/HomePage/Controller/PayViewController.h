//
//  PayViewController.h
//  eShangBao
//
//  Created by doumee on 16/1/15.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Product : NSObject{
@private
    float     _price; // 价格
    NSString * type;  // 类型
    
}

@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *type;

@end
@interface PayViewController : UIViewController

@property (nonatomic,retain)UIButton * sureBtn;

@property (nonatomic,retain)UIButton * accomplishBtn;

@property (nonatomic,copy) NSString*count;      // 支付余额

@property (nonatomic,copy) NSString*urlString;

@property (nonatomic,copy) NSString*orderNo;    // 支付订单号

@property(nonatomic,retain)UIButton * goldBtn;

@property(nonatomic,retain)UIButton * platinumBtn;

@property(nonatomic,retain)UIButton * diamondBtn;

@property(nonatomic,retain)UIButton * weixinBtn;//选择微信

@property(nonatomic,retain)UIButton * zhifubaoBtn;//选择支付宝

@property(nonatomic,retain)UIButton * payinCashBtn;

@property(nonatomic,retain)NSString * tuiName;//推荐人姓名

@property(nonatomic,retain)NSString * phone;//推荐人手机号

@property(nonatomic,retain)NSString * idNumber;//推荐人身份证号

@property(nonatomic,retain)NSString * etype;//推荐身份

@property(nonatomic,retain)NSString * payType;//支付方式

@property(nonatomic,assign)int whichPage;//从哪个页面跳转过来

//@property(nonatomic,assign)int type;

@property (nonatomic,retain)NSString * inviteCode;//邀请码

@property (nonatomic,retain)NSString * shopName;//门店名称

@property (nonatomic,retain)NSString * branchName;//分店名称

@property (nonatomic,retain)NSString * branchPhone;//门店电话

@property (nonatomic,retain)NSString * shopAddr;//门店地址

@property (nonatomic,retain)NSString * categoryId;//经营分类编码

@property (nonatomic,retain)NSMutableArray * firstImgArr;//门店首图数组

@property (nonatomic,retain)NSString * firstImgUrl;//门店首图

@property (nonatomic,retain)NSMutableArray * storeImgArr;//店铺图片数组

@property (nonatomic,retain)NSString * storeImgUrl;//

@property (nonatomic,retain)NSString * licenceImgUrl;//营业执照

@property (nonatomic,retain)NSString * allowImgUrl;//许可证

@property (nonatomic,retain)NSString * number;//编号

@property (nonatomic,retain)NSString * name;//真实姓名

@property (nonatomic,retain)NSString * idcardno;//身份证号

@property (nonatomic,retain)NSString * latitude;

@property (nonatomic,retain)NSString * longitude;

@property (nonatomic,retain)NSString * loginName;
@end
