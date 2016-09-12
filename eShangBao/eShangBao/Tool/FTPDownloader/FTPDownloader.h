//
//  FTPDownloader.h
//  JCZ
//
//  Created by liuyu on 14-10-22.
//  Copyright (c) 2014年 ___DOUMEE___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTPDownloaderDelegate.h"
@class FTPDownloader;
#define kMyBufferSize  32768
typedef struct MyStreamInfo {
    
    CFWriteStreamRef  writeStream;              //write stream
    CFReadStreamRef   readStream;               //read stream
    CFDictionaryRef   proxyDict;                //the user and pwd`s storyge
    SInt64            fileSize;                 //upload`s readsize,change with readstream
    SInt64            uploadTotalSize;          //upload`s totalsize,init with readstream`buffer
    UInt32            totalBytesWritten;        //download`s totalsize,init with readstream`buffer
    UInt32            leftOverByteCount;        //download`s leftover bytes-count, release it with download
    UInt8             buffer[kMyBufferSize];    //the buffer, maxvalue is 'kMyBufferSize'`size
} MyStreamInfo;

extern const CFOptionFlags kNetworkEvents;


@interface FTPDownloader : NSObject
{
    CFWriteStreamRef       writeStream;
    CFReadStreamRef        readStream;
    NSString *_userName;
    NSString *_password;
}
@property (nonatomic,copy) NSString* imagePath;//图片子目录
@property id<FTPDownloaderDelegate> delegate;
@property int type;
//设置用户名和密码
- (void)setUser:(NSString *)userName andPassword:(NSString *)password;
//下载文件
- (void)downloadFile:(NSString *)fileUrl;
//上传文件
- (void)uploadFile:(NSString *)fileUrl withData:(NSData *)data;
//创建目录
- (void)createDirectory:(NSString *)dicrectoryUrl;
@end
MyStreamInfo * CreateMyStreamInfo();
FTPDownloader *GetSharedDownloader();
static void MyStreamInfoDestroy(MyStreamInfo * info);