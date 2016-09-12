//
//  FTPDownloader.m
//  JCZ
//
//  Created by liuyu on 14-10-22.
//  Copyright (c) 2014年 ___DOUMEE___. All rights reserved.
//

#import "FTPDownloader.h"

@implementation FTPDownloader
#if defined(DEBUG)||defined(_DEBUG)
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif
//下载文件
- (void)downloadFile:(NSString *)fileUrl
{
    //CFStreamClientContext  *context = malloc(sizeof(CFStreamClientContext));
    CFStreamClientContext  context = { 0, NULL, NULL, NULL, NULL };
    Boolean                success = true;
    MyStreamInfo *info = CreateMyStreamInfo();
    context.info = info;
    CFStringRef url_temp = (__bridge CFStringRef)fileUrl;
    CFURLRef downloadURL = CFURLCreateWithString(kCFAllocatorDefault, url_temp, NULL);
    
	Byte *byteData = (Byte *)malloc(kMyBufferSize);
	
    writeStream = CFWriteStreamCreateWithBuffer(kCFAllocatorDefault, byteData, kMyBufferSize);
    assert(writeStream != NULL);
    info->writeStream = writeStream;
    readStream = CFReadStreamCreateWithFTPURL(kCFAllocatorDefault, downloadURL);
    assert(readStream != NULL);
    info->readStream = readStream;
    
    success = CFWriteStreamOpen(writeStream);
    if (success) {
        success = CFReadStreamSetClient(readStream, kNetworkEvents, (CFReadStreamClientCallBack)DownloadDataCallBack, &context);
        if (success) {
            CFReadStreamScheduleWithRunLoop(readStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
            [self setStreamWithUserAndPassword:1];
            CFReadStreamSetProperty(readStream, kCFStreamPropertyFTPFetchResourceInfo, kCFBooleanTrue);
            success = CFReadStreamOpen(readStream);
            if (success == false) {
                NSLog(@"CFReadStreamOpen failed\n");
            }
        } else {
            NSLog(@"CFReadStreamSetClient failed\n");
        }
    } else {
        NSLog(@"CFWriteStreamOpen failed\n");
    }
}
//上传文件
- (void)uploadFile:(NSString *)fileUrl withData:(NSData *)data
{
    CFStreamClientContext  context = { 0, NULL, NULL, NULL, NULL };
    Boolean                success = true;
    MyStreamInfo *info = CreateMyStreamInfo();
    context.info = info;
	
    CFStringRef url_temp = (__bridge CFStringRef)fileUrl;
    CFURLRef uploadURL = CFURLCreateWithString(kCFAllocatorDefault, url_temp, NULL);

	NSUInteger len = [data length];
	Byte *byteData = (Byte *)malloc(len);
	memcpy(byteData,[data bytes], len);
    info->uploadTotalSize = len;
	
	readStream = CFReadStreamCreateWithBytesNoCopy(kCFAllocatorDefault, byteData, len, kCFAllocatorNull);
	writeStream = CFWriteStreamCreateWithFTPURL(kCFAllocatorDefault, uploadURL);
    assert(readStream != NULL);
    assert(writeStream != NULL);
    info->readStream = readStream;
    info->writeStream = writeStream;
    
	success = CFReadStreamOpen(readStream);
    if (success) {
        success = CFWriteStreamSetClient(writeStream, kNetworkEvents, (CFWriteStreamClientCallBack)UploadDataCallBack, &context);
        
        
        
        
        if (success) {
            CFWriteStreamScheduleWithRunLoop(writeStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
            [self setStreamWithUserAndPassword:2];
            success = CFWriteStreamOpen(writeStream);
            if (success == false) {
                NSLog(@"CFWriteStreamOpen failed\n");
                MyStreamInfoDestroy(info);
            }
        } else {
            NSLog(@"CFWriteStreamSetClient failed\n");
            MyStreamInfoDestroy(info);
        }
    } else {
        NSLog(@"CFReadStreamOpen failed\n");
        MyStreamInfoDestroy(info);
    }

}
//创建目录
- (void)createDirectory:(NSString *)directoryUrl
{
#if defined(DEBUG)||defined(_DEBUG)
    NSLog(@"debug123");
#endif
    CFStreamClientContext  context = { 0, NULL, NULL, NULL, NULL };
    Boolean                success = true;
	
    MyStreamInfo *info = CreateMyStreamInfo();
    context.info = info;
    CFStringRef url_temp = (__bridge CFStringRef)directoryUrl;
    CFURLRef url = CFURLCreateWithString(kCFAllocatorDefault, url_temp, NULL);
    readStream = CFReadStreamCreateWithFTPURL(kCFAllocatorDefault, url);
    writeStream = CFWriteStreamCreateWithFTPURL(kCFAllocatorDefault, url);
    //assert(readStream != NULL);
    assert(writeStream != NULL);
    //CFRelease(uploadURL);
    info->readStream = readStream;
    info->writeStream = writeStream;
    
    success = CFReadStreamOpen(readStream);
    if (success) {
        success = CFWriteStreamSetClient(writeStream, kNetworkEvents, (CFWriteStreamClientCallBack)CreateDirectoryCallBack, nil);
        if (success) {
            CFWriteStreamScheduleWithRunLoop(writeStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
            [self setStreamWithUserAndPassword:0];
            success = CFWriteStreamOpen(writeStream);
            if (success == false) {
                NSLog(@"CFWriteStreamOpen failed\n");
            }
        } else {
            NSLog(@"CFWriteStreamSetClient failed\n");
        }
    } else {
        NSLog(@"CFReadStreamOpen failed\n");
    }
}

#pragma mark UploadCallBack
static void* DownloadDataCallBack(CFReadStreamRef readStream, CFStreamEventType type, void * clientCallBackInfo)
{
    static unsigned int        offset;
    CFNumberRef       cfSize;
    
    MyStreamInfo *info = (MyStreamInfo *)clientCallBackInfo;
    FTPDownloader *downloader = GetSharedDownloader();
    //下载完成，文件目录已经成功创建
    if (type == kCFStreamEventEndEncountered)
    {
        NSLog(@"文件下载完成");
        CFWriteStreamClose(info->writeStream);
        CFReadStreamClose((info->readStream));
        if ([downloader.delegate  respondsToSelector:@selector(fileDownloadFinished: data:)])
        {
            NSData *data = [NSData dataWithBytes:info->buffer length:(NSInteger)info->fileSize];
            [downloader.delegate performSelector:@selector(fileDownloadFinished:data:) withObject:downloader withObject:data];
        }
        goto exit;
    }
    //出错
    if (type == kCFStreamEventErrorOccurred)
    {
        NSLog(@"一个错误发生了");
    }
    //(流可以接受写入数据（用于写入流）)可上传数据
    if (type == kCFStreamEventCanAcceptBytes)
    {
        
    }
    //(有数据可以读取)可上传数据
    if (type == kCFStreamEventHasBytesAvailable)
    {
        CFIndex bytesRead = CFReadStreamRead(info->readStream, info->buffer+info->fileSize, kMyBufferSize);
        info->fileSize += bytesRead;
        if (bytesRead > 0)
        {
            CFIndex bytesWritted = 0;
            while (bytesRead > bytesWritted)
            {
                CFIndex result = CFWriteStreamWrite(info->writeStream, info->buffer + bytesWritted, bytesRead - bytesWritted);
                if (result <= 0)
                {
                    NSLog(@"无法下载写入");
                    return NULL;
                }
                bytesWritted += result;
            }
            info->totalBytesWritten += bytesWritted;
        }
    }
    if (type == kCFStreamEventOpenCompleted)
    {
        cfSize = CFReadStreamCopyProperty(info->readStream, kCFStreamPropertyFTPResourceSize);
        offset = 0;
        info->fileSize = 0;
    }
    
    return NULL;
exit:
    MyStreamInfoDestroy(info);
    CFRunLoopStop(CFRunLoopGetCurrent());
    return NULL;
}
#pragma mark DownloadCallBack
static void UploadDataCallBack(CFWriteStreamRef writeStream, CFStreamEventType type, void * clientCallBackInfo)
{
    MyStreamInfo     *info = (MyStreamInfo *)clientCallBackInfo;
    CFIndex          bytesRead;
    CFIndex          bytesAvailable;
    CFIndex          bytesWritten;
    FTPDownloader *downloader = GetSharedDownloader();
    //下载完成，文件目录已经成功创建
    if (type == kCFStreamEventEndEncountered)
    {
        NSLog(@"目录创建完成");
        if ([downloader.delegate  respondsToSelector:@selector(fileUploadFinished:)])
        {
            [downloader.delegate performSelector:@selector(fileUploadFinished:) withObject:downloader];
        }
        if ([downloader.delegate  respondsToSelector:@selector(fileUploadProgress:progress:)])
        {
            [downloader.delegate performSelector:@selector(fileUploadProgress:progress:) withObject:downloader withObject:@"100%"];
        }
        /*
        if ([downloader.delegate  respondsToSelector:@selector(fileUploadFinished:data:)])
        {
            NSData *data = [NSData dataWithBytes:info->buffer length:(NSInteger)info->fileSize];
            [downloader.delegate performSelector:@selector(fileUploadFinished:data:) withObject:downloader withObject:data];
        }
         */
        goto exit;
    }
    //出错
    if (type == kCFStreamEventErrorOccurred)
    {
        CFStreamError error = CFReadStreamGetError(info->readStream);
        CFReadStreamGetStatus(info->readStream);
        
        DMLog(@"文件上传失败  %@", error);
        if ([downloader.delegate  respondsToSelector:@selector(fileUploadFailed:)])
        {
            [downloader.delegate performSelector:@selector(fileUploadFailed:) withObject:downloader];
        }
//        [UIAlertView alertWithTitle:@"图片上传失败" message:nil buttonTitle:nil];
        goto exit;
    }
    //(流可以接受写入数据（用于写入流）)可上传数据
    if (type == kCFStreamEventCanAcceptBytes)
    {
        if (info->leftOverByteCount > 0) {
            bytesRead = 0;
            bytesAvailable = info->leftOverByteCount;
        } else {
            bytesRead = CFReadStreamRead(info->readStream, info->buffer, kMyBufferSize);
            if (bytesRead < 0) {
                fprintf(stderr, "CFReadStreamRead returned %ld\n", bytesRead);
                CFReadStreamGetStatus(info->readStream);
                goto exit;
            }
            bytesAvailable = bytesRead;
        }
        bytesWritten = 0;
        
        if (bytesAvailable == 0) {
//            NSLog(@"文件上传进度--->100%%");
            CFWriteStreamClose(info->writeStream);
            if ([downloader.delegate  respondsToSelector:@selector(fileUploadFinished:)])
            {
                [downloader.delegate performSelector:@selector(fileUploadFinished:) withObject:downloader];
            }
        } else {
            bytesWritten = CFWriteStreamWrite(info->writeStream, info->buffer, bytesAvailable);
            if (bytesWritten > 0) {
                
                info->totalBytesWritten += bytesWritten;
                if (bytesWritten < bytesAvailable) {
                    info->leftOverByteCount = bytesAvailable - bytesWritten;
                    memmove(info->buffer, info->buffer + bytesWritten, info->leftOverByteCount);
                }
                else
                {
                    info->leftOverByteCount = 0;
                }
                int percentProgress = info->totalBytesWritten*100/info->uploadTotalSize;
                NSString *progress = [NSString stringWithFormat:@"%d%%", percentProgress];
                NSLog(@"文件上传进度--->%@", progress);
                if ([downloader.delegate  respondsToSelector:@selector(fileUploadProgress:progress:)])
                {
                    [downloader.delegate performSelector:@selector(fileUploadProgress:progress:) withObject:downloader withObject:progress];
                }
            }
            else
                if (bytesWritten < 0) {
                NSLog(@"CFWriteStreamWrite returned %ld\n", bytesWritten);
            }
        }
    }
    //(有数据可以读取)可上传数据
    if (type == kCFStreamEventHasBytesAvailable)
    {
        
    }
    return;
exit:
    MyStreamInfoDestroy(info);
    CFRunLoopStop(CFRunLoopGetCurrent());
    return;
}
//设置用户名和密码
- (void)setUser:(NSString *)userName andPassword:(NSString *)password
{
    _userName = userName;
    _password = password;
}
//0，都进行, 1设置读取（为下载）, 2为写入（为上传）
- (void)setStreamWithUserAndPassword:(int)tag
{
    Boolean success;
    assert(_userName != nil);
    assert(_password != nil);
    CFStringRef user = (__bridge CFStringRef)_userName;
    CFStringRef pwd = (__bridge CFStringRef)_password;
    
    if (tag == 0||tag==1)
    {
        success = CFReadStreamSetProperty(readStream, kCFStreamPropertyFTPUserName, user);
        assert(success);
        success = CFReadStreamSetProperty(readStream, kCFStreamPropertyFTPPassword, pwd);
        assert(success);
    }
    if (tag == 0||tag==2)
    {
        success = CFWriteStreamSetProperty(writeStream, kCFStreamPropertyFTPUserName, user);
        assert(success);
        success = CFWriteStreamSetProperty(writeStream, kCFStreamPropertyFTPPassword, pwd);
        assert(success);
    }
}
#pragma mark CreateDirectory
static void CreateDirectoryCallBack(CFReadStreamRef readStream, CFStreamEventType type, void * clientCallBackInfo)
{
    MyStreamInfo *info = (MyStreamInfo *)clientCallBackInfo;
    FTPDownloader *downloader = GetSharedDownloader();
    //下载完成，文件目录已经成功创建
    if (type == kCFStreamEventEndEncountered)
    {
        NSLog(@"文件目录完成");
        if ([downloader.delegate  respondsToSelector:@selector(fileDownloadFinished: data:)])
        {
            NSData *data = [NSData dataWithBytes:info->buffer length:(NSInteger)info->fileSize];
            [downloader.delegate performSelector:@selector(fileDownloadFinished:data:) withObject:downloader withObject:data];
        }
    }
    //出错
    if (type == kCFStreamEventErrorOccurred)
    {
        NSLog(@"文件目录无法创建");
    }
    //(流可以接受写入数据（用于写入流）)可上传数据
    if (type == kCFStreamEventCanAcceptBytes)
    {
        
    }
    //(有数据可以读取)可上传数据
    if (type == kCFStreamEventHasBytesAvailable)
    {
    }
    if (type == kCFStreamEventOpenCompleted)
    {
    }
    return;
}
@end
MyStreamInfo * CreateMyStreamInfo()
{
    MyStreamInfo *info = malloc(sizeof(MyStreamInfo));
    info->proxyDict         = NULL;
    info->fileSize          = 0;
    info->totalBytesWritten = 0;
    info->leftOverByteCount = 0;
    return info;
}
const CFOptionFlags kNetworkEvents =
kCFStreamEventOpenCompleted
| kCFStreamEventHasBytesAvailable
| kCFStreamEventEndEncountered
| kCFStreamEventCanAcceptBytes
| kCFStreamEventErrorOccurred;


static FTPDownloader *sharedDownloader = nil;
FTPDownloader *GetSharedDownloader()
{
    if (sharedDownloader == nil)
    {
        sharedDownloader = [[FTPDownloader alloc] init];
    }
    return sharedDownloader;
}
static void MyStreamInfoDestroy(MyStreamInfo * info)
{
    assert(info != NULL);
    
    if (info->readStream) {
        CFReadStreamUnscheduleFromRunLoop(info->readStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
        (void) CFReadStreamSetClient(info->readStream, kCFStreamEventNone, NULL, NULL);
        
        /* CFReadStreamClose terminates the stream. */
        CFReadStreamClose(info->readStream);
        CFRelease(info->readStream);
    }
	
    if (info->writeStream) {
        CFWriteStreamUnscheduleFromRunLoop(info->writeStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
        (void) CFWriteStreamSetClient(info->writeStream, kCFStreamEventNone, NULL, NULL);
        
        /* CFWriteStreamClose terminates the stream. */
        CFWriteStreamClose(info->writeStream);
        CFRelease(info->writeStream);
    }
	
    if (info->proxyDict) {
        CFRelease(info->proxyDict);             // see discussion of <rdar://problem/3745574> below
    }
    
    free(info);
}