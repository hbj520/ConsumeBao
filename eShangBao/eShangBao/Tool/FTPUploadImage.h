//
//  FTPUploadImage.h
//  eShangBao
//
//  Created by Dev on 16/2/22.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTPDownloaderDelegate.h"


@protocol uploadImageDelegate <NSObject>

/**
 *  完成上传的代理
 *
 *  @param imageUrl 上传的路径  失败的为nil
 */
-(void)uploadImageComplete:(NSString *)imageUrl;


@end




@interface FTPUploadImage : NSObject<FTPDownloaderDelegate>

@property(nonatomic,strong)NSString *imageURL;
@property(nonatomic,strong)id<uploadImageDelegate>delegate;
@property(nonatomic,assign)int type;
/**
 *  上传图片至FTP
 *
 *  @param file  上传至的文件夹
 *  @param image 上传的图片
 */
-(void)FTPUploadImage:(NSString *)file ImageData:(UIImage *)image;

@end
