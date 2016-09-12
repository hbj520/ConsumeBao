//
//  UserInfo.m
//  eShangBao
//
//  Created by Dev on 16/2/2.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "UserInfo.h"

static UserInfo *personInfo;
@implementation UserInfo
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+(UserInfo *)personInfo
{
    if (personInfo==nil) {
        personInfo=[[UserInfo alloc]init];
    } 
    return personInfo;
}
-(void)setMemberid:(NSString *)memberid
{
    //memberid=
    [userDefaults setObject:memberid forKey:@"memberid"];
    [userDefaults synchronize];
}
-(void)setName:(NSString *)name
{

    [userDefaults setObject:name forKey:@"name"];
    [userDefaults synchronize];
}
-(void)setPhone:(NSString *)phone
{
    _phone=phone;
    [userDefaults setObject:phone forKey:@"phone"];
    [userDefaults synchronize];
}

-(void)setImgUrl:(NSString *)imgUrl
{
    [userDefaults setObject:imgUrl forKey:@"imgUrl"];
    [userDefaults synchronize];
}
-(void)setType:(NSString *)type
{
    [userDefaults setObject:type forKey:@"type"];
    [userDefaults synchronize];
}
-(void)setLoginName:(NSString *)loginName
{
    [userDefaults setObject:loginName forKey:@"loginName"];
    [userDefaults synchronize];
}
-(void)setSex:(NSString *)sex
{
    [userDefaults setObject:sex forKey:@"sex"];
    [userDefaults synchronize];
}
-(void)setBirthday:(NSString *)birthday
{
    [userDefaults setObject:birthday forKey:@"birthday"];
    [userDefaults synchronize];
}
-(void)setAge:(NSString *)age
{
    [userDefaults setObject:age forKey:@"age"];
    [userDefaults synchronize];
}
-(void)setQq:(NSString *)qq
{
    [userDefaults setObject:qq forKey:@"qq"];
    [userDefaults synchronize];
}
-(void)setEmail:(NSString *)email
{
    [userDefaults setObject:email forKey:@"email"];
    [userDefaults synchronize];
}
-(void)setProvinceId:(NSString *)provinceId
{
    [userDefaults setObject:provinceId forKey:@"provinceId"];
    [userDefaults synchronize];
}
-(void)setProvinceName:(NSString *)provinceName
{
    [userDefaults setObject:provinceName forKey:@"provinceName"];
    [userDefaults synchronize];
}
-(void)setCityId:(NSString *)cityId
{
    [userDefaults setObject:cityId forKey:@"cityId"];
    [userDefaults synchronize];
}
-(void)setCityName:(NSString *)cityName
{
    [userDefaults setObject:cityName forKey:@"cityName"];
    [userDefaults synchronize];
}
-(void)setAddr:(NSString *)addr{
    [userDefaults setObject:addr forKey:@"addr"];
    [userDefaults synchronize];
}
-(void)setGoldNum:(NSString *)goldNum
{
    [userDefaults setObject:goldNum forKey:@"goldNum"];
    [userDefaults synchronize];
}
-(void)setOpenId:(NSString *)openId
{
    [userDefaults setObject:openId forKey:@"openId"];
    [userDefaults synchronize];
}
-(void)setBankUsername:(NSString *)bankUsername{
    [userDefaults setObject:bankUsername forKey:@"bankUsername"];
    [userDefaults synchronize];
}
-(void)setBankName:(NSString *)bankName{
    [userDefaults setObject:bankName forKey:@"bankName"];
    [userDefaults synchronize];
}
-(void)setBankNo:(NSString *)bankNo
{
    [userDefaults setObject:bankNo forKey:@"bankNo"];
    [userDefaults synchronize];
}
-(void)setPartnerAgencyMethod:(NSString *)partnerAgencyMethod
{
    [userDefaults setObject:partnerAgencyMethod forKey:@"partnerAgencyMethod"];
    [userDefaults synchronize];
}
-(void)setPartnerAgencyPayStatus:(NSString *)partnerAgencyPayStatus
{
    [userDefaults setObject:partnerAgencyPayStatus forKey:@"partnerAgencyPayStatus"];
    [userDefaults synchronize];
}
-(void)setHouseFund:(NSString *)houseFund{
    [userDefaults setObject:houseFund forKey:@"houseFund"];
    [userDefaults synchronize];
}
-(void)setCarFund:(NSString *)carFund
{
    [userDefaults setObject:carFund forKey:@"carFund"];
    [userDefaults synchronize];
}
-(void)setPayDate:(NSString *)payDate
{
    [userDefaults setObject:payDate forKey:@"payDate"];
    [userDefaults synchronize];
}
-(void)setParterLevel:(NSString *)parterLevel
{
    [userDefaults setObject:parterLevel forKey:@"parterLevel"];
    [userDefaults synchronize];
}
-(void)setLevelname:(NSString *)levelname
{
    [userDefaults setObject:levelname forKey:@"levelname"];
    [userDefaults synchronize];
}
-(void)setBankAddr:(NSString *)bankAddr
{
    [userDefaults setObject:bankAddr forKey:@"bankAddr"];
    [userDefaults synchronize];
}
-(void)setInviteCode:(NSString *)inviteCode
{
    [userDefaults setObject:inviteCode forKey:@"inviteCode"];
    [userDefaults synchronize];
}



//-(NSString *)memberid
//{
//    return _name;
//}
//-(NSString *)name
//{
//    //return ;
//}
//-(NSString *)phone
//{
//    
//}
//-(NSString *)type
//{
//    
//}
//-(NSString *)imgUrl
//{
//    
//}
//-(NSString *)loginName
//{
//    
//}
//-(NSString *)sex
//{
//    
//}
//-(NSString *)birthday
//{
//    
//}
//-(NSString *)age
//{
//    
//}
//-(NSString *)qq
//{
//    
//}
//-(NSString *)email
//{
//    
//}
//-(NSString *)provinceId
//{
//    
//}
//-(NSString *)provinceName
//{
//    
//}
//-(NSString *)cityId
//{
//    
//}
//-(NSString *)cityName
//{
//    
//}
//-(NSString *)addr
//{
//    
//}
//-(NSString *)goldNum
//{
//    
//}
//-(NSString *)openId
//{
//    
//}
//-(NSString *)bankUsername
//{
//    
//}
//-(NSString *)bankName
//{
//    
//}
//-(NSString *)bankNo
//{
//    
//}
//-(NSString *)partnerAgencyMethod
//{
//    
//}
//-(NSString *)partnerAgencyPayStatus
//{
//    
//}
//-(NSString *)houseFund
//{
//    
//}
//-(NSString *)carFund
//{
//    
//}
//-(NSString *)payDate
//{
//    
//}
//-(NSString *)parterLevel
//{
//    
//}
//-(NSString *)levelname
//{
//    
//}
//-(NSString *)inviteCode
//{
//    
//}
//-(NSString *)bankAddr
//{
//    
//}



























@end
