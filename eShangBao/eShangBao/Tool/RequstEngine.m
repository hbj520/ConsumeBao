//
//  RequstEngine.m
//  eShangBao
//
//  Created by Dev on 16/1/29.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "RequstEngine.h"
#import "CompressUtils.h"
#import "EncryptUtils.h"
#import "ASIHTTPRequest.h"

@implementation RequstEngine


+(void)requestHttp:(NSString *)urlNum paramDic:(NSDictionary *)param blockObject:(void (^)(NSDictionary *))complete
{
    NSDictionary *dic;
    if (param==nil) {
        
        dic =@{@"userId": USERID,@"version":VERSION,@"appDeviceNumber":DEVICE_NUMBER,@"platform":@"1"};
    }else
    {
        dic =@{@"userId": USERID,@"version":VERSION,@"appDeviceNumber":DEVICE_NUMBER,@"platform":@"1",@"param":param};
    }
    
    NSLog(@"请求包参数字典%@",dic);
    NSError *error;
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error: &error];
    
    //压缩
    NSData *compressData = [CompressUtils compressGZipData:jsonData];
    //加密
    NSData *encryptData = [EncryptUtils encryptUseDES:compressData key:DES_SECRET_KEY];

    
    NSString *postStra = [NSString stringWithFormat:MAINURL, urlNum];
//    DMLog(@"postStra====%@",postStra);
    NSURL* postUrl = [NSURL URLWithString:postStra];
    
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:postUrl];
    __block ASIHTTPRequest * blockRequest=request;
    [request appendPostData:encryptData];
    [request setTimeOutSeconds:REQUEST_TIMEOUT];
    [request setCompletionBlock:^{
        
        NSData* requestdata = blockRequest.responseData;
        //解密
        NSData *unEncryptData = [EncryptUtils decryptUseDES:requestdata key:DES_SECRET_KEY];
        //解压缩
        NSData *unConpressData = [CompressUtils unCompressGZipData:unEncryptData];
        NSDictionary* jsDic= [NSJSONSerialization JSONObjectWithData:unConpressData options:0 error:nil];
//        DMLog(@"postStra====%@",jsDic);
        if (complete)
        {
            complete(jsDic);
        }
    }];
    
    [request setFailedBlock:^{
        
        
        NSDictionary *dic=@{@"errorCode":@"12345",@"errorMsg":@"网络不可用，请检查你的网络设置"};
        [UIAlertView alertWithTitle:@"温馨提示" message:@"当前网络不可用，请检查网络设置" buttonTitle:nil];
        complete(dic);
        
        
        
        
    }];
    [request startAsynchronous];
}


+(void)pagingRequestHttp:(NSString *)urlNum paramDic:(NSDictionary *)param pageDic:(NSDictionary *)pagination blockObject:(void (^)(NSDictionary *dic))complete
{
    NSDictionary *dic;
    if (param==nil) {
        
        dic =@{@"userId": USERID,@"version":VERSION,@"appDeviceNumber":DEVICE_NUMBER,@"platform":@"1",@"pagination":pagination};
    }else{
        
        dic=@{@"userId": USERID,@"version":VERSION,@"appDeviceNumber":DEVICE_NUMBER,@"platform":@"1",@"param":param,@"pagination":pagination};
    }
    DMLog(@"%@",dic);
//    NSLog(@"请求包参数字典%@",dic);
    
    NSError *error=nil;
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error: &error];
    //压缩
    NSData *compressData = [CompressUtils compressGZipData:jsonData];
    //加密
    NSData *encryptData = [EncryptUtils encryptUseDES:compressData key:DES_SECRET_KEY];
    NSString *postStra = [NSString stringWithFormat:MAINURL, urlNum];
    NSURL* postUrl = [NSURL URLWithString:postStra];
    
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:postUrl];
    __block ASIHTTPRequest * blockRequest=request;
    [request appendPostData:encryptData];
    [request setTimeOutSeconds:REQUEST_TIMEOUT];
    [request setCompletionBlock:^{
        
        NSData* requestdata = blockRequest.responseData;
        //解密
        NSData *unEncryptData = [EncryptUtils decryptUseDES:requestdata key:DES_SECRET_KEY];
        //解压缩
        NSData *unConpressData = [CompressUtils unCompressGZipData:unEncryptData];
        NSDictionary* jsDic= [NSJSONSerialization JSONObjectWithData:unConpressData options:0 error:nil];
        
        if (complete)
        {
            complete(jsDic);
        }
    }];
    
    [request setFailedBlock:^{
        NSDictionary *dic=@{@"errorCode":@"12345",@"errorMsg":@"当前网络不可用，请检查您的网络设置"};
        [UIAlertView alertWithTitle:@"温馨提示" message:@"当前网络不可用，请检查网络设置" buttonTitle:nil];
        complete(dic);
        
    }];
    [request startAsynchronous];
    
}


@end
