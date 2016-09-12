//
//  UserInfo.h
//  eShangBao
//
//  Created by Dev on 16/2/2.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
{
    NSUserDefaults  *userDefaults;
    NSString      *memberid;
}

//@property(nonatomic,strong)NSString      *memberid;//	用户标识（唯一）
@property(nonatomic,strong)NSString      *name;//	用户名
@property(nonatomic,strong)NSString      *phone;//	用户手机号
@property(nonatomic,strong)NSString      *type;//	会员身份会员身份 0普通会员 1合伙人 2商家
@property(nonatomic,strong)NSString      *imgUrl;//	用户头像
@property(nonatomic,strong)NSString      *loginName;//	登录账号
@property(nonatomic,strong)NSString      *sex;//	性别0男 1女2未知
@property(nonatomic,strong)NSString      *birthday;//	出生日期
@property(nonatomic,strong)NSString      *age;//	年龄
@property(nonatomic,strong)NSString      *qq;//	QQ号
@property(nonatomic,strong)NSString      *email;//	邮箱地址
@property(nonatomic,strong)NSString      *provinceId;//	省份编码
@property(nonatomic,strong)NSString      *provinceName;//	省份名称
@property(nonatomic,strong)NSString      *cityId;//	城市编码
@property(nonatomic,strong)NSString      *cityName;//	城市名称
@property(nonatomic,strong)NSString      *addr;//	详细地址
@property(nonatomic,strong)NSString      *goldNum;//	通宝币数量
@property(nonatomic,strong)NSString      *openId;//	微信标准
@property(nonatomic,strong)NSString      *bankUsername;//	开户人姓名
@property(nonatomic,strong)NSString      *bankName;//	开户行名称
@property(nonatomic,strong)NSString      *bankNo;//	银行卡号
@property(nonatomic,strong)NSString      *partnerAgencyMethod;//	代理费支付方式（0线上支付1线下支付）
@property(nonatomic,strong)NSString      *partnerAgencyPayStatus;//	代理费支付状态（0未支付1已支付）
@property(nonatomic,strong)NSString      *houseFund;//	房基金
@property(nonatomic,strong)NSString      *carFund;//	车基金
@property(nonatomic,strong)NSString      *payDate;//	支付日期
@property(nonatomic,strong)NSString      *parterLevel;//	合伙人级别编码
@property(nonatomic,strong)NSString      *levelname;//	合伙人等级名称
@property(nonatomic,strong)NSString      *inviteCode;//	邀请码
@property(nonatomic,strong)NSString      *bankAddr;//	开户行所在地

-(void)setMemberid:(NSString *)memberid;
-(void)setName:(NSString *)name;
-(void)setPhone:(NSString *)phone;
-(void)setType:(NSString *)type;
-(void)setImgUrl:(NSString *)imgUrl;
-(void)setLoginName:(NSString *)loginName;
-(void)setSex:(NSString *)sex;
-(void)setBirthday:(NSString *)birthday;
-(void)setAge:(NSString *)age;
-(void)setQq:(NSString *)qq;
-(void)setEmail:(NSString *)email;
-(void)setProvinceId:(NSString *)provinceId;
-(void)setProvinceName:(NSString *)provinceName;
-(void)setCityId:(NSString *)cityId;
-(void)setCityName:(NSString *)cityName;
-(void)setAddr:(NSString *)addr;
-(void)setGoldNum:(NSString *)goldNum;
-(void)setOpenId:(NSString *)openId;
-(void)setBankAddr:(NSString *)bankAddr;
-(void)setBankName:(NSString *)bankName;
-(void)setBankUsername:(NSString *)bankUsername;
-(void)setBankNo:(NSString *)bankNo;
-(void)setPartnerAgencyMethod:(NSString *)partnerAgencyMethod;
-(void)setPartnerAgencyPayStatus:(NSString *)partnerAgencyPayStatus;
-(void)setHouseFund:(NSString *)houseFund;
-(void)setCarFund:(NSString *)carFund;
-(void)setPayDate:(NSString *)payDate;
-(void)setParterLevel:(NSString *)parterLevel;
-(void)setInviteCode:(NSString *)inviteCode;
-(void)setLevelname:(NSString *)levelname;



-(NSString *)memberid;
-(NSString *)name;
-(NSString *)phone;
-(NSString *)type;
-(NSString *)imgUrl;
-(NSString *)loginName;
-(NSString *)sex;
-(NSString *)birthday;
-(NSString *)age;
-(NSString *)qq;
-(NSString *)email;
-(NSString *)provinceId;
-(NSString *)provinceName;
-(NSString *)cityId;
-(NSString *)cityName;
-(NSString *)addr;
-(NSString *)goldNum;
-(NSString *)openId;
-(NSString *)bankUsername;
-(NSString *)bankName;
-(NSString *)bankNo;
-(NSString *)partnerAgencyMethod;
-(NSString *)partnerAgencyPayStatus;
-(NSString *)houseFund;
-(NSString *)carFund;
-(NSString *)payDate;
-(NSString *)parterLevel;
-(NSString *)levelname;
-(NSString *)inviteCode;
-(NSString *)bankAddr;



-(void)setValue:(id)value forUndefinedKey:(NSString *)key;


+(UserInfo *)personInfo;




@end
