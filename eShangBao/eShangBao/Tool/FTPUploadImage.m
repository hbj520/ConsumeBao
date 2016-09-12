//
//  FTPUploadImage.m
//  eShangBao
//
//  Created by Dev on 16/2/22.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "FTPUploadImage.h"
#import "FTPDownloader.h"
#import "UUID.h"

@implementation FTPUploadImage

-(void)FTPUploadImage:(NSString *)file ImageData:(UIImage *)image
{
    //初始化FTP
    FTPDownloader *ftpDownloader = GetSharedDownloader();
    [ftpDownloader setUser:FTP_USER_NAME andPassword:FTP_PASSWORD];
    [ftpDownloader setDelegate:self];
    [ftpDownloader setType:0];
    
    
    //路径
    NSString *date=[UUID yyyyMMdd_Date];
    NSString *uuid=[UUID uuid];
    NSString * ftpDatePath=[NSString stringWithFormat:@"%@/consumption/%@/%@/",FTP_URL,file,date];
    [ftpDownloader createDirectory:ftpDatePath];
    
    //上传
    NSString *url=[NSString stringWithFormat:@"%@%@.jpg",ftpDatePath,uuid];
    NSData *imageData=UIImageJPEGRepresentation(image, 0.5);
    [ftpDownloader uploadFile:url withData:imageData];
    _imageURL= [NSString stringWithFormat:@"%@/%@.jpg", date, uuid];


}
//上传失败
-(void)fileUploadFailed:(FTPDownloader *)downloader
{
    if ([self.delegate respondsToSelector:@selector(uploadImageComplete:)]) {
        
        [self.delegate uploadImageComplete:nil];
    }
    DMLog(@"上传失败");
}
//上传进度
-(void)fileUploadProgress:(FTPDownloader *)downloader progress:(NSString *)progress
{
    DMLog(@"--->%@",progress);
    if ([progress isEqualToString:@"100%"]) {
        if ([self.delegate respondsToSelector:@selector(uploadImageComplete:)]) {
            
            [self.delegate uploadImageComplete:_imageURL];
        }

    }
    
}
//上传成功
-(void)fileUploadFinished:(FTPDownloader *)downloader
{
        DMLog(@"上传完成");
    
//    if (_type==1) {
////        NSDictionary * dict=@{@"imgUrl":model.shopId};
//        NSNotification * notification=[NSNotification notificationWithName:@"notification" object:nil userInfo: nil];
//        [[NSNotificationCenter defaultCenter]postNotification:notification];
//    }
}



@end
