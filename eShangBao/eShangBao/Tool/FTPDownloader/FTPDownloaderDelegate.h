//
//  FTPDownloaderDelegate.h
//  JCZ
//
//  Created by liuyu on 14-10-23.
//  Copyright (c) 2014年 ___DOUMEE___. All rights reserved.
//
#import <Foundation/Foundation.h>
@class FTPDownloader;

@protocol FTPDownloaderDelegate <NSObject>
@optional
//文件下载完成
- (void)fileDownloadFinished:(FTPDownloader *)downloader data:(NSData *)data;
//文件上传完成
- (void)fileUploadFinished:(FTPDownloader *)downloader;
//文件目录创建完成
- (void)directoryCreatedFinished:(FTPDownloader *)downloader;
//文件上传进度
- (void)fileUploadProgress:(FTPDownloader *)downloader progress:(NSString *)progress;
//上传文件失败
- (void)fileUploadFailed:(FTPDownloader *)downloader;

@end
